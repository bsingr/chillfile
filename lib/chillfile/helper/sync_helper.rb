module Chillfile::SyncHelper
  # CREATED
  def create_doc(checksum, path)
    doc = Chillfile::Asset.new(:checksum => checksum, :path => path)
    doc.save
    begin
      file = File.open(path)
      doc.create_attachment(:file => file, :name => "master")
    ensure
      file.close
    end
    doc
  end
  
  # DELETED
  def delete_doc(doc)
    doc.deleted = true
    doc.save
    doc
  end

  # COPIED
  def copy_doc(doc, path)
    doc = create_doc(doc.checksum, path)
    
    # TODO keep metadata => make a deep clone here...
    
    doc
  end

  # MOVED
  def update_doc_path(doc, new_path)
    doc.path = new_path
    doc
  end

  # MODIFIED
  def update_doc_attachment(doc, new_checksum)
    doc.checksum = new_checksum
    begin
      file = File.open(doc.path)
      doc.update_attachment(:file => file, :name => "master")
    ensure
      file.close
    end
    doc
  end
  
  # FINALIZER
  def doc_save!(doc)
    doc.save
  end
end
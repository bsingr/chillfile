module Chillfile::SyncHelper
  # CREATED
  def create_doc(checksum, path)
    doc = Chillfile::Model::SyncFile.new(:checksum => checksum, :paths => [path])
    doc.save
    begin
      file = File.open(path)
      doc.create_attachment(:file => file, :name => "master")
    ensure
      file.close
    end
    doc
  end

  # COPIED
  def update_doc_add_path(doc, path)
    update_doc_paths(doc, [], [path])
  end

  # MOVED/COPIED
  def update_doc_paths(doc, del_paths = [], add_paths = [])
    # del old paths
    del_paths.each do |path|
      doc.paths.delete(path)
    end

    # add new paths
    doc.paths = doc.paths + add_paths
  
    doc
  end

  # MODIFIED
  def update_doc_attachment(doc, new_checksum)
    doc.checksum = new_checksum
    begin
      file = File.open(doc.paths.first)
      doc.update_attachment(:file => file, :name => "master")
    ensure
      file.close
    end
    doc
  end
  
  # FINALIZER
  def doc_save!(doc)
    if doc.paths.empty?
      doc.deleted = true
    elsif doc.deleted
      doc.deleted = false
    end
    doc.save
  end
end
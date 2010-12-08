module Chillfile::Sync 
  class << self
    include Chillfile::SyncHelper

    def process!(comparator, progressbar = nil)
      @progressbar = progressbar
      
      process_deleted(comparator)
      process_moved(comparator)
      process_modified(comparator)
      process_created(comparator)
      
      true
    end
  
    private
    
    # deleted
    def process_deleted(comparator)
      process_list(comparator.deleted, "Delete") do |checksum, path|
        for_doc_with(checksum) do |doc|
          update_doc_paths(doc, [path])
        end
      end
    end
    
     # moved files
    def process_moved(comparator)
      process_list(comparator.moved, "Move") do |checksum, paths|
        for_doc_with(checksum) do |doc|
          update_doc_paths(doc, paths[:old_paths], paths[:new_paths])
        end
      end
    end
    
    def process_modified(comparator)
      # modified files
      process_list(comparator.modified, "Modify") do |path, checksums|
        for_doc_with(checksums[:old_checksum]) do |doc|
          
          # split it up if there is more than one path
          if doc.paths.size > 1
            
            # remove the old path from the list
            base_doc = update_doc_paths(doc, [path])
            
            # new forked doc
            fork_doc = create_doc(checksums[:new_checksum], path)
            
            [base_doc, fork_doc]
          else
            update_doc_attachment(doc, checksums[:new_checksum])
          end          
        end
      end
    end
    
    def process_created(comparator)
      # created files
      process_list(comparator.created, "Create") do |checksum, path|
        for_doc_with(checksum) do |doc|
          if doc
            update_doc_add_path(doc, path)
          else
            create_doc(checksum, path)
          end
        end
      end
    end
    
    # wrapper outer
    def process_list(list, title, &block)
      return true if list.empty?
      
      list_iterator = lambda do |notifier|
        list.each do |args|
          block.call(*args)
          notifier.call if notifier
        end
      end
      
      if @progressbar
        @progressbar.call({:name => title, :size => list.size}, list_iterator)
      else
        list_iterator.call(nil)
      end
    end
  
    # wrapper
    def for_doc_with(checksum, &block)
      old_doc = Chillfile::Model::SyncFile.by_checksum(:key => checksum).first
      new_doc_or_docs = block.call(old_doc)
      if new_doc_or_docs.is_a? Array
        new_doc_or_docs.each{|d| doc_save!(d)}
      else
        doc_save!(new_doc_or_docs)
      end
    end
  end
end
module Chillfile
  module Sync
    class << self      
      def process!(comparator, progressbar = nil)
        @progressbar = progressbar
        
        # deleted
        process_list(comparator.deleted, "Delete") do |checksum, path|
          for_doc_with(checksum) do |doc|
            if doc.paths.size > 1
              update_doc_paths(doc, [path])
            else
              delete_doc(doc)
            end
          end
        end
        
        # moved files
        process_list(comparator.moved, "Move") do |checksum, paths|
          for_doc_with(checksum) do |doc|
            update_doc_paths(doc, paths[:old_paths], paths[:new_paths])
          end
        end
      
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
    
      private
    
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
    
      # DELETED
      def delete_doc(doc)
        doc.deleted = true
        doc.paths = []
        doc
      end
      
      # wrapper outer
      def process_list(list, title, &block)
        return true if list.empty?
        
        list_iterator = lambda do |notifier|
          list.each do |args|
            block.call(*args)
          end
          notifier.call if notifier
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
          new_doc_or_docs.each{|d| d.save}
        else
          new_doc_or_docs.save
        end
      end
    end
  end
end
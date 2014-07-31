require 'FileReader'
require 'Database'
require 'Logger'
require 'XMLDocument'

module ACMEJobStreamerImport

  # Manages the actual import algorithm
  class ABCImporter

    # Read our stats
    attr_reader :updates, :deletes, :inserts, :processed_records, :processed_files
    attr_accessor :database

    include ACMEJobStreamerImport

    def initialize config

      @updates = 0
      @inserts = 0
      @deletes = 0
      @processed_records = 0
      @processed_files = 0

      @file_reader = FileReader.new config
      @database    = Database.new   config
      @logger      = Logger.new     config

      @lookup = @database.get_node_lookup_hash
    end

    # Retuns the number of queries performed on the DB by this instance
    def get_queries
      @database.queries
    end

    # Reloads the lookup hash of persID => hash
    def refresh_lookup
      @lookup = @database.get_node_lookup_hash
    end

    def node_is_valid? node
      (node.key? 'NewLogin') && (!!node['NewLogin'].match(/^[^@]+@[^@]+\.[^@]{2,}$/))
    end

    # Process a file, performing the actual modifications to the DB
    #
    # [file] The absolute file path of the file
    # [type] A symbol, one of :addition, :deletion
    def process_file file, type

      hash = @file_reader.get_hash_for_file file

      if @database.match_exists_for_file_and_hash? file, hash

        @logger.info "Skipping " + file + ", has not changed"

      else

        @logger.info "Processing file: " + file

        xml = XMLDocument.new (File.read file)

        if xml.validates?

          @processed_files +=1

          while xml.has_node?

            @processed_records += 1

            node = xml.pop_node!

            ## Skip if it doesn't validate
            next unless (type == :deletion || (self.node_is_valid? node))

            if @database.person_exists? node['PersID'], @lookup

              if type == :deletion
                @database.delete_person! node['PersID']
                @deletes += 1
                @logger.info "Deleted person with PersID: " + node['PersID']
                next
              end

              if @database.person_hash_changed? node['PersID'], node['HashValue'], @lookup
                @database.update_person! node
                @updates +=1
                @logger.info "Updated person with PersID: " + node['PersID']
              end

            else
              if type == :deletion
                next
              end
              @database.create_person! node
              @inserts += 1
              @logger.info "Created person with PersID: " + node['PersID']
            end
          end
        else

          @logger.fatal "File with filename " + file +  " corrupt or not valid"

        end

        @database.add_hash_for_file file, hash

      end

    end

  end

end

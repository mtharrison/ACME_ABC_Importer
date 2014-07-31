require 'digest'

module ACMEJobStreamerImport

  # Simply gets the file locations for import/delete files
  # also hashes their content for comparison to a stored hash
  class FileReader

    def initialize config
      @config = config['files']
    end

    # Return an array of addition files' names
    def get_import_files
      Dir.glob @config['addition_files_pattern']
    end

    # Return an array of deletion files' names
    def get_deletion_files
      Dir.glob @config['deletion_files__pattern']
    end

    # Reads the content of the file named by `file` and returns an MD5 hash
    def get_hash_for_file file
      contents = File.read file
      # The XML we recieve is not UTF-8 but latin-1
      # If we don't convert everything will be fine until we need non ascii
      # characters (like umlauts/french acutes etc)
      contents.encode! "UTF-8", "ISO-8859-1"
      contents.force_encoding "UTF-8"
      Digest::MD5.hexdigest contents
    end

  end

end

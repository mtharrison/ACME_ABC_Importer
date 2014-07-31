require 'mysql2'
require 'digest'

# Contains all the classes for the ACME ABC Job Streamer importer tool
module ACMEJobStreamerImport

  # This class manages all the database connections and queries required
  # for funcitoning of the importer. Creates MD5 hashes for objects and
  # compares them to stored hashes. Also keeps track of the number of queries
  # statistics. Manages acme_id => abc_code mappings too
  class Database

    # Contains the mysql connection
    attr_accessor :client
    # The number of queries this instance has performed
    attr_accessor :queries
    
    # Contains a service mappings hash
    attr_accessor :service_mappings
    # Contains a geo mappings hash
    attr_accessor :geo_mappings
    # Contains a practice mappings hash
    attr_accessor :practice_mappings

    # The constructor for the class
    #
    # [config]  The global configuration
    def initialize config
      @config = config['database']

      @queries = 0
      connect
      load_mappings
    end

    # Instead of querying mappings for each node just load them all into
    # a hash at the start that we can query ad-hoc
    def load_mappings
      mappings = {
        :@service_mappings => 'abc_service_mapping',
        :@geo_mappings => 'abc_geo_mapping',
        :@practice_mappings => 'abc_practice_mapping',
      }

      mappings.each do |var_name, table_name|
        rows = @client.query "SELECT GROUP_CONCAT(acme_id) as id, abc_code FROM #{table_name}  GROUP BY abc_code"
        rows = rows.to_a
        hash = {}
        rows.each{ |row| hash[row['abc_code']] = row['id'].split ',' }

        instance_variable_set var_name, hash
      end
    end

    # Returns an MD5 hash of the given text
    #
    # [text]  The text to hash
    def make_hash text
      Digest::MD5.hexdigest text
    end

    # Returns a huge hash for persID => hash lookups
    # rather then hitting the DB for each check
    def get_node_lookup_hash
      @queries += 1
      results = @client.query "SELECT abc_persid, abc_lasthash FROM #{@config['streamer_table']}"
      hash_tbl = {}
      results.each{ |res| hash_tbl[res['abc_persid']] = res['abc_lasthash'] }
      hash_tbl
    end

    # Actually connects to the mysql instance
    def connect

      @client = Mysql2::Client.new(:host => @config['host'], :username => @config['user'], :password => @config['password'], :database => @config['database'])
    end

    # Check the file_hashes table to look for a match
    # if a match exists it means this file can be skipped
    #
    # [afile] The filename to check for
    # [ahash] The hash to check for
    def match_exists_for_file_and_hash? afile, ahash
      @queries += 1
      results = @client.query "SELECT * FROM #{@config['abc_file_hashes_table']} t1 WHERE t1.filename = '#{afile}' AND t1.hash = '#{ahash}'"
      results.count > 0
    end

    # Check if a records already exists for the person
    # uses an in memory hash rather than hitting the DB
    #
    # [persID] The persID to search for
    # [lookup] The hash to look inside of
    def person_exists? persID, lookup
      lookup.has_key? persID
    end

    # Deletes the person specified in the persID
    #
    # [persID] The persID to delete
    def delete_person! persID
      @queries += 1
      @client.query "DELETE FROM #{@config['streamer_table']} WHERE abc_persid = '#{persID}'"
    end

    # Tests if the hash for a person has changed
    # If it hasn't changed, there's no need to process the node
    #
    # [persID] The persID to search
    # [hash] The hash to compare
    # [lookup] The ruby hash to look inside of
    def person_hash_changed? persID, hash, lookup
      lookup[persID] != hash
    end

    # Updates a record with the given node
    # Assumed to be different by now (use person_hash_changed? first!)
    # Uses the PersID in the node (hash) to locate the recors
    #
    # [node] The node (ruby hash) of attributes to update
    def update_person! node
      @queries += 1
      sql = "UPDATE #{@config['streamer_table']}
      SET
      `name`              =  '#{node['PersName']}',
      `email`             =  '#{node['NewLogin']}',
      `location`          =  '#{convert_abc_code_list(node, :geo)}',
      `area`              =  '#{convert_abc_code_list(node, :practice)}',
      `title`             =  '#{convert_abc_code_list(node, :service)}',
      `type`              =  '#{convert_temp_perm_string(node['TempOrPerm'])}',
      `sector`            =  '#{convert_sector_string(node['InCode'])}',
      `abc_lasthash`      =  '#{node['HashValue']}',
      `updated`           =  '#{Time.now}'
      WHERE `abc_persid`  = '#{node['PersID']}'"

      @client.query sql
    end

    def convert_experience_to_solicitor_id experience

      experience = experience.to_i

      case 
        when experience >= 6
          return [5,6]
        when experience >= 4
          return [4]
        when experience >=2
          return [3]
        when experience >=1
          return [2]
      end

      [1]

    end

    def convert_abc_code_list node, type
      case type
      when :geo
        mapping = @geo_mappings
        list = node['AreaCode']
      when :practice
        mapping = @practice_mappings
        list = node['SkillCode']
      when :service
        mapping = @service_mappings
        list = node['JobTitleCode']
      end

      output_array = []

      list.split(',').each do |code|
        # Solicitor's work a bit differently
        # in that they need to check the experience level too
        # to determine which type of solicitor they are
        if code == "SOL" && type == :service
          ids = convert_experience_to_solicitor_id node['Experience']
          ids.each{ |id| output_array.push id }
        else
          output_array.push mapping[code] if mapping.has_key? code
        end
      end

      output_array.flatten.uniq.map(&:to_i).sort.join ','

    end

    # Creates a record with the given node
    # Assumed to not exisr by now (use person_exists? first!)
    #
    # [node] The node (ruby hash) of attributes to create
    def create_person! node
      @queries += 1
      @client.query "INSERT INTO #{@config['streamer_table']}
      (`name`, `email`, `location`, `area`, `title`, `type`, `sector`, `created`, `updated`, `abc_persid`, `abc_lasthash`)
      VALUES
      ('#{node['PersName']}', '#{node['NewLogin']}', '#{convert_abc_code_list(node, :geo)}', '#{convert_abc_code_list(node, :practice)}', '#{convert_abc_code_list(node, :service)}', '#{convert_temp_perm_string(node['TempOrPerm'])}', '#{convert_sector_string(node['InCode'])}', '#{Time.now}', '#{Time.now}', '#{node['PersID']}', '#{node['HashValue']}')"
    end

    # Creates a file => hash record
    #
    # [filename] the name of the file
    # [hash] the hash to associate with the file
    def add_hash_for_file filename, hash
      @client.query "INSERT INTO #{@config['abc_file_hashes_table']} (filename, hash) VALUES ('#{filename}', '#{hash}')"
    end

    # Converts between the XML sector string in the dump and the one used 
    # internaly to the acme job streamer
    #
    # [sector_string] the ABC code in the XML to be converted
    def convert_sector_string sector_string
      case sector_string
      when "IH"
        "1"
      when "PP"
        "2"
      when "_"
        "1,2"
      else
        ""
      end
    end

    # Converts between the XML Temp/Perm string in the dump and the one used 
    # internaly to the acme job streamer
    #
    # [temp_perm_string] the ABC code in the XML to be converted
    def convert_temp_perm_string temp_perm_string
      case temp_perm_string
      when "0,0"
        ""
      when "1,0"
        "2"
      when "0,1"
        "1"
      when "1,1"
        "1,2"
      else
        ""
      end
    end

  end

end

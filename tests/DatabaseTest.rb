require_relative './bootstrap.rb'

gem 'minitest'
require 'minitest/autorun'
require 'yaml'
require 'Database'

class DatabaseTest < Minitest::Test

  include ACMEJobStreamerImport

  def setup
    @config = CONFIG['database']
    @database = Database.new CONFIG
    @database.connect # We've changed the DB to test

  end

  def teardown
    @database.client.query "DELETE FROM #{@config['abc_file_hashes_table']}"
    @database.client.query "DELETE FROM #{@config['streamer_table']}"
  end

  def test_can_check_for_file_hash_match

    @database.client.query "INSERT INTO #{@config['abc_file_hashes_table']} VALUES (1, 'Testfile1', '84d9cfc2f395ce883a41d7ffc1bbcf4e')"

    assert (@database.match_exists_for_file_and_hash? 'Testfile1', '84d9cfc2f395ce883a41d7ffc1bbcf4e')
    assert !(@database.match_exists_for_file_and_hash? 'Testfile2', 'd58e3582afa99040e27b92b13c8f2280')
  end

  def test_person_exists?
    # Add a person
    @database.client.query "INSERT INTO #{@config['streamer_table']} VALUES (1, 'Stephen Rafferty', '057192sr@live.com', '29', '0,79,88', '0,8', '0,1', '2,0', '2011-11-02 20:04:37', '2011-11-02 20:04:37', 'abcdef', 'ce86d7d02a229acfaca4b63f01a1171b')"

    lookup = @database.get_node_lookup_hash

    assert (@database.person_exists? 'abcdef', lookup)
    assert !(@database.person_exists? 'defghi', lookup)
  end

  def test_delete_person!
    @database.client.query "INSERT INTO #{@config['streamer_table']} VALUES (1, 'Stephen Rafferty', '057192sr@live.com', '29', '0,79,88', '0,8', '0,1', '2,0', '2011-11-02 20:04:37', '2011-11-02 20:04:37', 'abcdef', 'ce86d7d02a229acfaca4b63f01a1171b')"

    lookup = @database.get_node_lookup_hash

    assert (@database.person_exists? 'abcdef', lookup)
    @database.delete_person! 'abcdef'

    lookup = @database.get_node_lookup_hash
    assert !(@database.person_exists? 'abcdef', lookup)
  end

  def test_person_hash_changed?
    @database.client.query "INSERT INTO #{@config['streamer_table']} VALUES (1, 'Stephen Rafferty', '057192sr@live.com', '29', '0,79,88', '0,8', '0,1', '2,0', '2011-11-02 20:04:37', '2011-11-02 20:04:37', 'abcdef', 'ce86d7d02a229acfaca4b63f01a1171b')"

    lookup = @database.get_node_lookup_hash

    assert !(@database.person_hash_changed? 'abcdef', 'ce86d7d02a229acfaca4b63f01a1171b', lookup)
    assert  (@database.person_hash_changed? 'abcdef', '4b63f01a1171bce86d7d02a229acfaca', lookup)
  end

  def test_update_person!
    @database.client.query "INSERT INTO #{@config['streamer_table']} VALUES (1, 'Stephen Rafferty', '057192sr@live.com', '29', '0,79,88', '0,8', '0,1', '2,0', '2011-11-02 20:04:37', '2011-11-02 20:04:37', 'abcdef', 'ce86d7d02a229acfaca4b63f01a1171b')"
    
    hash = {
      'PersID' => "abcdef",
      'PersName' => "Matt Harrison",
      'NewLogin' => "hi@matt-harrison.com",
      'AreaCode' => "UEY,UED,UEN%,UET",
      'SkillCode' => "RES",
      'JobTitleCode' => "EXE",
      'TempOrPerm' => "1,1",
      'InCode' => "IH",
      'HashValue' => 'abcdefg'
    }

    @database.update_person! hash

    rows = @database.client.query "SELECT * FROM #{@config['streamer_table']} WHERE abc_persid = 'abcdef'"

    assert_equal rows.to_a[0]['name'],      "Matt Harrison"
    assert_equal rows.to_a[0]['email'],     "hi@matt-harrison.com"
    assert_equal rows.to_a[0]['location'],  "20,23"
    assert_equal rows.to_a[0]['area'],      "96"
    assert_equal rows.to_a[0]['title'],     "7,8,9"
    assert_equal rows.to_a[0]['type'],      "1,2"
    assert_equal rows.to_a[0]['sector'],    "1"
    assert_equal rows.to_a[0]['abc_lasthash'], 'abcdefg'
  end

  def test_create_person!
    hash = {
      'PersID' => "abcdef",
      'PersName' => "Matt Harrison",
      'NewLogin' => "hi@matt-harrison.com",
      'AreaCode' => "UEY,UED,UEN%,UET",
      'SkillCode' => "RES",
      'JobTitleCode' => "EXE",
      'TempOrPerm' => "0,1",
      'InCode' => "_",
      'HashValue' => 'abcdefg'
    }

    @database.create_person! hash

    rows = @database.client.query "SELECT * FROM #{@config['streamer_table']} WHERE abc_persid = 'abcdef'"

    assert_equal rows.to_a[0]['name'],      "Matt Harrison"
    assert_equal rows.to_a[0]['email'],     "hi@matt-harrison.com"
    assert_equal rows.to_a[0]['location'],  "20,23"
    assert_equal rows.to_a[0]['area'],      "96"
    assert_equal rows.to_a[0]['title'],     "7,8,9"
    assert_equal rows.to_a[0]['type'],      "1"
    assert_equal rows.to_a[0]['sector'],    "1,2"
    assert_equal rows.to_a[0]['abc_lasthash'], "abcdefg"
  end

  def test_get_node_lookup_hash

    @database.client.query "INSERT INTO #{@config['streamer_table']} VALUES (1, 'Stephen Rafferty', '057192sr@live.com', '29', '0,79,88', '0,8', '0,1', '2,0', '2011-11-02 20:04:37', '2011-11-02 20:04:37', 'abcdef', 'ce86d7d02a229acfaca4b63f01a1171b')"

    hash = @database.get_node_lookup_hash
    assert_equal hash.length, 1
    assert_equal hash['abcdef'], 'ce86d7d02a229acfaca4b63f01a1171b'
  end

  def test_can_add_file_hash
    @database.add_hash_for_file "testfile.xml", "abcdef"
    rows = @database.client.query "SELECT * FROM #{@config['abc_file_hashes_table']} where filename= 'testfile.xml'"
    assert_equal rows.to_a[0]['hash'], "abcdef"
  end

  def test_can_load_mappings
    assert_equal @database.service_mappings['LES'], ["39", "41"]
    assert_equal @database.geo_mappings['UY%'], ["31"]
    assert_equal @database.practice_mappings['FINA'], ["136", "158"]
  end

  def test_can_convert_abc_code_list
    acme_id_list = @database.convert_abc_code_list({'AreaCode' => "UTL,UHD,UHX"}, :geo)
    assert_equal acme_id_list, "69,71"

    acme_id_list = @database.convert_abc_code_list({'SkillCode' => "MENT,PROP"}, :practice)
    assert_equal "58,84,147,163", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'JobTitleCode' => "EXE"}, :service)
    assert_equal "7,8,9", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'JobTitleCode' => "SOL", 'Experience' => 0}, :service)
    assert_equal "1", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'JobTitleCode' => "SOL", 'Experience' => 1}, :service)
    assert_equal "2", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'JobTitleCode' => "SOL", 'Experience' => 2}, :service)
    assert_equal "3", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'JobTitleCode' => "SOL", 'Experience' => 4}, :service)
    assert_equal "4", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'JobTitleCode' => "SOL", 'Experience' => 8}, :service)
    assert_equal "5,6", acme_id_list

    acme_id_list = @database.convert_abc_code_list({'AreaCode' => "ULC"}, :geo)
    assert_equal "", acme_id_list

  end

  def test_can_convert_sector_string
    sector_string = "IH"
    assert_equal "1", (@database.convert_sector_string sector_string)

    sector_string = "PP"
    assert_equal "2", (@database.convert_sector_string sector_string)

    sector_string = "_"
    assert_equal "1,2", (@database.convert_sector_string sector_string)

    sector_string = "some nonsense"
    assert_equal "", (@database.convert_sector_string sector_string)
  end

  def test_can_convert_temp_perm_string
    temp_perm_string = "0,0"
    assert_equal "", (@database.convert_temp_perm_string temp_perm_string)

    temp_perm_string = "1,0"
    assert_equal "2", (@database.convert_temp_perm_string temp_perm_string)

    temp_perm_string = "0,1"
    assert_equal "1", (@database.convert_temp_perm_string temp_perm_string)

    temp_perm_string = "1,1"
    assert_equal "1,2", (@database.convert_temp_perm_string temp_perm_string)

    temp_perm_string = "some nonsense"
    assert_equal "", (@database.convert_temp_perm_string temp_perm_string)
  end

end

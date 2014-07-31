require_relative './bootstrap.rb'

require 'rubygems'
require 'fileutils'
gem "minitest"
require 'minitest/autorun'
require 'yaml'
require 'FileReader'

class  FileReaderTest < Minitest::Test

  def setup
    #Write a test file
    @temp_location = APP_ROOT + CONFIG['files']['temp_location']

    FileUtils.rm_rf @temp_location
    FileUtils.mkdir_p @temp_location

    File.open(@temp_location + "JSExport12.xml", "w") {|f| f.write("Some text in here") }
    File.open(@temp_location + "JSExportDel1.xml", "w") {|f| f.write("Some text in here") }
    @file_reader = ACMEJobStreamerImport::FileReader.new CONFIG
  end

  def teardown
    FileUtils.rm_rf @temp_location
  end

  def test_can_get_import_files
    import_files = @file_reader.get_import_files
    assert import_files[0].include? "JSExport12.xml"
  end

  def test_can_get_deletion_files
    import_files = @file_reader.get_deletion_files
    assert import_files[0].include? "JSExportDel1.xml"
  end

  def test_can_get_hash_for_file
    import_files = @file_reader.get_import_files
    hash = @file_reader.get_hash_for_file import_files[0]
    assert_equal hash, "53f09af5b07ee69a3aff606773de7cc6"
  end

end

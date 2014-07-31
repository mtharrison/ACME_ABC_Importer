require_relative './bootstrap.rb'

require 'rubygems'
gem "minitest"
require 'minitest/autorun'
require 'minitest/mock'

require 'ABCImporter'

class  ABCImporterTest < Minitest::Test

  include ACMEJobStreamerImport

  def setup
    @importer = ABCImporter.new CONFIG
    @database = @importer.database
    @database.client.query "DELETE FROM #{CONFIG['database']['abc_file_hashes_table']}"
    @database.client.query "DELETE FROM #{CONFIG['database']['streamer_table']}"
    @temp_location = APP_ROOT + CONFIG['files']['temp_location']
    FileUtils.rm_rf @temp_location
    FileUtils.mkdir_p @temp_location
  end

  def teardown
    @database.client.query "DELETE FROM #{CONFIG['database']['abc_file_hashes_table']}"
    @database.client.query "DELETE FROM #{CONFIG['database']['streamer_table']}"
    FileUtils.rm_rf @temp_location
  end

  def add_update_file
    File.open(@temp_location + "JSExport1.xml", "w") {|f| f.write("<ExportValues>
  <Person>
    <PersID><![CDATA[TI0VSNMA11042012001D]]></PersID>
    <PersName><![CDATA[Laura Hinkinson]]></PersName>
    <NewLogin><![CDATA[lhinkinson@aol.com]]></NewLogin>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[UPA,UPB,UPD,UPE,UPF,UPG,UNE,UNC,UNB]]></AreaCode>
    <SkillCode><![CDATA[FR,INSU]]></SkillCode>
    <JobTitleCode><![CDATA[SOL]]></JobTitleCode>
    <Experience>10</Experience>
    <TempOrPerm><![CDATA[0,1]]></TempOrPerm>
    <InCode><![CDATA[IH]]></InCode>
  </Person>
  <Person>
    <PersID><![CDATA[TI0VSOGH110720050018]]></PersID>
    <PersName><![CDATA[Clare Marshland]]></PersName>
    <NewLogin><![CDATA[clare.marshland@googlemail.com]]></NewLogin>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[UYW,UWR%,UWM%,UWU%,UWL%,UWC%,UF%,UET,UEN%,UED,UEY,UYL,UYN,UYE,UDA,UDB]]></AreaCode>
    <SkillCode><![CDATA[PROC,COML,EC]]></SkillCode>
    <JobTitleCode><![CDATA[SOL]]></JobTitleCode>
    <Experience>32</Experience>
    <TempOrPerm><![CDATA[0,1]]></TempOrPerm>
    <InCode><![CDATA[IH]]></InCode>
  </Person>
</ExportValues>") }
  end


  def add_import_file
    File.open(@temp_location + "JSExport1.xml", "w") {|f| f.write("<ExportValues>
  <Person>
    <PersID><![CDATA[TI0VSNMA11042012001D]]></PersID>
    <PersName><![CDATA[Laura Hinkinson]]></PersName>
    <NewLogin><![CDATA[lhinkinson@gmail.com]]></NewLogin>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[UPA,UPB,UPD,UPE,UPF,UPG,UNE,UNC,UNB]]></AreaCode>
    <SkillCode><![CDATA[FR,INSU]]></SkillCode>
    <JobTitleCode><![CDATA[SOL]]></JobTitleCode>
    <Experience>10</Experience>
    <TempOrPerm><![CDATA[0,1]]></TempOrPerm>
    <InCode><![CDATA[IH]]></InCode>
  </Person>
  <Person>
    <PersID><![CDATA[TI0VSOGH110720050018]]></PersID>
    <PersName><![CDATA[Clare Marshland]]></PersName>
    <NewLogin><![CDATA[clare.marshland@googlemail.com]]></NewLogin>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[UYW,UWR%,UWM%,UWU%,UWL%,UWC%,UF%,UET,UEN%,UED,UEY,UYL,UYN,UYE,UDA,UDB]]></AreaCode>
    <SkillCode><![CDATA[PROC,COML,EC]]></SkillCode>
    <JobTitleCode><![CDATA[SOL]]></JobTitleCode>
    <Experience>32</Experience>
    <TempOrPerm><![CDATA[0,1]]></TempOrPerm>
    <InCode><![CDATA[IH]]></InCode>
  </Person>
</ExportValues>") }
  end

  def add_deletion_file
    File.open(@temp_location + "JSExportDel1.xml", "w") {|f| f.write("<ExportValues>
  <Person>
    <PersID><![CDATA[TI0VSNMA11042012001D]]></PersID>
  </Person>
  <Person>
    <PersID><![CDATA[TI0VSOGH110720050018]]></PersID>
  </Person>
  <Person>
    <PersID><![CDATA[abcdef]]></PersID>
  </Person>
</ExportValues>") }
  end

  def add_corrupt_file
  File.open(@temp_location + "JSExportDel1.xml", "w") {|f| f.write("<ExportValues>
<Person>
  <PersID><![CDATA[TI0VSNMA11042012001D]]></PersID>
</Person>
<Person>
  <PersID><![CDATA[TI0VSOGH110720050018]]></PersID>
</Person>
<Person>
  <PersID><![CDATA[abcdef]]></P
</Person>
</ExportValues>") }
  end

  def test_can_get_queries_and_performs_lookup_on_instantition
    assert_equal @importer.get_queries, 1
  end

  def test_can_refresh_lookup
    @importer.refresh_lookup
    assert_equal @importer.get_queries, 2
  end

  def test_can_process_file_with_additions
    assert_equal 0, (@database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}").count
    add_import_file
    @importer.process_file @temp_location + "JSExport1.xml", :addition
    assert_equal 2, (@database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}").count
  end

  def test_can_process_file_with_deletions

    assert_equal 0, (@database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}").count
    add_import_file
    @importer.process_file @temp_location + "JSExport1.xml", :addition
    assert_equal 2, (@database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}").count

    @importer.refresh_lookup

    add_deletion_file
    @importer.process_file @temp_location + "JSExportDel1.xml", :deletion
    assert_equal 0, (@database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}").count

  end

  def test_can_process_file_with_updates
    add_import_file

    @importer.process_file @temp_location + "JSExport1.xml", :addition
    @rows = @database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}"
    assert_equal 2, @rows.count
    assert_equal "lhinkinson@gmail.com", @rows.to_a[1]['email']

    @importer.refresh_lookup

    add_update_file
    @importer.process_file @temp_location + "JSExport1.xml", :addition
    @rows = @database.client.query "SELECT * FROM #{CONFIG['database']['streamer_table']}"
    assert_equal 2, @rows.count
    assert_equal "lhinkinson@aol.com", @rows.to_a[1]['email']
  end

  def test_can_handle_corrupt_files
    add_corrupt_file
    @importer.process_file @temp_location + "JSExportDel1.xml", :addition
  end

  def test_can_skip_files
    add_import_file
    @importer.process_file @temp_location + "JSExport1.xml", :addition
    add_import_file
    @importer.process_file @temp_location + "JSExport1.xml", :addition
  end

  def test_can_validate_node
    node = {'NewLogin' => 'mt.harrison86@gmail.com'}
    assert (@importer.node_is_valid? node)

    node = {'NewLogin' => 'Bad email address'}
    assert !(@importer.node_is_valid? node)

    node = {'NewLogin' => ''}
    assert !(@importer.node_is_valid? node)
  end

end

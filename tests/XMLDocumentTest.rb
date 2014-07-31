require_relative './bootstrap.rb'

require 'rubygems'
gem "minitest"
require 'minitest/autorun'
require 'XMLDocument'

class  XMLDocumentTest < Minitest::Test

  include ACMEJobStreamerImport

  def setup
  end

  def teardown
  end

  def test_can_validate
    xml_string = "<ExportValues>
    <Person>
    <PersID><![CDATA[XX373015310320090027]]></PersID>
    <PersName><![CDATA[Annemarie Smith]]></PersName>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[]]></AreaCode>
    <SkillCode><![CDATA[]]></SkillCode>
    <JobTitleCode><![CDATA[]]></JobTitleCode>
    <TempOrPerm><![CDATA[1,1]]></TempOrPerm>
    <InCode><![CDATA[_]]></InCode>
    <HashValue><![CDATA[35208a2f282d87c091e4f7f69b6a2b5f]]></HashValue>
    <ChangeDate>0</ChangeDate>
    </Person>
    </ExportValues>
    "

    xml = XMLDocument.new xml_string

    assert xml.validates?

    xml_string = "<ExportValues>
    <Person>
    <PersID><![CDATA[XX373015310320090027]]></PersID>
    <PersName><![CDATA[Annemarie Smith]]></PersName>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[]]></AreaCode>
    <SkillCode><![CDATA[]]></SkillCode>
    <JobTitleCode><![CDATA[]]></JobTitleCode>
    <TempOrPerm><![CDATA[1,1]]></TempOrPerm>
    <InCode><![CDATA[_]]></InCode>
    <HashValue><![CDATA[35208a2f282d87c091e4f7f69b6a2b5f]]></HashValue>
    <ChangeDate>0</ChangeDate>
    </Person>
    </ExportValues
    "

    xml = XMLDocument.new xml_string

    assert !xml.validates?

  end

  def test_has_node

    xml_string = "<ExportValues>
    <Person>
    <PersID><![CDATA[XX373015310320090027]]></PersID>
    <PersName><![CDATA[Annemarie Smith]]></PersName>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[]]></AreaCode>
    <SkillCode><![CDATA[]]></SkillCode>
    <JobTitleCode><![CDATA[]]></JobTitleCode>
    <TempOrPerm><![CDATA[1,1]]></TempOrPerm>
    <InCode><![CDATA[_]]></InCode>
    <HashValue><![CDATA[35208a2f282d87c091e4f7f69b6a2b5f]]></HashValue>
    <ChangeDate>0</ChangeDate>
    </Person>
    <Person>
    <PersID><![CDATA[XX373015310320090027]]></PersID>
    <PersName><![CDATA[Annemarie Smith]]></PersName>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[]]></AreaCode>
    <SkillCode><![CDATA[]]></SkillCode>
    <JobTitleCode><![CDATA[]]></JobTitleCode>
    <TempOrPerm><![CDATA[1,1]]></TempOrPerm>
    <InCode><![CDATA[_]]></InCode>
    <HashValue><![CDATA[35208a2f282d87c091e4f7f69b6a2b5f]]></HashValue>
    <ChangeDate>0</ChangeDate>
    </Person>
    <Person>
    <PersID><![CDATA[XX373015310320090027]]></PersID>
    <PersName><![CDATA[Annemarie Smith]]></PersName>
    <NewPassword>cGFzc3dvcmQ=</NewPassword>
    <AreaCode><![CDATA[]]></AreaCode>
    <SkillCode><![CDATA[]]></SkillCode>
    <JobTitleCode><![CDATA[]]></JobTitleCode>
    <TempOrPerm><![CDATA[1,1]]></TempOrPerm>
    <InCode><![CDATA[_]]></InCode>
    <HashValue><![CDATA[35208a2f282d87c091e4f7f69b6a2b5f]]></HashValue>
    <ChangeDate>0</ChangeDate>
    </Person>
    </ExportValues>
    "

    xml = XMLDocument.new xml_string

    assert xml.has_node?

    node = xml.pop_node!
    assert xml.has_node?

    node = xml.pop_node!
    assert xml.has_node?

    node = xml.pop_node!
    assert !xml.has_node?

  end


end
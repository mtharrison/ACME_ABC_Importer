require 'rubygems'
require 'xmlsimple'
require 'pp'

module ACMEJobStreamerImport

  # Manages converting the XML file contents into a iterable data structure
  class XMLDocument

    attr_accessor :node_count

    # Instantiate with contents of file, tries to parse it catching any
    # exceptions and setting the @valid_xml instance var appropriately
    #
    # [contents]  The XML string
    def initialize contents

      contents.encode! "UTF-8", "ISO-8859-1"
      contents.force_encoding "UTF-8"

      begin
        @data = XmlSimple.xml_in contents
        @nodes = @data['Person']
        @valid_xml = true
        @node_count = @data.length
      rescue
        @valid_xml = false
      end
    end

    # A helper getter to return if the XML loaded in was valid
    def validates?
      @valid_xml
    end

    # Are there unprocessed nodes in this doc?
    def has_node?
      @nodes.length > 0
    end

    # Removes a node, and returns it
    def pop_node!
      node = @nodes.pop
      node.each { |key,value| node[key] = value[0].to_s.gsub(/'/){ "\\'" } }
    end

  end

end

require_relative './bootstrap.rb'

require 'rubygems'
gem "minitest"
require 'minitest/autorun'
require 'fileutils'
require 'Logger'

class  LoggerTest < Minitest::Test
  def setup
    @log_file = APP_ROOT + CONFIG['files']['log_file']
    # Give us a clean file to test
    FileUtils.rm_rf @log_file
    @logger = ACMEJobStreamerImport::Logger.new CONFIG
  end

  def test_can_write_something_to_log
    @logger.error "I couldn't save the file"
    log_contents = File.read @log_file
    assert log_contents.include? 'I couldn\'t save the file'
    assert log_contents.include? 'ERROR'

  end

  def test_can_write_fatal_to_log
    @logger.fatal "I couldn't save the file"
    log_contents = File.read @log_file
    assert log_contents.include? 'I couldn\'t save the file'
    assert log_contents.include? 'FATAL'

  end

  def test_can_use_shortcut
    @logger.info "Successful logging!"
    log_contents = File.read @log_file
    assert log_contents.include? 'Successful logging!'
    assert log_contents.include? 'INFO'
  end

end

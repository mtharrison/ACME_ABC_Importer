require 'yaml'
require 'simplecov'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start do
    add_filter 'test'
    command_name 'Minitest'
  end
end

APP_ROOT = File.expand_path File.dirname(__FILE__) + '/..'
$:.unshift APP_ROOT + '/lib'
CONFIG = YAML.load_file(APP_ROOT + '/config.yml')['test']
SMS = false

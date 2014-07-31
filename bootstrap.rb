require 'yaml'

# The absolute path to the app's root directory
APP_ROOT = File.expand_path File.dirname(__FILE__)
$:.unshift APP_ROOT + '/lib'
# A global constant containing the configuration parsed from config.yml
CONFIG = YAML.load_file(APP_ROOT + '/config.yml')['production']
SMS = true
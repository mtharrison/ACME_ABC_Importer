# inside tasks/test.rake
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.libs.push 'test'
  t.pattern = 'tests/*Test.rb'
  t.warning = false
  t.verbose = false
end

task :default => :test

desc 'Generates a coverage report'
task :coverage do
  ENV['COVERAGE'] = 'true'
  Rake::Task['test'].execute
end

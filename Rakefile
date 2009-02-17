require "rake/testtask"
require "rubygems"
require "rake"


OBJC_SOURCE = Dir.glob("Classes/*.[h|m]")
TARGET = "lib/osx_watchfolder.bundle"

file TARGET => OBJC_SOURCE do
  p `gcc -o #{TARGET} -bundle -framework Foundation -framework CoreServices #{Dir.glob('Classes/*.m') * ' '}`
end


task :clean do
  FileUtils.rm_rf TARGET
end


task :compile => TARGET
task :clean_build => [:clean, TARGET]




task :default => :test

task :test => :compile

Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end



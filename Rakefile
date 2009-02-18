# Look in the tasks/setup.rb file for the various options that can be
# configured in this Rakefile. The .rake files in the tasks directory
# are where the options are used.

begin
  require 'bones'
  Bones.setup
rescue LoadError
  begin
    load 'tasks/setup.rb'
  rescue LoadError
    raise RuntimeError, '### please install the "bones" gem ###'
  end
end

ensure_in_path 'lib'
require 'osx_watchfolder'

task :default => 'spec:run'

PROJ.name = 'osx_watchfolder'
PROJ.authors = 'Paul Wilson'
PROJ.email = 'paul.wilson@merecomplexities.com'
PROJ.url = 'http://github.com/paulanthonywilson/osx_watchfolder'
PROJ.version = OsxWatchfolder::VERSION

# EOF

# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{osx_watchfolder}
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Wilson"]
  s.date = %q{2009-02-18}
  s.description = %q{osx_watchfolder is a tiny gem to take advantages of OSX 10.5's folder watching functionality.}
  s.email = %q{paul.wilson@merecomplexities.com}
  s.extra_rdoc_files = ["History.txt", "README.rdoc"]
  s.files = [".DS_Store", "History.txt", "README.rdoc", "Rakefile", "lib/osx_watchfolder.rb", "lib/osx_watchfolder/folder_watcher.rb", "osx_watchfolder.gemspec", "test/test_folder_watch.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/paulanthonywilson/osx_watchfolder}
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{ }
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{osx_watchfolder is a tiny gem to take advantages of OSX 10}
  s.test_files = ["test/test_folder_watch.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bones>, [">= 2.4.0"])
    else
      s.add_dependency(%q<bones>, [">= 2.4.0"])
    end
  else
    s.add_dependency(%q<bones>, [">= 2.4.0"])
  end
end

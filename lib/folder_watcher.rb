require 'osx/cocoa'
require File.expand_path(File.dirname(__FILE__) + "/osx_watchfolder.bundle")

OSX::ns_import :FolderWatcher


module FolderWatcher
  def self.watch_folders(*folders)
  end
end
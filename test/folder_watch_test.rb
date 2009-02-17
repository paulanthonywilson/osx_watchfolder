require 'test/unit'
require 'tmpdir'
require 'fileutils'
require File.dirname(__FILE__) + '/../lib/folder_watcher'


class FolderWatchTest <  Test::Unit::TestCase
include FileUtils
  def setup
    @watched_dirs = [Dir.tmpdir + "/folder_watch_test1", Dir.tmpdir + "/folder_watch_test2"]
    @watched_dirs.each {|dir| rm_rf dir}
    @watched_dirs.each {|dir| mkdir dir}
    FolderWatcher::watch_folders(@watched_dirs) {@folder_changed = true}
    @folder_changed = false
  end
  
  def teardown
    @watched_dirs.each {|dir| rm_rf dir}
  end
  
  def test_nothing_happens_if_a_watched_folder_does_not_change
    assert !@folder_changed
  end
  
  def test_notified_if_first_watched_folder_changes
    File.open(@watched_dirs.first + "/somefile", "w"){|f| f.write "hello"}
    sleep 1
    assert @folder_changed
  end

  def test_notified_if_other_watched_folder_changes
    File.open(@watched_dirs.last + "/somefile", "w"){|f| f.write "hello"}
    sleep 1
    assert @folder_changed
  end
  
  
end
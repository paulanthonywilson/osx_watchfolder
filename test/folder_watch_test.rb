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
    @folder_changed = false
  end
  
  def teardown
    @testee.stop
    @watched_dirs.each {|dir| rm_rf dir}
  end
  
  def xtest_nothing_happens_if_a_watched_folder_does_not_change
    assert !@folder_changed
  end
  
  def test_notified_if_first_watched_folder_changes
    in_a_second_write_file_and_stop_watcher @watched_dirs.first + "/somefile"
    watch_folders
    assert @folder_changed    
  end
  

  def test_notified_if_other_watched_folder_changes
    in_a_second_write_file_and_stop_watcher @watched_dirs.last + "/somefile"
    watch_folders
    assert @folder_changed    
  end
 
  def in_a_second_write_file_and_stop_watcher(file)
    Thread.new do
      sleep 1
      p "yawn"
      File.open(file, "w"){|f| f.write "hello"}
      @testee.stop
    end
  end
  
  def watch_folders
    @testee = FolderWatcher.new(*@watched_dirs) {@folder_changed = true}
    @testee.latency = 0.1
    @testee.runloop_interval = 0.5
    @testee.start
  end
    
  
end
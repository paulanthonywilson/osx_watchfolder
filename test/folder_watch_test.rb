require 'test/unit'
require 'tmpdir'
require 'fileutils'
require File.dirname(__FILE__) + '/../lib/folder_watcher'


class FolderWatchTest <  Test::Unit::TestCase
include FileUtils
  def setup
    @some_folders = [Dir.tmpdir + "/folder_watch_test1", Dir.tmpdir + "/folder_watch_test2"]
    @some_folders.each {|dir| rm_rf dir}
    @some_folders.each {|dir| mkdir dir}
    @folder_changed = false
  end
  
  def teardown
    @some_folders.each {|dir| rm_rf dir}
  end
  
  def test_nothing_happens_if_a_watched_folder_does_not_change
    in_a_second_yield_and_stop_watcher
    watch_folders
    assert !@folder_changed
  end

  def test_can_be_initialised_with_var_args_or_array
    assert_equal @some_folders,  FolderWatcher.new(*@some_folders).instance_variable_get(:@folders)
    assert_equal @some_folders,  FolderWatcher.new(@some_folders).instance_variable_get(:@folders)
  end

  
  def test_notified_if_first_watched_folder_changes
    in_a_second_write_file_and_stop_watcher @some_folders.first + "/somefile"
    watch_folders
    assert @folder_changed    
  end
  

  def test_notified_if_other_watched_folder_changes
    in_a_second_write_file_and_stop_watcher @some_folders.last + "/somefile"
    watch_folders
    assert @folder_changed    
  end
 
 
  def in_a_second_yield_and_stop_watcher
    Thread.new do
      sleep 1
      p "yawn"
      yield if block_given?
      @testee.stop
    end
  end
 
  def in_a_second_write_file_and_stop_watcher(file)
    in_a_second_yield_and_stop_watcher do
      File.open(file, "w"){|f| f.write "hello"}
    end
  end
  
  def watch_folders
    @testee = FolderWatcher.new(*@some_folders) {@folder_changed = true}
    @testee.latency = 0.1
    @testee.runloop_interval = 0.5
    @testee.start
  end
    
  
end
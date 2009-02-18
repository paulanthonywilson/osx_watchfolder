require 'test/unit'
require 'tmpdir'
require 'fileutils'
require File.expand_path(File.dirname(__FILE__) + '/../lib/osx_watchfolder')

class TestFolderWatch <  Test::Unit::TestCase
  include FileUtils
  include OsxWatchfolder

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


  def test_notified_if_another_watched_folder_changes
    in_a_second_write_file_and_stop_watcher @some_folders.last + "/somefile"
    watch_folders
    assert @folder_changed    
  end

  def test_must_be_started_in_main_thread
    @testee = FolderWatcher.new(*@some_folders) {}
    t = Thread.new do
      assert_raise(RuntimeError){ @testee.start}
    end
    t.join
  end

  def test_handles_interrupts
    @testee = FolderWatcher.new(*@some_folders) {}
    assert_equal 0, @testee.interrupted_count 
    class << @testee
      def enter_run_loop
        raise Interrupt, "stopped!"
      end
    end
    @testee.start
    assert_equal 1, @testee.interrupted_count 
  end
  

  def in_a_second_yield_and_stop_watcher
    Thread.new do
      yield if block_given?
      sleep 1
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
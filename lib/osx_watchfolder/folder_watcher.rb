require 'osx/foundation'  
OSX.require_framework '/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework'

module OsxWatchfolder

  # To run the method 'run_tests' when a change is detected in a couple of folders:
  #
  #  folder_watcher = OsxWatchfolder::FolderWatcher.new("lib", "test") { run_tests}
  #  folder_wacher.start
  #
  class FolderWatcher
    
    # directory update notification latency in seconds.  Defaults to 1 
    attr_accessor :latency
    
    # runloop timeout in seconds - on all but the 1st interrupt for the script it will take a maximum of 
    # this long for interrupts to be noticed. Defaults to 5
    attr_accessor :runloop_interval
    
    # how many times has this been interrupted?
    attr_reader :interrupted_count


    def stop
      @running = false
      OSX::CFRunLoopStop(@runloop)
    end

    def start
      raise "May only be started from main thread" unless Thread.current == Thread.main
      prepare_stream
      enter_run_loop
    rescue Interrupt
      stop
      @interrupted_count += 1
    ensure
      cleanup_stream 
    end  


    def initialize(*folders, &block)
      @folders = Array === folders.first ? folders.first : folders
      @block = block
      @running = true
      @latency = 1
      @runloop_interval = 5
      @interrupted_count = 0
    end

    private


    def enter_run_loop
      @running = true
      OSX::CFRunLoopRunInMode(OSX::KCFRunLoopDefaultMode, @runloop_interval, true) while @running
    end

    def cleanup_stream 
      if (@stream)
        OSX::FSEventStreamStop(@stream)
        OSX::FSEventStreamInvalidate(@stream)
        OSX::FSEventStreamRelease(@stream)
      end
      @stream = nil
    end

    def prepare_stream
      callback = lambda do |streamRef, clientCallBackInfo, numEvents,eventPaths, eventFlags,eventIds| 
        @block.call
      end
      @stream = OSX::FSEventStreamCreate(nil,callback,nil,@folders,OSX::KFSEventStreamEventIdSinceNow, @latency,OSX::KFSEventStreamCreateFlagNone)

      @runloop = OSX::CFRunLoopGetCurrent()

      OSX::FSEventStreamScheduleWithRunLoop(@stream, @runloop, OSX::KCFRunLoopDefaultMode)   
      OSX::FSEventStreamStart(@stream)
    end



  end
end
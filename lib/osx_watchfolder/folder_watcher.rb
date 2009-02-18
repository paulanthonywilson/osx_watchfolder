require 'osx/foundation'  
OSX.require_framework '/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework'

module OsxWatchfolder

  class FolderWatcher

    attr_accessor :latency, :runloop_interval


    def stop
      OSX::CFRunLoopStop(@runloop)
    end

    def start
      raise "May only be started from main thread" unless Thread.current == Thread.main
      callback = lambda do |streamRef, clientCallBackInfo, numEvents,eventPaths, eventFlags,eventIds| 
        @block.call
      end
      stream = OSX::FSEventStreamCreate(nil,
      callback,
      nil,
      @folders,
      OSX::KFSEventStreamEventIdSinceNow, 
      @latency,
      OSX::KFSEventStreamCreateFlagNone)

      @runloop = OSX::CFRunLoopGetCurrent()

      OSX::FSEventStreamScheduleWithRunLoop(stream, @runloop, OSX::KCFRunLoopDefaultMode)   
      OSX::FSEventStreamStart(stream)
      OSX::CFRunLoopRun()
    end  


    def initialize(*folders, &block)
      @folders = Array === folders.first ? folders.first : folders
      @block = block
      @running = true
      @latency = 1
    end

  end
end
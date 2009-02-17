require 'osx/foundation'  
OSX.require_framework '/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework'

class FolderWatcher
  
  attr_accessor :latency, :runloop_interval


  def stop
    p "stop"
    OSX::CFRunLoopStop(@runloop)
  end
  def start
    p "start"
    callback = lambda do |streamRef, clientCallBackInfo, numEvents,eventPaths, eventFlags,eventIds| 
      puts "ooh"
      @block.call
    end
    p @folder
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
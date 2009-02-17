require 'osx/foundation'  
OSX.require_framework '/System/Library/Frameworks/CoreServices.framework/Frameworks/CarbonCore.framework'

class FolderWatcher
  
  attr_accessor :running, :latency, :runloop_interval


  def stop
    p "stop"
    @running = false
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

    OSX::FSEventStreamScheduleWithRunLoop(stream, OSX::CFRunLoopGetCurrent(), OSX::KCFRunLoopDefaultMode)   
    OSX::FSEventStreamStart(stream)
    while(running) do
      OSX::CFRunLoopRunInMode(OSX::KCFRunLoopDefaultMode, @runloop_interval, false);  
      p "hi"
    end
  end  


  def initialize(*folders, &block)
    @folders = Array === folders.first ? folders.first : folders
    @block = block
    @running = true
    @latency = 1
    @runloop_interval =  5 
  end

end
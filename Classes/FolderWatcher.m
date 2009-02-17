#import "FolderWatcher.h"


@interface FolderWatcher()

@property(nonatomic, retain) NSArray *watchedPaths;
@property(nonatomic, retain) id<FolderListeningProc> folderListeningProc;

@end



static void folderChangedCallback(
                ConstFSEventStreamRef streamRef,
                void *clientCallBackInfo,
                size_t numEvents,
                void *eventPaths,
                const FSEventStreamEventFlags eventFlags[],
                const FSEventStreamEventId eventIds[])
{
    NSLog(@"callbback");
    int i;
    char **paths = eventPaths;
    
    // printf("Callback called\n");
    for (i=0; i<numEvents; i++) {
        /* flags are unsigned long, IDs are uint64_t */
        NSLog(@"Change %llu in %s, flags %lu\n", eventIds[i], paths[i], eventFlags[i]);
    }
}



@implementation FolderWatcher
@synthesize watchedPaths;
@synthesize folderListeningProc;


-(void) startListening{
	FSEventStreamRef stream = FSEventStreamCreate(NULL,
      &folderChangedCallback,
      NULL,
      (CFArrayRef) self.watchedPaths,
      kFSEventStreamEventIdSinceNow, 
      0.1,
      kFSEventStreamCreateFlagNone 
  );
	FSEventStreamScheduleWithRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopDefaultMode);
	BOOL started = FSEventStreamStart(stream);
	NSLog(@"started: %d", started);
	CFRunLoopRun();
	
}


+(FolderWatcher*) folderWatcherWatching:(NSArray*)paths andTelling:(id<FolderListeningProc>) folderListeningProc{
	FolderWatcher *result = [[[FolderWatcher alloc] init] autorelease];
	result.watchedPaths = [NSArray arrayWithArray:paths]; 
	[result startListening];
	return result;
}


-(void) dealloc{
	self.watchedPaths = nil;
	self.folderListeningProc = nil;
	[super dealloc];
}

@end


void Init_osx_watchfolder(){}

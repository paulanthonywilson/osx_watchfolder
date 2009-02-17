#import <Cocoa/Cocoa.h>


@protocol FolderListeningProc
-(void) call;
@end

@interface FolderWatcher : NSObject {
@private
	NSArray *watchedPaths;
	id<FolderListeningProc> folderListeningProc;

}

+(FolderWatcher*) folderWatcherWatching:(NSArray*)paths andTelling:(id<FolderListeningProc>) folderListeningProc;


@end

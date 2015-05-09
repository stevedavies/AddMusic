//
//  MediaPlayerWorker.m
//  AddMusic
//
//  Created by Steve Davies MXTB on 5/6/15.
//
//

#import "MediaPlayerWorker.h"

@implementation MediaPlayerWorker
@synthesize musicPlayer;

- (void )SetToEnd: (MPMediaItemCollection *) PlayList{
    
        //[self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
        [self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];
        [musicPlayer setShuffleMode: MPMusicShuffleModeOff];
        [musicPlayer setRepeatMode: MPMusicRepeatModeNone];

    [musicPlayer setQueueWithItemCollection: PlayList];
    [musicPlayer play];
    
    // iterate through list and set playback to end-1
    int ct = [PlayList count];
    for (int i = 1; i <= ct; i++){
        MPMediaItem  *item =[musicPlayer nowPlayingItem];
        
        //NowPlayingInfoCenter
        //int foo = [nowPlayingInfo MPNowPlayingInfoPropertyPlaybackQueueIndex];
        //int foo2 =[musicPlayer MPNowPlayingInfoPropertyElapsedPlaybackTime];
        //int foo3 =[ MPNowPlayingInfoPropertyPlaybackQueueCount ];
        
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        double PlaybackDuration = [itemPlaybackDuration doubleValue];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        printf("%s", [[NSString stringWithFormat:@"\n  ENDING-> Type:%d Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",TypeValue, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
        
        NSString *timevalue = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        double EndValue = [timevalue doubleValue];
        [musicPlayer setCurrentPlaybackTime:(EndValue)-2];
        sleep(1); // look into nanosleep()
        [musicPlayer skipToNextItem];
        [musicPlayer play];
    }
    [musicPlayer stop];
}

@end

//
//  MediaPlayerWorker.m
//  AddMusic
//
//  Created by Steve Davies MXTB on 5/6/15.
//
//

#import "MediaPlayerWorker.h"

@implementation MediaPlayerWorker
//@synthesize musicPlayer;

- (void )ReZero: (MPMediaItemCollection *) PlayList
         Player:(MPMusicPlayerController *) musicPlayer{
    
    //[self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
    //[self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];                         <<<<<< using passed in player
    //[self setMusicPlayer: [MPMusicPlayerController systemMusicPlayer]]; // LOOK was using system
    [musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [musicPlayer setRepeatMode: MPMusicRepeatModeNone];
    
    [musicPlayer setQueueWithItemCollection: PlayList];
    [musicPlayer play];
    sleep(1);
    [musicPlayer stop];
    
    // iterate through list and set playback to 0
    NSUInteger ct = [PlayList count];
    for (int i = 0; i < ct; i++){
        MPMediaItem  *item =[musicPlayer nowPlayingItem];  // <<<<<<<<<< BUG - the first item here is always null
        
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        double PlaybackDuration = [itemPlaybackDuration doubleValue];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        printf("%s", [[NSString stringWithFormat:@"\n  ReZero-ing-> Type:%d Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",TypeValue, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);

        [musicPlayer setCurrentPlaybackTime:0.0];
        sleep(1);
        [musicPlayer skipToNextItem];

    }
    [musicPlayer setRepeatMode: MPMusicShuffleModeSongs];
}

- (void )SetToEnd: (MPMediaItemCollection *) PlayList
           Player:(MPMusicPlayerController *) musicPlayer{
    
    //[self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
    //[self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];                         <<<<<< using passed in player
    //[self setMusicPlayer: [MPMusicPlayerController systemMusicPlayer]]; // LOOK was using system
    [musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [musicPlayer setRepeatMode: MPMusicRepeatModeNone];
    
    [musicPlayer setQueueWithItemCollection: PlayList];
    [musicPlayer play];
    sleep(1);
    [musicPlayer stop];
    
    // iterate through list and set playback to end-1
    NSUInteger ct = [PlayList count];
    for (int i = 0; i < ct; i++){
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
        int Plays = (int)[itemPlayCount integerValue];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        printf("%s", [[NSString stringWithFormat:@"\n  ENDING-> Type:%d Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",TypeValue, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
        if( Plays ==0){
            NSString *timevalue = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
            double EndValue = [timevalue doubleValue];
            [musicPlayer setCurrentPlaybackTime:(EndValue)-2];
            [musicPlayer skipToNextItem];
            [musicPlayer play];
            sleep(1); // look into nanosleep()
        }
    }
    [musicPlayer stop];
}

@end

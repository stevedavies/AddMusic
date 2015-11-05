//
//  MediaPlayerWorker.h
//  AddMusic
//
//  Created by Steve Davies MXTB on 5/6/15.
//
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaPlayerWorker : NSObject
//@property (nonatomic, retain)	MPMusicPlayerController	*musicPlayer;
-(void)SetToEnd: (MPMediaItemCollection *) PlayList Player:(MPMusicPlayerController *) musicPlayer;
-(void)ReZero: (MPMediaItemCollection *) PlayList Player:(MPMusicPlayerController *) musicPlayer;
@end

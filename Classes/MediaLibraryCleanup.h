//
//  MediaLibraryCleanup.h
//  AddMusic
//
//  Created by Steve Davies on 3/20/15.
//
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaLibraryCleanup : NSObject
+ (MPMediaItemCollection*)ClearPartiallyPlayed;
+ (int) Count;
@end

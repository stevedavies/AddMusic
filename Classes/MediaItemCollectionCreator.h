//
//  MediaItemCollectionCreator.h
//  AddMusic
//
//  Created by Steve Davies MXTB on 2/27/15.
//
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface MediaItemCollectionCreator : NSObject
+(MPMediaItemCollection *) MakePlaylist:(NSString*) Album;
@end

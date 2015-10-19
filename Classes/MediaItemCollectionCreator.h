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

+ (void) AddPodcastsToPlaylist:(NSString*) Album
                      Playlist:(NSMutableArray*) Playlist
                       OrderBy: (BOOL) Order
                   NumberToAdd: (NSInteger) NumberToAdd;


+ (void) AddMusicPlaylist:(NSString*) MusicPlaylistName
                 Playlist:(NSMutableArray*) Playlist;
@end

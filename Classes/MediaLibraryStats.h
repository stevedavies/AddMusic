//
//  MediaLibraryStats.h
//  AddMusic
//
//  Created by Steve Davies on 2/26/15.
//
//

#import <Foundation/Foundation.h>


@interface MediaLibraryStats : NSObject

@property (nonatomic, readonly ) int PlaylistsCount;
@property (nonatomic, readonly ) int ItemsCount;
@property (nonatomic, readwrite) int SongsCount;
@property (nonatomic, readwrite) int PodcastsCount;
@property (nonatomic, readwrite) int PartiallyPlayedPodcastsCount;
-(void) CalculateStats;
@end



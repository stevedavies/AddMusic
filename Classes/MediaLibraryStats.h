//
//  MediaLibraryStats.h
//  AddMusic
//
//  Created by Steve Davies on 2/26/15.
//
//

#import <Foundation/Foundation.h>


@interface MediaLibraryStats : NSObject

@property (nonatomic, readonly ) int items;
@property (nonatomic, readwrite) int songs;
@property (nonatomic, readwrite) int podcasts;
@property (nonatomic, readwrite) int partiallyPlayedPodcasts;
-(void) CalculateStats;
@end



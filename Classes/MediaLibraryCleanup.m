//
//  MediaLibraryCleanup.m
//  AddMusic
//
//  Created by Steve Davies on 3/20/15.
//
//

#import "MediaLibraryCleanup.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MediaLibraryCleanup
+ (MPMediaItemCollection*)ClearPartiallyPlayed{
    NSMutableArray *PlaylistItems= [[NSMutableArray alloc] init];
    ////////////////////////////////
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaQuery:"] UTF8String]);
    MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
    
    // see MediaLibraryStats.h for a list of media item properties
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast]
                                          forProperty: MPMediaItemPropertyMediaType
                                          comparisonType: MPMediaPredicateComparisonEqualTo]];
    
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: @"Bloomberg"
                                          forProperty: MPMediaItemPropertyAlbumTitle
                                          comparisonType: MPMediaPredicateComparisonContains]];
    
    //Alternate method - create predicates, add to set....
    //NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"title == %d", 2];  // filter for podcasts, type is 2
    
    // Sets the grouping type for the media query
    [myPodcastsQuery setGroupingType: MPMediaGroupingAlbum];
    
    NSArray *albums = [myPodcastsQuery collections];
    //NSArray *allItems = [myPodcastsQuery items]; // all items are also in this property
    for (MPMediaItemCollection *album in albums) {
        MPMediaItem *representativeItem = [album representativeItem];
        //representativeItem.album
        NSString *albumTitle =
        [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        
        
        NSArray *songs = [album items];
        printf("%s", [[NSString stringWithFormat:@"\nPodcast: %@ - ItemCount: %d", albumTitle, [songs count]] UTF8String]);
        
        // print each episode
        
        for (MPMediaItem *song in songs) {
            NSString *songTitle =[song valueForProperty: MPMediaItemPropertyTitle];
            NSString *itemAlbumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            double PlaybackDuration = [[song valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
            NSString *itemPlayCount = [song valueForProperty:MPMediaItemPropertyPlayCount];
            NSString *itemType = [song valueForProperty:MPMediaItemPropertyMediaType];
            double BookmarkValue = [[song valueForProperty:MPMediaItemPropertyBookmarkTime]doubleValue];
            if  (BookmarkValue>0){
                printf("%s", [[NSString stringWithFormat:@"\nType:%@ Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",itemType, itemAlbumTitle, songTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                //set song to played
                [PlaylistItems addObject:song];
                // create a new class for this
            }
        }
        
    }
    printf("%s", [[NSString stringWithFormat:@"\nPodcast Titles Count: %d", [albums count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nTotal Podcast Episodes Count: %d", [myPodcastsQuery.items count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nStats query COMPLETE\n"] UTF8String]);
    MPMediaItemCollection *PartiallyPlayedList=[[MPMediaItemCollection alloc] initWithItems:PlaylistItems];
    return PartiallyPlayedList;
    ////////////////////////////////
}

@end

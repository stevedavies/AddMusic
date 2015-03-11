//
//  MediaItemCollectionCreator.m
//  AddMusic
//
//  Created by Steve Davies MXTB on 2/27/15.
//
//

#import "MediaItemCollectionCreator.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MediaItemCollectionCreator
+ (MPMediaItemCollection*) MakePlaylist{
    int itemsCount=0;
    int partiallyPlayedCount=0;
    NSMutableArray *PlaylistItems= [[NSMutableArray alloc] init];
    
    //MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaQuery:"] UTF8String]);
    MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
    
    // see MediaLibraryStats.h for a list of media item properties
    MPMediaPropertyPredicate *typePredicate = [MPMediaPropertyPredicate
                                               predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast]
                                               forProperty: MPMediaItemPropertyMediaType
                                               comparisonType: MPMediaPredicateComparisonEqualTo];
    MPMediaPropertyPredicate *titlePredicate = [MPMediaPropertyPredicate
                                                  predicateWithValue: @"EconTalk"
                                                  forProperty: MPMediaItemPropertyAlbumTitle
                                                  comparisonType: MPMediaPredicateComparisonContains];
    [myPodcastsQuery addFilterPredicate: typePredicate];
    [myPodcastsQuery addFilterPredicate: titlePredicate];
    [myPodcastsQuery setGroupingType: MPMediaGroupingAlbum];
    //Alternate method - create predicates, add to set....
    //NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"title == %d", 2];  // filter for podcasts, type is 2
    
    
    
    NSArray *itemsFromGenericQuery = [myPodcastsQuery items];
    for (MPMediaItem *item in itemsFromGenericQuery) {
        
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        
        if(TypeValue == 2 & BookmarkValue > 0) {
            printf("%s", [[NSString stringWithFormat:@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount] UTF8String]);
            // ADD itme to MutableArray here
            [PlaylistItems addObject:item];
            partiallyPlayedCount++;
        };
        itemsCount++;
    }
    
    // do the same for some music items
    
    
    // create a playlist here   PartiallyPlayedList
    MPMediaItemCollection *PartiallyPlayedList=[[MPMediaItemCollection alloc] initWithItems:PlaylistItems];
    
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",itemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPartially Palyed podcasts: %d", partiallyPlayedCount] UTF8String]);
    return PartiallyPlayedList;
}

@end

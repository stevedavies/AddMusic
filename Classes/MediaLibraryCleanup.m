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

+ (MPMediaItemCollection*)ReZero{
    int ItemsCount=0;
    int PodcastsSkippedCount=0;
    int PodcastsCount =0;
    int ReZeroPodcastsCount=0;
    MPMediaItemCollection* ReZeroPlayList;
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSMutableArray *ReZeroPodcastItems= [[NSMutableArray alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    printf("%s", [[NSString stringWithFormat:@"\n\nLooking at entire library..."] UTF8String]);
    for (MPMediaItem *item in itemsFromGenericQuery) {
        ItemsCount++;
        
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        double PlaybackDuration = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemSkipCount = [item valueForProperty:MPMediaItemPropertySkipCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        double BookmarkValue = [[item valueForProperty:MPMediaItemPropertyBookmarkTime]doubleValue];
        
        if (TypeValue == 2) {
            PodcastsCount++;
            if ([itemSkipCount intValue] > 0){
                PodcastsSkippedCount++;
            }
            if  (BookmarkValue > 1.2 && BookmarkValue <= 15.0 && [itemPlayCount intValue] == 0){
                // set back to zero
                printf("%s", [[NSString stringWithFormat:@"\nReZero Type:%@ Album:%@ Title:%@ Duration:%.0f PlayCount:%@ Bookmark:%0.0f",itemType, itemAlbumTitle, itemTitle,PlaybackDuration,itemPlayCount,BookmarkValue] UTF8String]);
                [ReZeroPodcastItems addObject:item];
                ReZeroPodcastsCount++;
            }
        }
    }
    
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",ItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of Podcasts: %d",PodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nReZeroPodcastsCount: %d", ReZeroPodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nSkipped podcasts: %d", PodcastsSkippedCount] UTF8String]);
    
    ReZeroPlayList=[[MPMediaItemCollection alloc] initWithItems:ReZeroPodcastItems];
    return ReZeroPlayList;
}

+ (MPMediaItemCollection*)ClearPartiallyPlayed: (NSString *)Album{
    NSMutableArray *PlaylistItems= [[NSMutableArray alloc] init];
 
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaLibraryCleanup MediaQuery: Clear Partially Played - %@",Album] UTF8String]);
    MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
    
    // see MediaLibraryStats.h for a list of media item properties
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast]
                                          forProperty: MPMediaItemPropertyMediaType
                                          comparisonType: MPMediaPredicateComparisonEqualTo]];
    
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: Album
                                          forProperty: MPMediaItemPropertyAlbumTitle
                                          comparisonType: MPMediaPredicateComparisonContains]];
    
    [myPodcastsQuery setGroupingType: MPMediaGroupingAlbum];
    
    NSArray *albums = [myPodcastsQuery collections];
    //NSArray *allItems = [myPodcastsQuery items]; // all items are also in this property
    for (MPMediaItemCollection *album in albums) {
        MPMediaItem *representativeItem = [album representativeItem];
        //representativeItem.album
        NSString *albumTitle =
        [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
        
        NSArray *songs = [album items];
        printf("%s", [[NSString stringWithFormat:@"\nPodcast: %@ - ItemCount: %lu", albumTitle, (unsigned long)[songs count]] UTF8String]);
        
        // print each episode
        for (MPMediaItem *song in songs) {
            NSString *songTitle =[song valueForProperty: MPMediaItemPropertyTitle];
            NSString *itemAlbumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
            double PlaybackDuration = [[song valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
            NSString *itemPlayCount = [song valueForProperty:MPMediaItemPropertyPlayCount];
            NSString *itemType = [song valueForProperty:MPMediaItemPropertyMediaType];
            double BookmarkValue = [[song valueForProperty:MPMediaItemPropertyBookmarkTime]doubleValue];
            
            // Partially Played threshold = 15 sec  <<<<<<<<<<<
            if  (BookmarkValue > 15 && [itemPlayCount intValue] == 0){
                printf("%s", [[NSString stringWithFormat:@"\nType:%@ Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",itemType, itemAlbumTitle, songTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                //set song to played - can't do that here ...yet... pass playlist back to MainViewController
                [PlaylistItems addObject:song];
                // create a new class for this
            }
        }
    }
    printf("%s", [[NSString stringWithFormat:@"\nPodcast Titles Count: %lu", (unsigned long)[albums count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nTotal Returned Count: %lu", (unsigned long)[PlaylistItems count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nStats query COMPLETE\n"] UTF8String]);
    
    MPMediaItemCollection *PartiallyPlayedList;
    PartiallyPlayedList=[[MPMediaItemCollection alloc] initWithItems:PlaylistItems];
    return PartiallyPlayedList;  // may have zero items
}

+ (MPMediaItemCollection*)ClearByTitle: (NSString *) Title Album:(NSString *) Album{
        NSMutableArray *PlaylistItems= [[NSMutableArray alloc] init];
    
        printf("%s", [[NSString stringWithFormat:@"\n\nClear by Title - %@ / %@",Album,Title] UTF8String]);
        MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
        
        // see MediaLibraryStats.h for a list of media item properties
        [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                              predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast]
                                              forProperty: MPMediaItemPropertyMediaType
                                              comparisonType: MPMediaPredicateComparisonEqualTo]];
        
        [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                              predicateWithValue: Album
                                              forProperty: MPMediaItemPropertyAlbumTitle
                                              comparisonType: MPMediaPredicateComparisonContains]];
        
        [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                              predicateWithValue: Title
                                              forProperty: MPMediaItemPropertyTitle
                                              comparisonType: MPMediaPredicateComparisonContains]];
        
        //Alternate method - create predicates, add to set....
        //NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"title == %d", 2];  // filter for podcasts, type is 2
        
        // Sets the grouping type for the media query
        [myPodcastsQuery setGroupingType: MPMediaGroupingAlbum];
        
        NSArray *albums = [myPodcastsQuery collections];
        //NSArray *allItems = [myPodcastsQuery items]; // all items are also in this property
    if(albums != nil && albums.count!=0) {
        printf("%s", [[NSString stringWithFormat:@"\nAlbumCount:%lu",(unsigned long)albums.count] UTF8String]);
    for (MPMediaItemCollection *album in albums) {
            MPMediaItem *representativeItem = [album representativeItem];
            //representativeItem.album
            NSString *albumTitle =
            [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
            
            
            NSArray *songs = [album items];
            printf("%s", [[NSString stringWithFormat:@"\nPodcast: %@ - ItemCount: %lu", albumTitle, (unsigned long)[songs count]] UTF8String]);
            
            // print each episode
            
            for (MPMediaItem *song in songs) {
                NSString *songTitle =[song valueForProperty: MPMediaItemPropertyTitle];
                NSString *itemAlbumTitle = [song valueForProperty:MPMediaItemPropertyAlbumTitle];
                double PlaybackDuration = [[song valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
                int itemPlayCount = [song valueForProperty:MPMediaItemPropertyPlayCount];  //<<<<<<<<<<< using int here where string works everywhere else?
                unsigned long itemType = [song valueForProperty:MPMediaItemPropertyMediaType];
                double BookmarkValue = [[song valueForProperty:MPMediaItemPropertyBookmarkTime]doubleValue];
                
                printf("%s", [[NSString stringWithFormat:@"\nFOUND-->Type:%lu Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%i",(unsigned long)itemType, itemAlbumTitle, songTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                
                if  (itemPlayCount  == 3){
                    printf("%s", [[NSString stringWithFormat:@"\nADDING-->Type:%lu Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%i",(unsigned long)itemType, itemAlbumTitle, songTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                    //set song to played - can't do that here ...yet... pass playlist back to MainViewController
                    [PlaylistItems addObject:song];
                    // create a new class for this
                }
            }
        }
    }
    printf("%s", [[NSString stringWithFormat:@"\nPodcast Titles Count: %lu", (unsigned long)[albums count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nTotal Returned Count: %lu", (unsigned long)[PlaylistItems count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nStats query COMPLETE\n"] UTF8String]);
    
    MPMediaItemCollection *ClearByTitleList;
    ClearByTitleList=[[MPMediaItemCollection alloc] initWithItems:PlaylistItems];
    return ClearByTitleList;
}

@end

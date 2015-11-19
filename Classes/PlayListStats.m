//
//  PlayListStats.m
//  AddMusic
//
//  Created by Steve Davies on 10/24/15.
//
//

#import "PlayListStats.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation PlayListStats

@synthesize ItemsCount;
@synthesize ItemsSkippedCount;
@synthesize SongsCount;
@synthesize PodcastsCount;
@synthesize PodcastsSkippedCount;
@synthesize PartiallyPlayedPodcastsCount;
@synthesize PlaylistsCount;
@synthesize inTheCloudCount;

- (void) CalculateStats: (MPMediaItemCollection*) PlayList{ // PlayList stats
    PlaylistsCount=0;
    ItemsCount=0;
    ItemsSkippedCount=0;
    PodcastsSkippedCount=0;
    SongsCount = 0;
    PodcastsCount =0;
    PartiallyPlayedPodcastsCount=0;
    inTheCloudCount=0;
    
    //MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSMutableArray *PartiallyPlayedPodcastItems= [[NSMutableArray alloc] init];
    NSArray *itemsFromGenericQuery = [PlayList items];
    
    printf("%s", [[NSString stringWithFormat:@"\n\nLooking PlayList..."] UTF8String]);
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
        NSString *IsCloudItem = [item valueForProperty:MPMediaItemPropertyIsCloudItem];
        
        if ([itemSkipCount intValue] > 0){
            ItemsSkippedCount++;
        }
        
        if (TypeValue == 1){
            SongsCount++;
        }
        
        if ([IsCloudItem intValue] == 1){
            inTheCloudCount++;
        }
        
        if (TypeValue == 2) {
            PodcastsCount++;
            if ([itemSkipCount intValue] > 0){
                PodcastsSkippedCount++;
            }
            if  (BookmarkValue>0){
                printf("%s", [[NSString stringWithFormat:@"\nPP Type:%@ Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",itemType, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                // ADD itme to MutableArray here
                [PartiallyPlayedPodcastItems addObject:item];
                PartiallyPlayedPodcastsCount++;
            }
        }
        //if(TypeValue != 1 && TypeValue != 2){
        //   printf("%s", [[NSString stringWithFormat:@"\n!!!! Type:%@ Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@ Cloud:%@",itemType, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount,IsCloudItem] UTF8String]);
        //}
    }
    
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",ItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of songs: %d",SongsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of Podcasts: %d",PodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPartially Palyed podcasts: %d", PartiallyPlayedPodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nSkipped podcasts: %d", PodcastsSkippedCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nCloud items: %d", inTheCloudCount] UTF8String]);
    
    // enumerate playlists
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    PlaylistsCount=(int)[playlists count];
    printf("%s", [[NSString stringWithFormat:@"\n\nPlaylist Information:"] UTF8String]);
    for (MPMediaPlaylist *playlist in playlists)
    {
        //NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        NSArray *songslist = [playlist items];
        printf("%s", [[NSString stringWithFormat:@"\n%@, Songs:%d",[playlist name],(int)[songslist count]] UTF8String]);
        // enumerates each item
        /*for (MPMediaItem *song in songslist)
         {
         NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
         NSLog (@"\t\t%@", songTitle);
         //NSLog (@"\t\t\t%@", [song valueForProperty: MPMediaItemPropertyPersistentID]);
         }*/
    }
    printf("%s", [[NSString stringWithFormat:@"\nPlaylists Count: %d", PlaylistsCount] UTF8String]);
    
    
    
    //custom query that is an album query filtered for podcasts <<<<<<<------
    // Duplicates ---->>>> MPMediaQuery *myPodcastsQuery = [MPMediaQuery podcastsQuery]; with extra controls
    
    ////////////////////////////////
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaQuery:"] UTF8String]);
    MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
    
    // see MediaLibraryStats.h for a list of media item properties
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast]
                                          forProperty: MPMediaItemPropertyMediaType
                                          comparisonType: MPMediaPredicateComparisonEqualTo]];
    
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: @"EconTalk"
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
        printf("%s", [[NSString stringWithFormat:@"\nPodcast: %@ - ItemCount: %lu", albumTitle, (unsigned long)[songs count]] UTF8String]);
        /*
         // print each episode
         for (MPMediaItem *song in songs) {
         NSString *songTitle =
         [song valueForProperty: MPMediaItemPropertyTitle];
         printf("%s", [[NSString stringWithFormat:@"\n   Episode: %@", songTitle] UTF8String]);
         }
         */
    }
    printf("%s", [[NSString stringWithFormat:@"\nPodcast Titles Count: %lu", (unsigned long)[albums count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nStats query COMPLETE\n"] UTF8String]);
    ////////////////////////////////
}

@end

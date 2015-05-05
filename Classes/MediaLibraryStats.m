//
//  MediaLibraryStats.m
//  AddMusic
//
//  Created by Steve Davies on 2/26/15.
//
//

#import "MediaLibraryStats.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation MediaLibraryStats

@synthesize ItemsCount;
@synthesize SongsCount;
@synthesize PodcastsCount;
@synthesize PartiallyPlayedPodcastsCount;
@synthesize PlaylistsCount;

- (void) CalculateStats{
    PlaylistsCount=0;
    ItemsCount=0;
    SongsCount = 0;
    PodcastsCount =0;
    PartiallyPlayedPodcastsCount=0;
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSMutableArray *PlaylistItems= [[NSMutableArray alloc] init];
    NSArray *itemsFromGenericQuery = [everything items];
    printf("%s", [[NSString stringWithFormat:@"\n\nLooking at entire library..."] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\n\nTypeValue 2, Partially Played:"] UTF8String]);
    for (MPMediaItem *item in itemsFromGenericQuery) {
        ItemsCount++;
        
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        double PlaybackDuration = [[item valueForProperty:MPMediaItemPropertyPlaybackDuration]doubleValue];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        double BookmarkValue = [[item valueForProperty:MPMediaItemPropertyBookmarkTime]doubleValue];
        
        if (TypeValue == 1){
            SongsCount++;
        }
        
        if (TypeValue == 2) {
            PodcastsCount++;
            if  (BookmarkValue>0){
                printf("%s", [[NSString stringWithFormat:@"\nType:%@ Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",itemType, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                // ADD itme to MutableArray here
                [PlaylistItems addObject:item];
                PartiallyPlayedPodcastsCount++;
            }
        };
    }
    
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",ItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of songs: %d",SongsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of Podcasts: %d",PodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPartially Palyed podcasts: %d", PartiallyPlayedPodcastsCount] UTF8String]);
    
    // enumerate playlists
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    PlaylistsCount=[playlists count];
    printf("%s", [[NSString stringWithFormat:@"\n\nPlaylist Information:"] UTF8String]);
    for (MPMediaPlaylist *playlist in playlists)
    {
        //NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        NSArray *songslist = [playlist items];
        printf("%s", [[NSString stringWithFormat:@"\n%@, Songs:%d",[playlist name],[songslist count]] UTF8String]);
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
        printf("%s", [[NSString stringWithFormat:@"\nPodcast: %@ - ItemCount: %d", albumTitle, [songs count]] UTF8String]);
        /*
         // print each episode
        for (MPMediaItem *song in songs) {
            NSString *songTitle =
            [song valueForProperty: MPMediaItemPropertyTitle];
            printf("%s", [[NSString stringWithFormat:@"\n   Episode: %@", songTitle] UTF8String]);
        }
         */
    }
    printf("%s", [[NSString stringWithFormat:@"\nPodcast Titles Count: %d", [albums count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nTotal Podcast Episodes Count: %d", [myPodcastsQuery.items count]] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nStats query COMPLETE\n"] UTF8String]);
    ////////////////////////////////
}
@end

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
    //NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
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
        
        if (TypeValue == 0){
            SongsCount++;
        }
        
        if (TypeValue == 2) {
            PodcastsCount++;
            if  (BookmarkValue>0){
                //NSLog (@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount);
                //printf("\nType:%s Title:%s-%s Bookmark:%s Duration:%s PlayCount:%s",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount);
                printf("%s", [[NSString stringWithFormat:@"\nType:%@ Album:%@ Title:%@ Bookmark:%0.0f Duration:%.0f PlayCount:%@",itemType, itemAlbumTitle, itemTitle, BookmarkValue,PlaybackDuration,itemPlayCount] UTF8String]);
                // ADD itme to MutableArray here
                [PlaylistItems addObject:item];
                PartiallyPlayedPodcastsCount++;
            }
        };
        
        //[PartiallyPlayedList MPMediaPlaylistPropertyName:@"Test"];
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
        /*for (MPMediaItem *song in songslist)
        {
            NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
            NSLog (@"\t\t%@", songTitle);
            //NSLog (@"\t\t\t%@", [song valueForProperty: MPMediaItemPropertyPersistentID]);
        }*/
    }
    printf("%s", [[NSString stringWithFormat:@"Playlists Count: %d", PlaylistsCount] UTF8String]);
    

    
    
    // MPMediaQuery *myPodcastsQuery = [MPMediaQuery podcastsQuery];
    
    // try building custom query that is an album query filtered for podcasts <<<<<<<------
    //NSPredicate *typePredicate = [NSPredicate predicateWithFormat:@"title == %d", 2];  // filter for podcasts, type is 2
    
    ////////////////////////////////
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaQuery:"] UTF8String]);
    MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
    
    // see MediaLibraryStats.h for a list of media item properties
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast] //MPMediaTypePodcast
                                          forProperty: MPMediaItemPropertyMediaType]];
    
    [myPodcastsQuery addFilterPredicate: [MPMediaPropertyPredicate
                                          predicateWithValue: @"EconTalk"
                                          forProperty: MPMediaItemPropertyAlbumTitle
                                        comparisonType: MPMediaPredicateComparisonContains]];
    
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
    
    // from here down  is discarded trys
    /*
    // enumerating items in itemsSections of PodcastsQuery which groups and sorts
    // looking to build the list of podcast names
    NSArray *itemSections=[myPodcastsQuery itemSections];
    NSArray *myPodcastsQueryItems=[myPodcastsQuery items];
    for (MPMediaQuerySection *section in itemSections)
    {
        NSString *buffer = @"";
        printf("%s", [[NSString stringWithFormat:@"\n%@", buffer] UTF8String]);
        
        NSRange R=[section range];
        int Location = R.location;
        int Length=R.length;
        NSString *Title = [section title];
        printf("%s", [[NSString stringWithFormat:@"\nIS Title=%@ Location=%d Range=%d", Title,Location,Length] UTF8String]);
        
        MPMediaItem *currentItem = [myPodcastsQueryItems objectAtIndex:(Location)];
        
        NSString *itemTitle = [currentItem valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemAlbumTitle = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];
        printf("%s", [[NSString stringWithFormat:@"\n%@-%@",itemAlbumTitle, itemTitle] UTF8String]);
    }
    */
     
    /*// this block enumerates all items in myPodcastsQueryItems
    for (MPMediaItem *item in myPodcastsQueryItems)
    {
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        printf("%s", [[NSString stringWithFormat:@"\n%@-%@",itemAlbumTitle, itemTitle] UTF8String]);
        int i=0;
        i++;
    }*/

    /*
    // enumerating collections in collectionSections
    NSArray *sections=[myPodcastsQuery collectionSections];
    for (MPMediaQuerySection *section in sections)
    {
        NSRange R=[section range];
        int Location = R.location;
        int Length=R.length;
        NSString *Title = [section title];
        printf("%s", [[NSString stringWithFormat:@"\nCS Title=%@ Location=%d Range=%d", Title,Location,Length] UTF8String]);
    }
    */
    
        //NSArray *items=[myPodcastsQuery itemSections];
    
    /*
    NSArray *PodcastNames = [myPodcastsQuery collections];
    
    for (MPMediaItemCollection *collection in PodcastNames)
    {
        printf("%s", [[NSString stringWithFormat:@"\nA:"] UTF8String]);
        MPMediaItemCollection *Podcast = collection;
        
        for (MPMediaEntity *item in Podcast)
        {
            printf("%s", [[NSString stringWithFormat:@"\nB:"] UTF8String]);
            NSString *itemAlbumTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        }
    }
    
    int TitlesCount =[[PodcastNames collectionSections] count];
    */
    
    /*
    for (MPMediaQuerySection *PodcastTitle in myPodcastsQuery)
    {
        printf("%s", [[NSString stringWithFormat:@"Number of items: %d",1] UTF8String]);
  
    }
    */
}
@end

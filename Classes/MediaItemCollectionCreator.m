//
//  MediaItemCollectionCreator.m
//  AddMusic
//
//  Created by Steve Davies MXTB on 2/27/15.
//
//

#import "MediaItemCollectionCreator.h"
#import <MediaPlayer/MediaPlayer.h>

// make these two separate calls (music, podcast) --> pass an NSMutableArray, return an NSMutableArray
// add parameters for media propterty predicates
/*
 Podcast item property keys
NSString *const MPMediaItemPropertyPlayCount;
NSString *const MPMediaItemPropertySkipCount;
NSString *const MPMediaItemPropertyRating;
NSString *const MPMediaItemPropertyLastPlayedDate;
NSString *const MPMediaItemPropertyUserGrouping;
NSString *const MPMediaItemPropertyBookmarkTime;
 */

@implementation MediaItemCollectionCreator

+ (void) AddPartiallyPlayedToPlaylist:(NSMutableArray *) PlaylistItems{
   
    int ItemsCount=0;
    int PodcastsSkippedCount=0;
    int PodcastsCount =0;
    int PartiallyPlayedPodcastsCount=0;
    int inTheCloudCount=0;
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
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
        NSString *IsCloudItem = [item valueForProperty:MPMediaItemPropertyIsCloudItem];
        
        if (TypeValue == 2) {
            PodcastsCount++;
            if ([IsCloudItem intValue] == 1){
                inTheCloudCount++;
            }
            if ([itemSkipCount intValue] > 0){
                PodcastsSkippedCount++;
            }
            if  (BookmarkValue > 15){
                printf("%s", [[NSString stringWithFormat:@"\nPP Type:%@ Album:%@ Title:%@ Duration:%.0f PlayCount:%@ Bookmark:%0.0f",itemType, itemAlbumTitle, itemTitle,PlaybackDuration,itemPlayCount,BookmarkValue] UTF8String]);
                // ADD item to MutableArray here
                [PlaylistItems addObject:item];
                PartiallyPlayedPodcastsCount++;
            }
        }
    }
    
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",ItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of Podcasts: %d",PodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPartially Palyed podcasts: %d", PartiallyPlayedPodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nSkipped podcasts: %d", PodcastsSkippedCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nCloud items: %d", inTheCloudCount] UTF8String]);
    // playlist returned by reference
}

+ (void) AddPodcastToPlaylist: (NSString*) Album
                      Playlist: (NSMutableArray *) PlaylistItems
                       OrderBy: (BOOL) Order
                   NumberToAdd: (NSInteger) NumberToAdd

{
    int PodcastQueryItemsCount=0;
    int partiallyPlayedCount=0;
    int PlaylistItemsCount=0;
    int PlaylistsCount=0;
   
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaQuery %@:",Album] UTF8String]);
    MPMediaQuery *myPodcastsQuery = [[MPMediaQuery alloc] init];
    
    // see MediaLibraryStats.h for a list of media item properties
    MPMediaPropertyPredicate *typePredicate = [MPMediaPropertyPredicate
                                               predicateWithValue: [NSNumber numberWithInteger:MPMediaTypePodcast]
                                               forProperty: MPMediaItemPropertyMediaType
                                               comparisonType: MPMediaPredicateComparisonEqualTo];
    MPMediaPropertyPredicate *titlePredicate = [MPMediaPropertyPredicate
                                                predicateWithValue: Album
                                                forProperty: MPMediaItemPropertyAlbumTitle
                                                comparisonType: MPMediaPredicateComparisonContains];
    [myPodcastsQuery addFilterPredicate: typePredicate];
    [myPodcastsQuery addFilterPredicate: titlePredicate];
    [myPodcastsQuery setGroupingType: MPMediaGroupingAlbum];
    NSArray *itemsFromGenericQuery = [myPodcastsQuery items];
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"releaseDate"
                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [itemsFromGenericQuery sortedArrayUsingDescriptors:sortDescriptors];
    
    // add only partially played podcast items first
    for (MPMediaItem *item in sortedArray) {
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        NSDate *ReleaseDate = [item valueForProperty:MPMediaItemPropertyReleaseDate];
        //NSString*itemDescription = [item valueForProperty:MPMediaItemPropertyDescription];
        
        if(TypeValue == 2 & BookmarkValue > 0 && PlaylistItemsCount < NumberToAdd && [itemPlayCount intValue] ==0 && [itemBookmarkTime intValue]>15) {
            printf("%s", [[NSString stringWithFormat:@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@ Release:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount,ReleaseDate] UTF8String]);
            [PlaylistItems addObject:item];
            PlaylistItemsCount++;
        };
        PodcastQueryItemsCount++;
    }
    // now add only un-played podcast items 
    for (MPMediaItem *item in sortedArray) {
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        NSDate *ReleaseDate = [item valueForProperty:MPMediaItemPropertyReleaseDate];
        //NSString*itemDescription = [item valueForProperty:MPMediaItemPropertyDescription];
        
        if(TypeValue == 2 & BookmarkValue == 0 && PlaylistItemsCount < NumberToAdd && [itemPlayCount intValue] ==0 && [itemBookmarkTime intValue]>15) {
            printf("%s", [[NSString stringWithFormat:@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@ Release:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount,ReleaseDate] UTF8String]);
            [PlaylistItems addObject:item];
            PlaylistItemsCount++;
        };
        PodcastQueryItemsCount++;
    }
    
    printf("%s", [[NSString stringWithFormat:@"Playlists Count: %d", PlaylistsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items matching query: %d",PodcastQueryItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPartially Palyed podcasts: %d", partiallyPlayedCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber added to Playlist: %d", PlaylistItemsCount] UTF8String]);
    // playlist returned by reference
}

+ (void) AddMusicPlaylist: (NSString*) MusicPlaylistName
          Playlist: (NSMutableArray *) PlaylistItems
{
    int PodcastQueryItemsCount=0;
    int PlaylistItemsCount=0;
    NSUInteger PlaylistsCount=0;
    NSUInteger SongsCount=0;
    
    // enumerate playlists
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current PlaylistQuery:"] UTF8String]);
    
    NSArray *playlists = [myPlaylistsQuery collections];
    PlaylistsCount=[playlists count];
    printf("%s", [[NSString stringWithFormat:@"\nPlaylist Information:"] UTF8String]);
    for (MPMediaPlaylist *playlist in playlists)
    {
        printf("%s", [[NSString stringWithFormat:@"\nPlaylists Name: %@", [playlist valueForProperty: MPMediaPlaylistPropertyName]] UTF8String]);
        
        NSArray *songslist = [playlist items];
        SongsCount =[songslist count];
        printf("%s", [[NSString stringWithFormat:@"\n%@, Songs:%lu",[playlist name],(unsigned long)SongsCount] UTF8String]);

        if ([[playlist name]  isEqual: MusicPlaylistName])  // match on Ride Music 2    <<<<<-----
        {
            for (MPMediaItem *song in songslist)
            {
                NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
                printf("%s", [[NSString stringWithFormat:@"\n    Song:%@",songTitle] UTF8String]);
                [PlaylistItems addObject:song];
                PlaylistItemsCount++;
            }
        }
    }
    printf("%s", [[NSString stringWithFormat:@"Playlists Count: %lu", (unsigned long)PlaylistsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",PodcastQueryItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of songs: %lu",(unsigned long)SongsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPlaylist Items: %d", PlaylistItemsCount] UTF8String]);
}

@end

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

+ (void) AddPodcastsToPlaylist: (NSString*) Album
                      Playlist: (NSMutableArray *) PlaylistItems
                       orderBy: (NSString*) Order
                   numberToAdd: (NSInteger*) Count
{
    int PodcastQueryItemsCount=0;
    int partiallyPlayedCount=0;
    int PlaylistItemsCount=0;
    int PlaylistsCount=0;
    int SongsCount=0;
   
    //MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    printf("%s", [[NSString stringWithFormat:@"\n\nFrom the current MediaQuery:"] UTF8String]);
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
    
    
    for (MPMediaItem *item in itemsFromGenericQuery) {
        
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        NSDate *ReleaseDate = [item valueForProperty:MPMediaItemPropertyReleaseDate];
        //NSString*itemComment = [item valueForProperty:MPMediaItemPropertyComments];
        
        if(TypeValue == 2 & BookmarkValue >= 0) {
            printf("%s", [[NSString stringWithFormat:@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount] UTF8String]);
            [PlaylistItems addObject:item];
            partiallyPlayedCount++;
            PlaylistItemsCount++;
        };
        PodcastQueryItemsCount++;
    }
    
        printf("%s", [[NSString stringWithFormat:@"Playlists Count: %d", PlaylistsCount] UTF8String]);
    
    // create a playlist here
    //MPMediaItemCollection *Playlist=[[MPMediaItemCollection alloc] initWithItems:PlaylistItems];
    
    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",PodcastQueryItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPartially Palyed podcasts: %d", partiallyPlayedCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of songs: %d",SongsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPlaylist Items: %d", PlaylistItemsCount] UTF8String]);
}

+ (void) AddMusicPlaylist: (NSString*) MusicPlaylistName
          Playlist: (NSMutableArray *) PlaylistItems
{
    int PodcastQueryItemsCount=0;

    int PlaylistItemsCount=0;
    int PlaylistsCount=0;
    int SongsCount=0;
    
    // now select some music items
    // consider changing strategy to match podcast
    
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
        printf("%s", [[NSString stringWithFormat:@"\n%@, Songs:%d",[playlist name],SongsCount] UTF8String]);
        // match on Ride Music 2    <<<<<-----
        // enumerates each item
        if ([[playlist name]  isEqual: MusicPlaylistName])
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
    printf("%s", [[NSString stringWithFormat:@"Playlists Count: %d", PlaylistsCount] UTF8String]);

    printf("%s", [[NSString stringWithFormat:@"\nNumber of items: %d",PodcastQueryItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nNumber of songs: %d",SongsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"\nPlaylist Items: %d", PlaylistItemsCount] UTF8String]);
}

@end

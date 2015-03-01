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
    for (MPMediaItem *item in itemsFromGenericQuery) {
        ItemsCount++;
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        if (TypeValue == 0){
            SongsCount++;
        }
        if (TypeValue == 2) {
            PodcastsCount++;
            if  (BookmarkValue>0){
                //NSLog (@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount);
                //printf("\nType:%s Title:%s-%s Bookmark:%s Duration:%s PlayCount:%s",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount);
                printf("%s", [[NSString stringWithFormat:@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount] UTF8String]);
                // ADD itme to MutableArray here
                [PlaylistItems addObject:item];
                PartiallyPlayedPodcastsCount++;
            }
        };
        
        //[PartiallyPlayedList MPMediaPlaylistPropertyName:@"Test"];
    }
    
    printf("%s", [[NSString stringWithFormat:@"Number of songs: %d",SongsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"Number of items: %d",ItemsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"Number of items: %d",PodcastsCount] UTF8String]);
    printf("%s", [[NSString stringWithFormat:@"Partially Palyed podcasts: %d", PartiallyPlayedPodcastsCount] UTF8String]);
    
    // enumerate playlists
    MPMediaQuery *myPlaylistsQuery = [MPMediaQuery playlistsQuery];
    NSArray *playlists = [myPlaylistsQuery collections];
    PlaylistsCount=[playlists count];
    for (MPMediaPlaylist *playlist in playlists)
    {
        NSLog (@"%@", [playlist valueForProperty: MPMediaPlaylistPropertyName]);
        NSArray *songslist = [playlist items];
        NSLog(@"%@,Songs:%d",[playlist name],[songslist count]);
        /*for (MPMediaItem *song in songslist)
        {
            NSString *songTitle = [song valueForProperty: MPMediaItemPropertyTitle];
            NSLog (@"\t\t%@", songTitle);
            //NSLog (@"\t\t\t%@", [song valueForProperty: MPMediaItemPropertyPersistentID]);
        }*/
    }
    printf("%s", [[NSString stringWithFormat:@"Playlissts: %d", PlaylistsCount] UTF8String]);
}
@end

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
    
    MPMediaQuery *everything = [[MPMediaQuery alloc] init];
    
    NSMutableArray *PlaylistItems= [[NSMutableArray alloc] init];
    //NSLog(@"Logging items from a generic query...");
    NSArray *itemsFromGenericQuery = [everything items];
    for (MPMediaItem *item in itemsFromGenericQuery) {
        
        NSString *itemTitle = [item valueForProperty: MPMediaItemPropertyTitle];
        NSString *itemBookmarkTime = [item valueForProperty:MPMediaItemPropertyBookmarkTime];
        double BookmarkValue = [itemBookmarkTime doubleValue];
        if (BookmarkValue>0)
        {
            //NSLog(@"Found Partially Played !! %@-%f",itemTitle,BookmarkValue);
            //partiallyPlayedCount++;
        };
        NSString *itemPlaybackDuration = [item valueForProperty:MPMediaItemPropertyPlaybackDuration];
        NSString *itemPlayCount = [item valueForProperty:MPMediaItemPropertyPlayCount];
        NSString *itemType = [item valueForProperty:MPMediaItemPropertyMediaType];
        NSString *itemAlbumTitle = [item valueForProperty:MPMediaItemPropertyAlbumTitle];
        int TypeValue = [[item valueForProperty:MPMediaItemPropertyMediaType] intValue];
        if(TypeValue == 2 & BookmarkValue>0) {
            //NSLog (@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount);
            //printf("\nType:%s Title:%s-%s Bookmark:%s Duration:%s PlayCount:%s",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount);
            printf("%s", [[NSString stringWithFormat:@"\nType:%@ Title:%@-%@ Bookmark:%@ Duration:%@ PlayCount:%@",itemType, itemAlbumTitle, itemTitle, itemBookmarkTime,itemPlaybackDuration,itemPlayCount] UTF8String]);
            // ADD itme to MutableArray here
            [PlaylistItems addObject:item];
            partiallyPlayedCount++;
        };
        
        //[PartiallyPlayedList MPMediaPlaylistPropertyName:@"Test"];
        itemsCount++;
    }
    
    // create a playlist here
    //PartiallyPlayedList
    MPMediaItemCollection *PartiallyPlayedList=[[MPMediaItemCollection alloc] initWithItems:PlaylistItems]; //--------->>>>>>>>>> changed type here <<<<<<<<<-----------
    
    NSLog(@"Number of items: %d",itemsCount);
    NSLog(@"Partially Palyed: %d", partiallyPlayedCount);
    return PartiallyPlayedList;
}

@end

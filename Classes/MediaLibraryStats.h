//
//  MediaLibraryStats.h
//  AddMusic
//
//  Created by Steve Davies on 2/26/15.
//
//

#import <Foundation/Foundation.h>


@interface MediaLibraryStats : NSObject

@property (nonatomic, readonly ) int PlaylistsCount;
@property (nonatomic, readonly ) int ItemsCount;
@property (nonatomic, readonly ) int ItemsSkippedCount;
@property (nonatomic, readwrite) int SongsCount;

@property (nonatomic, readwrite) int PodcastsCount;
@property (nonatomic, readwrite) int PodcastsSkippedCount;
@property (nonatomic, readwrite) int PartiallyPlayedPodcastsCount;

@property (nonatomic, readwrite) int inTheCloudCount;
-(void) CalculateStats;
@end

/*  For convenient reference: media item properties
 
NSString *const MPMediaItemPropertyPersistentID ;            // filterable
NSString *const MPMediaItemPropertyAlbumPersistentID ;       // filterable
NSString *const MPMediaItemPropertyArtistPersistentID ;      // filterable
NSString *const MPMediaItemPropertyAlbumArtistPersistentID ; // filterable
NSString *const MPMediaItemPropertyGenrePersistentID ;       // filterable
NSString *const MPMediaItemPropertyComposerPersistentID ;    // filterable
NSString *const MPMediaItemPropertyPodcastPersistentID ;     // filterable
NSString *const MPMediaItemPropertyMediaType ;               // filterable
NSString *const MPMediaItemPropertyTitle ;                   // filterable
NSString *const MPMediaItemPropertyAlbumTitle ;              // filterable
NSString *const MPMediaItemPropertyArtist ;                  // filterable
NSString *const MPMediaItemPropertyAlbumArtist ;             // filterable
NSString *const MPMediaItemPropertyGenre ;                   // filterable
NSString *const MPMediaItemPropertyComposer ;                // filterable
NSString *const MPMediaItemPropertyPlaybackDuration;
NSString *const MPMediaItemPropertyAlbumTrackNumber;
NSString *const MPMediaItemPropertyAlbumTrackCount;
NSString *const MPMediaItemPropertyDiscNumber;
NSString *const MPMediaItemPropertyDiscCount;
NSString *const MPMediaItemPropertyArtwork;
NSString *const MPMediaItemPropertyLyrics;
NSString *const MPMediaItemPropertyIsCompilation ;           // filterable
NSString *const MPMediaItemPropertyReleaseDate;
NSString *const MPMediaItemPropertyBeatsPerMinute;
NSString *const MPMediaItemPropertyComments;
NSString *const MPMediaItemPropertyAssetURL;
NSString *const MPMediaItemPropertyIsCloudItem ;              // filterable
*/
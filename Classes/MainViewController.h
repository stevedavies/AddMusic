/*
    File: MainViewController.h
Abstract: View controller class for AddMusic. Sets up user interface, responds 
to and manages user interaction.
 Version: 1.1

*/

#define PLAYER_TYPE_PREF_KEY @"player_type_preference"
#define AUDIO_TYPE_PREF_KEY @"audio_technology_preference"

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "MusicTableViewController.h"
#import "AddMusicAppDelegate.h"

@interface MainViewController : UIViewController <MPMediaPickerControllerDelegate, MusicTableViewControllerDelegate, AVAudioPlayerDelegate> {

	AddMusicAppDelegate			*applicationDelegate;
	IBOutlet UIBarButtonItem	*artworkItem;
	IBOutlet UINavigationBar	*navigationBar;
	IBOutlet UILabel			*nowPlayingLabel;

    IBOutlet UILabel			*songCountLabel;
	IBOutlet UILabel			*podcastCountLabel;
	IBOutlet UILabel			*partiallyPlayedCountLabel;
	
    IBOutlet UILabel			*PLsongCountLabel;
    IBOutlet UILabel			*PLpodcastCountLabel;
    IBOutlet UILabel			*PLpartiallyPlayedCountLabel;
    
    BOOL						playedMusicOnce;

	IBOutlet UIButton			*addOrShowMusicButton;
    IBOutlet UIButton           *CreatePlaylistAndPlayButton;
    IBOutlet UIButton           *Minus30Button;
    IBOutlet UIButton           *Plus30Button;
    IBOutlet UIButton           *Minus10Button;
    IBOutlet UIButton           *Plus10Button;
    IBOutlet UIButton           *Minus60Button;
    IBOutlet UIButton           *Plus60Button;
    IBOutlet UIButton           *MoveZeroButton;
    IBOutlet UIButton           *LibStatsButton;
    IBOutlet UIButton           *PLStatsButton;
    IBOutlet UIButton           *nnButton;
    IBOutlet UIButton           *ppButton;
    IBOutlet UIButton           *ClearPartiallyPlayedButton;
    IBOutlet UIButton           *ClearByTitleButton;
    IBOutlet UIButton           *ReZeroButton;
    IBOutlet UIButton           *PPPLButton;
	BOOL						interruptedOnPlayback;
	BOOL						playing ;

	UIBarButtonItem				*playBarButton;
	UIBarButtonItem				*pauseBarButton;
	MPMusicPlayerController		*musicPlayer;	
	MPMediaItemCollection		*userMediaItemCollection;
	UIImage						*noArtworkImage;

}
@property (nonatomic, retain)	MPMediaItemCollection   *CreatedPlayList;

@property (nonatomic, retain)	UIBarButtonItem			*artworkItem;
@property (nonatomic, retain)	UINavigationBar			*navigationBar;
@property (nonatomic, retain)	UILabel					*nowPlayingLabel;

@property (nonatomic, retain)	UILabel					*songCountLabel;
@property (nonatomic, retain)	UILabel					*podcastCountLabel;
@property (nonatomic, retain)	UILabel					*partiallyPlayedCountLabel;

@property (nonatomic, retain)	UILabel					*PLsongCountLabel;
@property (nonatomic, retain)	UILabel					*PLpodcastCountLabel;
@property (nonatomic, retain)	UILabel					*PLpartiallyPlayedCountLabel;

@property (readwrite)			BOOL					playedMusicOnce;

@property (nonatomic, retain)	UIBarButtonItem			*playBarButton;
@property (nonatomic, retain)	UIBarButtonItem			*pauseBarButton;
@property (nonatomic, retain)	MPMediaItemCollection	*userMediaItemCollection; 
@property (nonatomic, retain)	MPMusicPlayerController	*musicPlayer;
@property (nonatomic, retain)	UIImage					*noArtworkImage;
@property (nonatomic, retain)	NSTimer					*backgroundColorTimer;

@property (nonatomic, retain)	AVAudioPlayer			*appSoundPlayer;
@property (nonatomic, retain)	NSURL					*soundFileURL;
@property (nonatomic, retain)	IBOutlet UIButton		*addOrShowMusicButton;
@property (nonatomic, retain)   IBOutlet UIButton       *CreatePlaylistAndPlayButton;
@property (nonatomic, retain)   IBOutlet UIButton       *Minus30Button;
@property (nonatomic, retain)   IBOutlet UIButton       *Plus30Button;
@property (nonatomic, retain)   IBOutlet UIButton       *Minus60Button;
@property (nonatomic, retain)   IBOutlet UIButton       *Plus60Button;
@property (nonatomic, retain)   IBOutlet UIButton       *Minus10Button;
@property (nonatomic, retain)   IBOutlet UIButton       *Plus10Button;
@property (nonatomic, retain)   IBOutlet UIButton       *MoveZeroButton;
@property (nonatomic, retain)   IBOutlet UIButton       *LibStatsButton;
@property (nonatomic, retain)   IBOutlet UIButton       *PLStatsButton;
@property (nonatomic, retain)   IBOutlet UIButton       *nnButton;
@property (nonatomic, retain)   IBOutlet UIButton       *ppButton;
@property (nonatomic, retain)   IBOutlet UIButton       *ClearPartiallyPlayedButton;
@property (nonatomic, retain)   IBOutlet UIButton       *ReZeroButton;
@property (nonatomic, retain)   IBOutlet UIButton       *PPPLButton;
@property (nonatomic, retain)   IBOutlet UIButton       *ClearByTitleButton;
@property (readwrite)			BOOL					interruptedOnPlayback;
@property (readwrite)			BOOL					playing;

- (IBAction)	playOrPauseMusic:		(id) sender;
- (IBAction)	AddMusicOrShowMusic:	(id) sender;

- (BOOL) useiPodPlayer;

@end

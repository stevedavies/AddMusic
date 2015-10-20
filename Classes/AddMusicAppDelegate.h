/*
    File: AddMusicAppDelegate.h
Abstract: Application delegate class for AddMusic.
 Version: 1.1

*/


#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVPlayer.h>

@class MainViewController;

@interface AddMusicAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow					*window;
	IBOutlet MainViewController	*mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow				*window;
@property (nonatomic, retain) IBOutlet MainViewController	*mainViewController;
// working on bluetooth
@property (nonatomic, retain) IBOutlet AVAudioSession       *session;
@property (nonatomic, retain) IBOutlet AVPlayer             *audioPlayer;
@end


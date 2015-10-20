/*
    File: AddMusicAppDelegate.m
Abstract: Application delegate class for AddMusic.
 Version: 1.1

*/


#import "AddMusicAppDelegate.h"
#import "MainViewController.h"

@implementation AddMusicAppDelegate

@synthesize window, mainViewController;


- (void) applicationDidFinishLaunching: (UIApplication *) application {

	//[window addSubview: [mainViewController view]];
    [self.window setRootViewController:mainViewController];
    [window makeKeyAndVisible];
    
    self.session = [AVAudioSession sharedInstance];
    
    NSError* error = NULL;
    [self.session setCategory:AVAudioSessionCategoryPlayback error:&error];
    [self.session setActive:YES error:&error];
    
    if (error) {
        NSLog(@"AVAudioSession error: %@", [error localizedDescription]);
    }
}


- (void)dealloc {

    [window release];
    [super dealloc];
}


@end

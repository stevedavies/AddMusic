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

	[window addSubview: [mainViewController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {

    [window release];
    [super dealloc];
}


@end

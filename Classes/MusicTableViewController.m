/*
    File: MusicTableViewController.m
Abstract: Table view controller class for AddMusic. Shows the list
of music chosen by the user.
 Version: 1.1

*/


#import "MusicTableViewController.h"
#import "MainViewController.h"

@implementation MusicTableViewController

static NSString *kCellIdentifier = @"Cell";

@synthesize delegate;					// The main view controller is the delegate for this class.
@synthesize mediaItemCollectionTable;	// The table shown in this class's view.
@synthesize addMusicButton;				// The button for invoking the media item picker. Setting the title
										//		programmatically supports localization.


// Configures the table view.
- (void) viewDidLoad {

    //[super viewDidLoad];
	
	//[self.addMusicButton setTitle: NSLocalizedString (@"AddMusicFromTableView", @"Add button shown on table view for invoking the media item picker")];
	
    //self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
}


// When the user taps Done, invokes the delegate's method that dismisses the table view.
- (IBAction) doneShowingMusicList: (id) sender {

	[self.delegate musicTableViewControllerDidFinish: self];
}


// Configures and displays the media item picker.
- (IBAction) showMediaPicker: (id) sender {

	MPMediaPickerController *picker =
		[[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAnyAudio];
	
	picker.delegate						= self;
	picker.allowsPickingMultipleItems	= YES;
	picker.prompt						= NSLocalizedString (@"AddSongsPrompt", @"Prompt to user to choose some songs to play");
	
	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleDefault animated:YES];

	//[self presentModalViewController: picker animated: YES];
	//[picker release];
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  
    
    [self dismissViewControllerAnimated: YES completion:nil];
	//[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
	[self.mediaItemCollectionTable reloadData];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {

	[self dismissViewControllerAnimated: NO completion: nil];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent animated:YES];
}



#pragma mark Table view methods________________________

// To learn about using table views, see the TableViewSuite sample code  
//		and Table View Programming Guide for iPhone OS.

- (NSInteger) tableView: (UITableView *) table numberOfRowsInSection: (NSInteger)section {

	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	return [currentQueue.items count];
}

- (UITableViewCell *) tableView: (UITableView *) tableView cellForRowAtIndexPath: (NSIndexPath *) indexPath {

	NSInteger row = [indexPath row];
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	
	if (cell == nil) {
	
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault //was initWithFrame: CGRectZero
									   reuseIdentifier: kCellIdentifier] autorelease];
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
        cell.textLabel.font= [UIFont systemFontOfSize:10.0];
	}
	
	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: row];
    NSString *itemText;
    NSDateComponentsFormatter *dcFormatter = [[NSDateComponentsFormatter alloc] init];
    NSString *duration;
    NSString *position;
    int durationSeconds;
    double positionSeconds;
	if (anItem) {
        durationSeconds =(int)[[anItem valueForProperty:MPMediaItemPropertyPlaybackDuration] floatValue];
        positionSeconds =(double)[[anItem valueForProperty:MPMediaItemPropertyBookmarkTime] floatValue];
        dcFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
        dcFormatter.allowedUnits = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
        dcFormatter.unitsStyle = NSDateComponentsFormatterUnitsStylePositional;
        duration= [dcFormatter stringFromTimeInterval:durationSeconds];
        position= [dcFormatter stringFromTimeInterval:positionSeconds];

        itemText = [NSString stringWithFormat:@"[%@] %@ | %@\n%@",
                    [anItem valueForProperty:MPMediaItemPropertyAlbumTitle],
                    duration,position,
                    [anItem valueForProperty:MPMediaItemPropertyTitle]];
		cell.textLabel.text = itemText;  //<<<<<<<<------cell contents here
	}

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	return cell;
}

//	 To conform to the Human Interface Guidelines, selections should not be persistent --
//	 deselect the row after it has been selected.
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
    
   	MainViewController *mainViewController = (MainViewController *) self.delegate;
    MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
    MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: indexPath.row];
    NSString *itemText;
    itemText = [NSString stringWithFormat:@"[%@] %@",
                [anItem valueForProperty:MPMediaItemPropertyAlbumTitle],
                [anItem valueForProperty:MPMediaItemPropertyTitle]];
    printf("%s", [[NSString stringWithFormat:@"\n  Did Select-> Item:%@",itemText] UTF8String]);
    
// on row select, play 3 seconds of the item
    MPMusicPlayerController* musicPlayer;
    //[self setMusicPlayer: [MPMusicPlayerController iPodMusicPlayer]];
    //[self setMusicPlayer: [MPMusicPlayerController applicationMusicPlayer]];                         <<<<<< using passed in player
    //[self setMusicPlayer: [MPMusicPlayerController systemMusicPlayer]]; // LOOK was using system
    [musicPlayer setShuffleMode: MPMusicShuffleModeOff];
    [musicPlayer setRepeatMode: MPMusicRepeatModeNone];
    
    NSMutableArray* Items = [[NSMutableArray alloc] init];
    [Items addObject:anItem];
    MPMediaItemCollection* Queue = [[MPMediaItemCollection alloc ]initWithItems:Items];
    [musicPlayer setQueueWithItemCollection: Queue];
    [musicPlayer play];
    sleep(3);
    [musicPlayer stop];
}

#pragma mark Application state management____________
// Standard methods for managing application state.
- (void)didReceiveMemoryWarning {

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {

	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {

    [super dealloc];
}


@end

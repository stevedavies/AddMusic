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

    [super viewDidLoad];
	
	[self.addMusicButton setTitle: NSLocalizedString (@"AddMusicFromTableView", @"Add button shown on table view for invoking the media item picker")];
	
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];      
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

	[self presentModalViewController: picker animated: YES];
	[picker release];
}


// Responds to the user tapping Done after choosing music.
- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  
    //////////////////////
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
    MPMediaPlaylist *PartiallyPlayedList=[[MPMediaPlaylist alloc] initWithItems:PlaylistItems];
    
    NSLog(@"Number of items: %d",itemsCount);
    NSLog(@"Partially Palyed: %d", partiallyPlayedCount);
    //////////////////////
    
	[self dismissModalViewControllerAnimated: YES];
	//[self.delegate updatePlayerQueueWithMediaCollection: mediaItemCollection];
    [self.delegate updatePlayerQueueWithMediaCollection: PartiallyPlayedList];
	[self.mediaItemCollectionTable reloadData];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
}


// Responds to the user tapping done having chosen no music.
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {

	[self dismissModalViewControllerAnimated: YES];

	[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleBlackOpaque animated:YES];
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
	
		cell = [[[UITableViewCell alloc] initWithFrame: CGRectZero 
									   reuseIdentifier: kCellIdentifier] autorelease];
	}
	
	MainViewController *mainViewController = (MainViewController *) self.delegate;
	MPMediaItemCollection *currentQueue = mainViewController.userMediaItemCollection;
	MPMediaItem *anItem = (MPMediaItem *)[currentQueue.items objectAtIndex: row];
	
	if (anItem) {
		cell.textLabel.text = [anItem valueForProperty:MPMediaItemPropertyTitle];
	}

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	return cell;
}

//	 To conform to the Human Interface Guidelines, selections should not be persistent --
//	 deselect the row after it has been selected.
- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {

	[tableView deselectRowAtIndexPath: indexPath animated: YES];
}

#pragma mark Application state management_____________
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

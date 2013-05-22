#import "FirstViewController.h"
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)

@implementation FirstViewController

@synthesize theMovie;
@synthesize navBGImage;
@synthesize playerView;
@synthesize movieHolderView;
@synthesize volumeView;
@synthesize playButton;
@synthesize volumeSlider;
@synthesize viewTable;
@synthesize loader;
@synthesize currentPlayingPos;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)playButtonPressed:(UIButton*)sender{
    
}

- (void)getNowPlayingIndex{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return appDelegate.xmlAudios.count-1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:4] isEqualToString:@"1"])
		return 79.00;
    else{
        
        if (IS_IPHONE_5)
            return 63.00;
        else
            return 46.00;
		
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
	
	currentPlayingPos = indexPath;
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		CGRect frame;
		frame.origin.x = 10; 
		frame.origin.y = 5;
		
		NSArray *datetime = [[[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:2] componentsSeparatedByString:@"T"];
		NSArray *time = [[datetime objectAtIndex:1] componentsSeparatedByString:@":"];
		NSString *timeString = [NSString stringWithFormat:@"%@:%@", [time objectAtIndex:0], [time objectAtIndex:1]];
		
		frame.size.height = 20;
		frame.size.width = 60;
		
		UILabel *timeLabel = [[UILabel alloc] initWithFrame:frame];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.textColor = [UIColor whiteColor];
		timeLabel.tag = 1 + indexPath.section + indexPath.row;
		//timeLabel.text = [NSString stringWithFormat:@"%@", timeString, [[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:0]];
        timeLabel.text = [NSString stringWithFormat:@"%@", timeString];
		[cell.contentView addSubview:timeLabel];
		[timeLabel release];
		
		frame.origin.x = 70;
		frame.size.height = 20;
		frame.size.width = 240;
		
		UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
		cellLabel.backgroundColor = [UIColor clearColor];
		cellLabel.textColor = [UIColor whiteColor];
		cellLabel.tag = 2 + indexPath.section + indexPath.row;
		cellLabel.text = [NSString stringWithFormat:@"%@", [[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:0]];		
		[cell.contentView addSubview:cellLabel];
		[cellLabel release];
		
		if ([[[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:4] isEqualToString:@"1"]){
			cellLabel.font = [UIFont boldSystemFontOfSize:16];
			timeLabel.font = [UIFont boldSystemFontOfSize:16];
			
			frame.origin.y += 24;
			frame.size.height = 20;
			frame.size.width = 60;
			
			UILabel *dummyLabel = [[UILabel alloc] initWithFrame:frame];
			dummyLabel.backgroundColor = [UIColor clearColor];
			dummyLabel.textColor = [UIColor whiteColor];
			dummyLabel.text = [NSString stringWithFormat:@""];
			dummyLabel.tag = 3 + indexPath.section + indexPath.row;
			[cell.contentView addSubview:dummyLabel];
			[dummyLabel release];
			
			frame.origin.x = 70;
			frame.size.height = 20;
			frame.size.width = 240;
			
			UILabel *artistLabel = [[UILabel alloc] initWithFrame:frame];
			artistLabel.backgroundColor = [UIColor clearColor];
			artistLabel.textColor = [UIColor whiteColor];		
			artistLabel.tag = 4 + indexPath.section + indexPath.row;
			artistLabel.font = [UIFont systemFontOfSize:14.0f];
			artistLabel.text = [NSString stringWithFormat:@"%@", [appDelegate.nowPlayingAudio objectAtIndex:0]];		
			[cell.contentView addSubview:artistLabel];
			[artistLabel release];
			
			
			frame.origin.y += 22;
			frame.size.height = 20;
			frame.size.width = 60;
			
			UILabel *dummyLabel1 = [[UILabel alloc] initWithFrame:frame];
			dummyLabel1.backgroundColor = [UIColor clearColor];
			dummyLabel1.textColor = [UIColor whiteColor];
			dummyLabel1.text = [NSString stringWithFormat:@""];
			dummyLabel1.tag = 5 + indexPath.section + indexPath.row;
			[cell.contentView addSubview:dummyLabel1];
			[dummyLabel1 release];
			
			frame.origin.x = 70;
			frame.size.height = 20;
			frame.size.width = 240;
			
			UILabel *trackLabel = [[UILabel alloc] initWithFrame:frame];
			trackLabel.backgroundColor = [UIColor clearColor];
			trackLabel.textColor = [UIColor whiteColor];		
			trackLabel.tag = 6 + indexPath.section + indexPath.row;
			trackLabel.font = [UIFont systemFontOfSize:14.0f];
			trackLabel.text = [NSString stringWithFormat:@"%@", [appDelegate.nowPlayingAudio objectAtIndex:1]];	
			[cell.contentView addSubview:trackLabel];
			[trackLabel release];
			
			cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nowPlayingBG.png"]];
		}		
    }
    else {
		NSArray *datetime = [[[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:2] componentsSeparatedByString:@"T"];
		NSArray *time = [[datetime objectAtIndex:1] componentsSeparatedByString:@":"];
		NSString *timeString = [NSString stringWithFormat:@"%@:%@", [time objectAtIndex:0], [time objectAtIndex:1]];
		
		UILabel *timeLabel = [[cell viewWithTag:1 + indexPath.section + indexPath.row]mutableCopy];
		//timeLabel.text = [NSString stringWithFormat:@"%@", timeString, [[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:0]];
        timeLabel.text = [NSString stringWithFormat:@"%@", timeString];
		[cell.contentView addSubview:timeLabel];
		
		UILabel *cellLabel = [[cell viewWithTag:2 + indexPath.section + indexPath.row]mutableCopy];
		cellLabel.text = [NSString stringWithFormat:@"%@", [[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:0]];		
		[cell.contentView addSubview:cellLabel];
		
		if ([[[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:4] isEqualToString:@"1"]){
			UILabel *dummyLabel = [[cell viewWithTag:3 + indexPath.section + indexPath.row]mutableCopy];
			dummyLabel.text = [NSString stringWithFormat:@""];
			[cell.contentView addSubview:dummyLabel];
			[dummyLabel release];
			
			UILabel *artistLabel = [[cell viewWithTag:4 + indexPath.section + indexPath.row]mutableCopy];
			artistLabel.text = [NSString stringWithFormat:@"%@", [appDelegate.nowPlayingAudio objectAtIndex:0]];		
			[cell.contentView addSubview:artistLabel];
			[artistLabel release];
			
			UILabel *dummyLabel1 = [[cell viewWithTag:5 + indexPath.section + indexPath.row]mutableCopy];
			dummyLabel1.text = [NSString stringWithFormat:@""];
			[cell.contentView addSubview:dummyLabel1];
			[dummyLabel1 release];
			
			UILabel *trackLabel = [[cell viewWithTag:6 + indexPath.section + indexPath.row]mutableCopy];
			trackLabel.text = [NSString stringWithFormat:@"%@", [appDelegate.nowPlayingAudio objectAtIndex:1]];
			[cell.contentView addSubview:trackLabel];
			[trackLabel release];
			
			cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"nowPlayingBG.png"]];
		}
	}	
	
	[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}

-(void)myMovieFinishedCallback:(NSNotification*)aNotification 
{
	[self.theMovie release];
	self.theMovie = nil;
	
	audioIsPlaying = NO;
	[self setIsPlaying];
}

-(void)myMovieFinishedPreload:(NSNotification*)aNotification 
{
	[self stopLoader];
}

- (void)playbackFinished:(NSNotification*)notification {
	[self stopLoader];
	
	NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason  intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"Audio playbackFinished. Reason: Playback Ended");       
			
			audioIsPlaying = NO;
			[self setIsPlaying];
			
            break;
        case MPMovieFinishReasonPlaybackError:
			if (initIsFine == YES){
				NSLog(@"Audio playbackFinished. Reason: Playback Error BUT OKAY");	
				audioHasError = NO;
			}
			else {
				NSLog(@"Audio playbackFinished. Reason: Playback Error!!!");
				
				audioHasError = YES;
				audioIsPlaying = NO;
				
				[self.theMovie release];
				self.theMovie = nil;
				
				[self showAudioError];
				
				NSLog(@"Releasing");
			}
			
            break;
		case MPMovieFinishReasonUserExited:
            NSLog(@"Audio playbackFinished. Reason: User Exited");
			
			audioIsPlaying = NO;
			[self setIsPlaying];
						
            break;
        default:
            break;
    }
}

- (void)playbackLoaded:(NSNotification*)notification {
	[self stopLoader];
	
	if ([self.theMovie loadState] == MPMovieLoadStateUnknown)
	{
		initIsFine = NO;
		
		[[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:self.theMovie];
		
		if (audioIsPlaying == YES){
			audioHasError = YES;
			audioIsPlaying = NO;
			
			[self.theMovie release];
			self.theMovie = nil;
			
			NSLog(@"Unknown state - releasing because of error.");
		}
	}
	else{
		NSLog(@"Audio loaded. Everything okay");
		initIsFine = YES;
	}
}


- (void)playbackStateChanged:(NSNotification*)notification {
	switch (self.theMovie.playbackState) {
		case MPMoviePlaybackStateStopped:
			audioIsPlaying = NO;
			NSLog(@"stopped");
			break;
		case MPMoviePlaybackStatePlaying:
            //initIsFine = YES;
			audioIsPlaying = YES;
			NSLog(@"playing");
			break;
		case MPMoviePlaybackStatePaused:
			audioIsPlaying = NO;
			NSLog(@"paused");
			break;
		case MPMoviePlaybackStateInterrupted:
			audioIsPlaying = NO;
			NSLog(@"interrupted");
			break;
		default:
			break;
	}
	
	[self setIsPlaying];
}


-(void)buttonPressed {
		if (self.theMovie == nil)
			[self initMediaPlayer];
		
		if (audioIsPlaying == NO){		
			[self.theMovie play];
		}
		else {		
			[self.theMovie stop];
		}
		
		[self setIsPlaying];
}

- (void)showAudioError {
	UIAlertView *a = [[UIAlertView alloc] 
					  initWithTitle:@"Eingin" 
					  
					  message:@"Eingin útvarpsstroyming er tøk í løtuni. Vinaliga royn aftur seinni." 
					  delegate:nil 
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil];
	[a show];
	[a release];
}



- (void)volumeSliderMoved:(UISlider *)sender
{
}

- (void)setIsPlaying {
	if (audioIsPlaying == NO){
		[playButton setImage:playBtnBG forState:UIControlStateNormal];
	}
	else {
		[playButton setImage:pauseBtnBG forState:UIControlStateNormal];
	}	
} 



- (void)initMediaPlayer {
	[self startLoader];
	
	NSString *url = @"http://netvarp.kringvarp.fo:1935/radio/64/playlist.m3u8";
	self.theMovie = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:url]];
	[self.theMovie retain];
	
	if ([self.theMovie respondsToSelector:@selector(view)]) {
		[[self.theMovie view] setFrame: CGRectMake(0, 0, 0, 0)];
		[self.theMovie setShouldAutoplay:NO];	
		self.theMovie.view.frame = CGRectMake(0, 0, 0, 0);
		self.theMovie.view.autoresizingMask = UIViewAutoresizingNone;
		
		
		//theMovie.movieControlMode = MPMovieControlModeDefault;
		theMovie.controlStyle = MPMovieControlModeDefault;

		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.theMovie];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackLoaded:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.theMovie];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.theMovie];
		
		movieHolderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		[movieHolderView setBackgroundColor:[UIColor clearColor]];
		
		[movieHolderView addSubview:[self.theMovie view]];		
		[self.parentViewController.view addSubview:movieHolderView];
	}
	else {
		[[NSNotificationCenter defaultCenter] addObserver:self 
											  selector:@selector(myMovieFinishedCallback:) 
											  name:MPMoviePlayerPlaybackDidFinishNotification 
	  									      object:self.theMovie];
		
		/*[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(myMovieFinishedPreload:) 
													 name:MPMoviePlayerContentPreloadDidFinishNotification 
												   object:self.theMovie];*/
	}
}

- (void)viewDidLoad {
	audioIsPlaying = NO;
	audioHasError = NO;
	
	appDelegate = (WowazaTabsAppDelegate *)[[UIApplication sharedApplication] delegate];	
	
	navBGImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
        navBGImage.image = [UIImage imageNamed:@"navigationBackground.png"];
	
	[self.view addSubview:navBGImage];
	if (IS_IPHONE_5)
        viewTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 396)];
    else
        viewTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, 320, 308)];
	viewTable.delegate = self;
	viewTable.dataSource = self;
	viewTable.separatorStyle = UITableViewCellSeparatorStyleNone;
	viewTable.backgroundColor = [UIColor clearColor];
	[self.view addSubview:viewTable];
	
	playBtnBG = [[UIImage imageNamed:@"play.png"] retain];
	pauseBtnBG = [[UIImage imageNamed:@"pause.png"] retain];
	
	playButton = [UIButton buttonWithType:UIButtonTypeCustom];
	playButton.frame = CGRectMake(0, 0, 44, 44);
	[playButton setImage:playBtnBG forState:UIControlStateNormal];
	
	volumeView = [[MPVolumeView alloc] initWithFrame: CGRectMake(89, 10, 186, 44)];
	
	volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(45, 10, 230, 44)];
	volumeSlider.minimumValue = 0.0;
	volumeSlider.maximumValue = 10.0;
	volumeSlider.tag = 1010;
	volumeSlider.value = 3.5;
	volumeSlider.continuous = YES;
	if (IS_IPHONE_5)
        playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 457, 320, 42)];
    else
        playerView = [[UIView alloc] initWithFrame:CGRectMake(0, 368, 320, 42)];
	[playerView setBackgroundColor:[UIColor clearColor]];
	playerView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"slideBackground.png"]];
	
	
    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[loader setFrame:CGRectMake(12, 12, 20, 20)];
	[loader setHidden:YES];
	[playerView addSubview:loader];
	
	[playerView addSubview:playButton];
	[playerView addSubview:volumeView];
	
	[playButton addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
	[volumeSlider addTarget:self action:@selector(volumeSliderMoved:) forControlEvents:UIControlEventValueChanged];
	
	[self.view addSubview:playerView];	
	[self setIsPlaying];
	[self getNowPlayingRow];
	
	[super viewDidLoad];
    if(IS_IPHONE_5){
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background@2x.png"]]];
    }
    else
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
	[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(fireTimer:) userInfo:nil repeats:YES];
}

- (void) fireTimer:(NSTimer*)theTimer {
	WowazaTabsAppDelegate *appDelegatee = (WowazaTabsAppDelegate *)[[UIApplication sharedApplication] delegate];
	[appDelegatee updateNowPlaying];
	
	NSLog(@"reloading");
		
	[viewTable reloadData];
}

- (void)startLoader {
	[playButton setHidden:YES];
	
	[loader setHidden:NO];
	[loader startAnimating];
}

- (void)stopLoader {
	[loader setHidden:YES];
	[loader stopAnimating];
	
	[playButton setHidden:NO];
}

- (void)getNowPlayingRow {
	for (int i = 0; i < [appDelegate.xmlAudios count]; i++) {
		if ([[[appDelegate.xmlAudios objectAtIndex:i] objectAtIndex:4] isEqualToString:@"1"]){
			nowPlayingIndex = i;
			break;			
		}
	}
}


- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewWillDisappear:(BOOL)animated {
}


- (void)viewDidAppear:(BOOL)animated {
	[viewTable setContentOffset:CGPointMake(0, ((nowPlayingIndex) * 46)) animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationLandscapeRight){
		return YES;
	}
	if (interfaceOrientation == UIInterfaceOrientationPortrait){
		return YES;
	}
	
	return NO;
}

- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeLeft |
            UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortraitUpsideDown);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
	
}

- (void)viewDidUnload {
    [super viewDidUnload];

}


- (void)dealloc {
	[playButton release];
	[volumeSlider release];
	[volumeView release];
	
	[playBtnBG release];
	[pauseBtnBG release];
	
	[movieHolderView release];
	[theMovie release];
	
    [super dealloc];
}

@end

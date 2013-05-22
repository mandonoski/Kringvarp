#import "SecondView.h"
#import "WowazaTabsAppDelegate.h"
#define SYSTEM_VERSION_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation SecondView

@synthesize navBGImage;
@synthesize viewTable;
@synthesize theMovie;
@synthesize loader;
@synthesize playerView;
@synthesize volumeView;
@synthesize playButton;
@synthesize volumeSlider;
@synthesize movieHolderView;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (IBAction)playButtonPressed:(UIButton*)sender{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [appDelegate.xmlVideos count] - 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if ([[[appDelegate.xmlVideos objectAtIndex:indexPath.row] objectAtIndex:4] isEqualToString:@"1"])
		return 79.00;
	else 
		return 46.00;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = nil;
	
    if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero] autorelease];
		CGRect frame;
		frame.origin.x = 10; 
		frame.origin.y = 5;
		
		NSString *timeString = [NSString stringWithFormat:@""];
		NSString *tmpString = [[appDelegate.xmlVideos objectAtIndex:indexPath.row] objectAtIndex:2];
		if (tmpString.length > 0){
			NSArray *datetime = [[[appDelegate.xmlVideos objectAtIndex:indexPath.row] objectAtIndex:2] componentsSeparatedByString:@"T"];
			NSArray *time = [[datetime objectAtIndex:1] componentsSeparatedByString:@":"];
			timeString = [NSString stringWithFormat:@"%@:%@", [time objectAtIndex:0], [time objectAtIndex:1]];			
		}

		frame.size.height = 20;
		frame.size.width = 60;
		
		UILabel *timeLabel = [[UILabel alloc] initWithFrame:frame];
		timeLabel.backgroundColor = [UIColor clearColor];
		timeLabel.textColor = [UIColor whiteColor];
		timeLabel.tag = 1 + indexPath.section + indexPath.row;
		//timeLabel.text = [NSString stringWithFormat:@"%@", timeString, [[appDelegate.xmlVideos objectAtIndex:indexPath.row] objectAtIndex:0]];
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
		cellLabel.text = [NSString stringWithFormat:@"%@", [[appDelegate.xmlVideos objectAtIndex:indexPath.row] objectAtIndex:0]];		
		[cell.contentView addSubview:cellLabel];
		[cellLabel release];
		
		if ([[[appDelegate.xmlAudios objectAtIndex:indexPath.row] objectAtIndex:4] isEqualToString:@"1"]){
			timeLabel.font = [UIFont boldSystemFontOfSize:16];
			cellLabel.font = [UIFont boldSystemFontOfSize:16];
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
}
-(void)myMovieFinishedPreload:(NSNotification*)aNotification 
{
	[self stopLoader];
}

- (void)willEnterFullscreen:(NSNotification*)notification {
    
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
    [self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
    
    if(IS_IPHONE_5)
        [[self.navigationController view] setBounds:CGRectMake(0, 0, 320, 568)];
    else
       [[self.navigationController view] setBounds:CGRectMake(0, 0, 320, 480)];
    
    self.parentViewController.view.transform = CGAffineTransformIdentity;
    [[self.navigationController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(90))];
    
    if(IS_IPHONE_5)
       self.navigationController.view.frame = CGRectMake(0, 0, 320, 568);
    else
       self.navigationController.view.frame = CGRectMake(0, 0, 320, 480);
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")) {
        //[self.parentViewController.view setHidden:YES];
        /*[UIView beginAnimations:nil context:nil];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:appDelegate.window.rootViewController.view cache:NO];
        [UIView setAnimationDuration: 1.0];
        [UIView commitAnimations];*/
        theMovie.view.hidden = NO;
        
        
    }
    else{
        
        [[self.theMovie view] setHidden:NO];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:1.0];
        //[appDelegate.window addSubview:self.theMovie.view];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:appDelegate.window cache:YES];
        //[self.theMovie.view sendSubviewToBack:self.parentViewController.view];
        [UIView commitAnimations];
	}
     videoIsPlaying = YES;
    
	if (videoIsPlaying == YES){
		if ([self.theMovie respondsToSelector:@selector(view)]) {
            
			//[UIView beginAnimations:@"View Flip" context:nil];
			//[UIView setAnimationDuration:0.2];
			//[UIView setAnimationCurve:UIViewAnimationCurveLinear];
            //[UIView commitAnimations];
            if (UIDeviceOrientationLandscapeLeft) {
				
                [[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
				[self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
                
				if (IS_IPHONE_5)
                    [[self.parentViewController view] setBounds:CGRectMake(0, 0, 568, 320)];
                else
                    [[self.parentViewController view] setBounds:CGRectMake(0, 0, 480, 320)];
                
				self.parentViewController.view.transform = CGAffineTransformIdentity;
				[[self.parentViewController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(90))];
				
                if(IS_IPHONE_5)
                    self.theMovie.view.frame = CGRectMake(0, 0, 568, 320);
                else
                    self.theMovie.view.frame = CGRectMake(0, 0, 480, 320);
			}
        }
    
    }
}

- (void)willExitFullscreen:(NSNotification*)notification {
	if (videoIsPlaying == YES && videoHasError == NO){
        
			[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
            if(IS_IPHONE_5)
                [[self.parentViewController view] setBounds:CGRectMake(0, 0, 320, 568)];
            else
                [[self.parentViewController view] setBounds:CGRectMake(0, 0, 320, 480)];
        if (!IS_IPHONE_5)
			[[self.parentViewController view] setCenter:CGPointMake(160, 240)];
			[[self.parentViewController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
        [self.parentViewController.view setHidden:NO];
		[[self.theMovie view] setHidden:YES];
		
		videoIsPlaying = NO;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:1.0];  
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.parentViewController.view cache:YES];
		[self.parentViewController.view sendSubviewToBack:self.theMovie.view];
		
		[UIView commitAnimations];
	}
}


- (void)playbackStateChanged:(NSNotification*)notification {
	[self stopLoader];
	
	switch ([self.theMovie playbackState]) {
        case MPMoviePlaybackStateStopped:
            NSLog(@"Video playbackState. State: MPMoviePlaybackStateStopped");  
			break;
        case MPMoviePlaybackStatePlaying:
            NSLog(@"Video playbackState. State: MPMoviePlaybackStatePlaying");         
            break;
		case MPMoviePlaybackStatePaused:
            NSLog(@"Video playbackState. State: MPMoviePlaybackStatePaused");         
            break;
		case MPMoviePlaybackStateInterrupted:
            NSLog(@"Video playbackState. State: MPMoviePlaybackStateInterrupted");         
            break;
		case MPMoviePlaybackStateSeekingForward:
            NSLog(@"Video playbackState. State: MPMoviePlaybackStateSeekingForward");         
            break;
		case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"Video playbackState. State: MPMoviePlaybackStateSeekingBackward");         
            break;
        default:
            break;
    }
}



- (void)playbackLoaded:(NSNotification*)notification {
	[self stopLoader];
    
    if ([self.theMovie loadState] == MPMovieLoadStateUnknown)
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:self.theMovie];
            
        videoInitFine = NO;
            
        if (videoIsPlaying == YES){
            videoHasError = YES;
            videoIsPlaying = NO;
                
            [self.theMovie release];
            self.theMovie = nil;
            [self startLoader];
                NSLog(@"video Unknown state - release.");
            }
            else {
                [self startLoader];
                NSLog(@"video Unknown state - stop loader.");
            }
        }
        else {
            videoInitFine = YES;
            
            if ([self.theMovie respondsToSelector:@selector(view)]){		
                [self.theMovie setFullscreen:YES animated:YES];
            }
            
            [self.theMovie play];
            
            NSLog(@"Video loaded. Everything okay");
            }

}

- (void)playbackFinished:(NSNotification*)notification {
	NSNumber* reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
	
    switch ([reason intValue]) {
        case MPMovieFinishReasonPlaybackEnded:
            NSLog(@"Video playbackFinished. Reason: Playback Ended");  
			break;
        case MPMovieFinishReasonPlaybackError:
            [self.theMovie stop];
			
			if (videoInitFine == YES){
				NSLog(@"Video playbackFinished. Reason: Playback Error BUT OKAY");
			}
			else {
				NSLog(@"Video playbackFinished. Reason: Playback Error!!!");

				videoHasError = YES;
				videoIsPlaying = NO;				
				
				if (self.theMovie != nil){
					[self.theMovie release];
					self.theMovie = nil;
				}
				
				[self stopLoader];
				
				[self showVideoError];				
			}
			
            break;
		case MPMovieFinishReasonUserExited:
            NSLog(@"Video playbackFinished. Reason: User Exited");
            break;
        default:
            break;
    }
	
	[self.theMovie setFullscreen:NO animated:NO];
	[[self.theMovie view] setHidden:YES];
}

-(void)buttonPressed {
    
    
    
	[self startLoader];
    /*SecondView *sampleView = [[[SecondView alloc] init] autorelease];
    [sampleView setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:sampleView animated:YES];*/
    
    
	
	if (self.theMovie == nil){		
		NSLog(@"vlegov vo ifot");
		[self initMediaPlayer];
	}
	else {
		NSLog(@"vlegov vo elsot");
		self.theMovie = nil;
		[self initMediaPlayer];
        
	}

		
	if (videoHasError == NO && videoInitFine == YES){
		if ([self.theMovie respondsToSelector:@selector(view)]){		
			[self.theMovie setFullscreen:YES animated:NO];
            
		}
	}
}

- (void)showVideoError {
	UIAlertView *a = [[UIAlertView alloc] 
					  initWithTitle:@"Eingin" 
					  
					  message:@"Eingin sjónvarpsstroyming er tøk í løtuni. Vinaliga royn aftur seinni." 
					  delegate:nil 
					  cancelButtonTitle:@"OK"
					  otherButtonTitles:nil];
	[a show];
	[a release];
}

- (void)volumeSliderMoved:(UISlider *)sender
{
}

- (void)initMediaPlayer {
	[self startLoader];
    [super viewDidLoad];
    /*NSURL* movieURL = [NSURL URLWithString:@"http://netvarp.kringvarp.fo:1935/fo/m240/playlist.m3u8"];
    [theMovie initWithContentURL:movieURL];
    //player.view.frame = CGRectMake(0, 0, 320, 400);
    [self.view addSubview:theMovie.view];
    [theMovie play];*/

    
    
	//NSURL *movieURL = [NSURL URLWithString:@"http://netvarp.kringvarp.fo:1935/radio/64/playlist.m3u8"];
	NSURL* movieURL = [NSURL URLWithString:@"http://netvarp.kringvarp.fo:1935/fo/m240/playlist.m3u8"];
    //NSURL* movieURL = [NSURL URLWithString:@"rtmp://87.230.58.72/vod/video/VS12_5mf_kv.mp40"];
    
	self.theMovie = [[MPMoviePlayerController alloc] initWithContentURL:movieURL];
	[self.theMovie retain];
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        [self.theMovie prepareToPlay];
    }
    
	if ([self.theMovie respondsToSelector:@selector(view)]) {
		[self.theMovie setShouldAutoplay:NO];
		
		self.theMovie.scalingMode = MPMovieScalingModeAspectFit;
		self.theMovie.controlStyle = MPMovieControlStyleDefault;
		
		self.theMovie.view.frame = self.parentViewController.view.bounds;
		self.theMovie.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        theMovie.view.hidden = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterFullscreen:) name:MPMoviePlayerWillEnterFullscreenNotification object:self.theMovie];
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerDidExitFullscreenNotification object:self.theMovie];
        }
        else{
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willExitFullscreen:) name:MPMoviePlayerWillExitFullscreenNotification object:self.theMovie];
		}
        
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.theMovie];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackLoaded:) name:MPMoviePlayerLoadStateDidChangeNotification object:self.theMovie];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:self.theMovie];
		
		[[self.theMovie view] setHidden:YES];
		[self.parentViewController.view addSubview:theMovie.view];
	}
	else {
		[[NSNotificationCenter defaultCenter] addObserver:self 
											  selector:@selector(myMovieFinishedCallback:) 
											  name:MPMoviePlayerPlaybackDidFinishNotification 
											  object:self.theMovie];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
											  selector:@selector(myMovieFinishedPreload:) 
											  name:MPMoviePlayerContentPreloadDidFinishNotification 
										      object:self.theMovie];
	}
}

- (void)viewDidLoad {
	videoIsPlaying = NO;
	videoHasError = NO;
	
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
	[super viewDidLoad];
    self.parentViewController.view.autoresizesSubviews = YES;
	self.view.autoresizesSubviews = YES;
	self.view.autoresizingMask =UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didRotate:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    if(IS_IPHONE_5){
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background@2x.png"]]];
    }else
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
}

- (void)didRotate:(NSNotification *)notification {
	UIDeviceOrientation orientation = [[notification object] orientation];
	
	if (videoIsPlaying == YES){
		if ([self.theMovie respondsToSelector:@selector(view)]) {
			[UIView beginAnimations:@"View Flip" context:nil];
			[UIView setAnimationDuration:0.2];
			[UIView setAnimationCurve:UIViewAnimationCurveLinear];
			
			if (orientation == UIDeviceOrientationLandscapeRight) {
				[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeRight animated:YES];
				[self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeRight];
				
                [[self.parentViewController view] setBounds:CGRectMake(0, 0, 480, 320)];
				self.parentViewController.view.transform = CGAffineTransformIdentity;
				[[self.parentViewController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(-90))];
				
				self.theMovie.view.frame = CGRectMake(0, 0, 480, 320);
			} else if (orientation == UIDeviceOrientationLandscapeLeft) {
				[[UIApplication sharedApplication] setStatusBarOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
				[self.parentViewController shouldAutorotateToInterfaceOrientation:UIDeviceOrientationLandscapeLeft];
				
				[[self.parentViewController view] setBounds:CGRectMake(0, 0, 480, 320)];
				self.parentViewController.view.transform = CGAffineTransformIdentity;
				[[self.parentViewController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(90))];
				
				self.theMovie.view.frame = CGRectMake(0, 0, 480, 320);
			} else if (orientation == UIDeviceOrientationPortrait) {
				[[UIApplication sharedApplication] setStatusBarOrientation: UIInterfaceOrientationPortrait animated:YES];
				[self.parentViewController shouldAutorotateToInterfaceOrientation:UIInterfaceOrientationPortrait];
				
				[[self.parentViewController view] setBounds:CGRectMake(0, 0, 320, 480)];
				self.parentViewController.view.transform = CGAffineTransformIdentity;
				[[self.parentViewController view] setTransform:CGAffineTransformMakeRotation(degreesToRadian(0))];
				
				self.theMovie.view.frame = CGRectMake(0, 0, 320, 480);
			}
		
			[UIView commitAnimations];
		}
	}
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
	for (int i = 0; i < [appDelegate.xmlVideos count]; i++) {
		if ([[[appDelegate.xmlVideos objectAtIndex:i] objectAtIndex:4] isEqualToString:@"1"]){
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
	[viewTable setContentOffset:CGPointMake(0, (nowPlayingIndex * 46)) animated:NO];
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

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (void)awakeFromNib
{
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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

#import "AVFoundation/AVAudioSession.h"
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)

#import "WowazaTabsAppDelegate.h"
#import "Reachability.h"


@implementation WowazaTabsAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize splashViewImage;
@synthesize progress;
@synthesize progressLabel;

@synthesize xmlAudios, xmlVideos, nowPlayingAudio;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
  NSError *activationError = nil;
	[[AVAudioSession sharedInstance] setDelegate:self];
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
	
	
	
    if(IS_IPHONE_5){
        splashViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
        splashViewImage.image = [UIImage imageNamed:@"Default-568h@2x.png"];
    }else{
        splashViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        splashViewImage.image = [UIImage imageNamed:@"Default.png"];
    }
	[self.window addSubview:splashViewImage];
	
	progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progress.frame = CGRectMake(85, 280, 150, 20);
	[self.window addSubview:progress];
	
	progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(75, 290, 170, 20)];
	progressLabel.backgroundColor = [UIColor clearColor];
	progressLabel.textColor = [UIColor whiteColor];	
	progressLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
	[progressLabel setTextAlignment:UITextAlignmentCenter];
	[self.window addSubview:progressLabel];
	
	progressLabel.text = @"Initializing...";
	[progress setProgress:0.00];
	splashIsViewable = YES;
	
	progressLabel.text = @"Checking Internet Connection...";
	[progress setProgress:00.25];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
	
	internetReachable = [[Reachability reachabilityForInternetConnection] retain];
	[internetReachable startNotifier];
	
	hostReachable = [[Reachability reachabilityWithHostName: @"www2.kringvarp.fo"] retain];
	[hostReachable startNotifier];
	
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void) initAppStuph {
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	[self fillAppData];	
	
	if ([xmlVideos count] == 0 && [xmlAudios count] == 0){
		[progress removeFromSuperview];
		[progressLabel removeFromSuperview];
		
		[progress release];
		progress = nil;
		[progressLabel release];
		progressLabel = nil;
		
		UIAlertView *a = [[UIAlertView alloc] 
						  initWithTitle:@"Warning" 
						  message:@"No internet connection detected. Please restart the application." 
						  delegate:nil 
						  cancelButtonTitle:@"Okay"
						  otherButtonTitles:nil];
		[a show];
		[a release];
	}
	else {
		progressLabel.text = @"Rendering...";
		[progress setProgress:1.00];
		
		[self performSelector:@selector(removeSplash) withObject:nil afterDelay:1.0];
	}
}

- (void)fillAppData {
	progressLabel.text = @"Getting Data Data...";
	progress.progress = 0.75;
	
	NSString *audioPath = @"http://www2.kringvarp.fo/xml/epg.uv.xml";
	NSData *audioXmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:audioPath]];
	NSArray *audioResult = [NSArray arrayWithArray:PerformXMLXPathQuery(audioXmlData, @"//prg")];
	
	NSString *videoPath = @"http://www2.kringvarp.fo/xml/epg.sv.xml";
	NSData *videoXmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:videoPath]];
	NSArray *videoResult = [NSArray arrayWithArray:PerformXMLXPathQuery(videoXmlData, @"//prg")];
	
	self.xmlAudios = [[NSMutableArray alloc] initWithArray:[self createArrays:audioResult objects:7] copyItems:YES];
	self.xmlVideos = [[NSMutableArray alloc] initWithArray:[self createVideosArray:videoResult] copyItems:YES];
	
	self.nowPlayingAudio = [[NSMutableArray alloc] initWithCapacity:2];
	[nowPlayingAudio addObject:@""];
	[nowPlayingAudio addObject:@""];
	
	[self updateNowPlaying];
}

- (void)updateNowPlaying {
	NSString *nowPath = @"http://www2.kringvarp.fo/xml/epg.nownext.xml";
	NSData *nowXmlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:nowPath]];
	
	if (nowXmlData != nil){
		NSArray *nowResult = [NSArray arrayWithArray:PerformXMLXPathQuery(nowXmlData, @"//now")];
		
		NSArray *t = [[[NSDictionary alloc] initWithDictionary:[nowResult objectAtIndex:0]] objectForKey:@"nodeChildArray"];
		
		NSString *tmpArtist = [[t objectAtIndex:0] valueForKey:@"nodeContent"];
		NSString *npArtist = @"";
		
		if ([tmpArtist length] != 0)
			npArtist = tmpArtist;
		
		NSString *tmpTrack = [[t objectAtIndex:1] valueForKey:@"nodeContent"];
		NSString *npTrack = @"";
		if ([tmpTrack length] != 0)
			npTrack = tmpTrack;
		
		[nowPlayingAudio replaceObjectAtIndex:0 withObject:npArtist];
		[nowPlayingAudio replaceObjectAtIndex:1 withObject:npTrack];
		
	}
}


- (NSMutableArray *) createArrays:(NSArray *)dic objects:(int)objects {
	NSMutableArray *mArray = [[NSMutableArray alloc] initWithCapacity:objects];	
	
	BOOL gotNowPlaying = false;
	int restFive = 0;
	BOOL justGotNowPlaying = NO;
	
	for (int i = 0; i < [dic count]; i++){
		NSDictionary *d = [[NSDictionary alloc] initWithDictionary:[dic objectAtIndex:i]];
		NSArray *a = [d objectForKey:@"nodeChildArray"];
		
		NSMutableString *str = [NSMutableString stringWithFormat:@"%@ +0000", [[a objectAtIndex:2] valueForKey:@"nodeContent"]];
		str = [[str stringByReplacingOccurrencesOfString:@"T" withString:@" "]mutableCopy];
		//NSDate *date = [[NSDate alloc] initWithString:str];
		NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
        dateFormatter1.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        NSDate *date = [dateFormatter1 dateFromString:str];

        
		str = [NSMutableString stringWithFormat:@"%@ +0000", [[a objectAtIndex:3] valueForKey:@"nodeContent"]];
		str = [[str stringByReplacingOccurrencesOfString:@"T" withString:@" "]mutableCopy];
        //NSDate *endDate = [[NSDate alloc] initWithString:str];
		NSDateFormatter *dateFormatter2 = [[NSDateFormatter alloc] init];
        dateFormatter2.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        NSDate *endDate = [dateFormatter2 dateFromString:str];
		
		//NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
		
		
		if ([self getTodayProgram:date] == YES && gotNowPlaying == NO){
			int isObjNowPlaying = 0;
			
			if ([self compareDates:date] == NO && [self compareDates:endDate] == YES && gotNowPlaying == NO){
				gotNowPlaying = YES;
				isObjNowPlaying = 1;
				justGotNowPlaying = YES;
			}
			
			NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
			
			NSObject *v0 = [[NSObject alloc] init];
			v0 = [[a objectAtIndex:0] valueForKey:@"nodeContent"];
			
			NSObject *v1 = [[NSObject alloc] init];
			v1 = [[a objectAtIndex:1] valueForKey:@"nodeContent"];
			
			NSObject *v2 = [[NSObject alloc] init];
			v2 = [[a objectAtIndex:2] valueForKey:@"nodeContent"];
			
			NSObject *v3 = [[NSObject alloc] init];
			v3 = [[a objectAtIndex:3] valueForKey:@"nodeContent"];
			
			NSString *s0 = [[NSString alloc] init];
			NSString *s1 = [[NSString alloc] init];
			NSString *s2 = [[NSString alloc] init];
			NSString *s3 = [[NSString alloc] init];
			NSString *s4 = [[NSString alloc] init];
			
			if (v0 != NULL) s0 = [NSString stringWithFormat:@"%@", v0];				
			else s0 = @"";
			
			if (v1 != NULL) s1 = [NSString stringWithFormat:@"%@", v1];				
			else s1 = @"";
			
			if (v2 != NULL) s2 = [NSString stringWithFormat:@"%@", v2];				
			else s2 = @"";
			
			if (v3 != NULL) s3 = [NSString stringWithFormat:@"%@", v3];				
			else s3 = @"";
			
			s4 = [NSString stringWithFormat:@"%d", isObjNowPlaying];
			
			[tmp addObject:s0];
			[tmp addObject:s1];
			[tmp addObject:s2];
			[tmp addObject:s3];
			[tmp addObject:s4];
			
			[mArray addObject:tmp];
		}
		
		if (justGotNowPlaying == YES){
			justGotNowPlaying = NO;
			continue;
		}
		
		if (6 > restFive && gotNowPlaying == YES){
			NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
			
			NSObject *v0 = [[NSObject alloc] init];
			v0 = [[a objectAtIndex:0] valueForKey:@"nodeContent"];
			
			NSObject *v1 = [[NSObject alloc] init];
			v1 = [[a objectAtIndex:1] valueForKey:@"nodeContent"];
			
			NSObject *v2 = [[NSObject alloc] init];
			v2 = [[a objectAtIndex:2] valueForKey:@"nodeContent"];
			
			NSObject *v3 = [[NSObject alloc] init];
			v3 = [[a objectAtIndex:3] valueForKey:@"nodeContent"];
			
			NSString *s0 = [[NSString alloc] init];
			NSString *s1 = [[NSString alloc] init];
			NSString *s2 = [[NSString alloc] init];
			NSString *s3 = [[NSString alloc] init];
			NSString *s4 = [[NSString alloc] init];
			
			if (v0 != NULL) s0 = [NSString stringWithFormat:@"%@", v0];				
			else s0 = @"";
			
			if (v1 != NULL) s1 = [NSString stringWithFormat:@"%@", v1];				
			else s1 = @"";
			
			if (v2 != NULL) s2 = [NSString stringWithFormat:@"%@", v2];				
			else s2 = @"";
			
			if (v3 != NULL) s3 = [NSString stringWithFormat:@"%@", v3];				
			else s3 = @"";
			
			s4 = [NSString stringWithFormat:@"%d", 0];
			
			[tmp addObject:s0];
			[tmp addObject:s1];
			[tmp addObject:s2];
			[tmp addObject:s3];
			[tmp addObject:s4];
			
			[mArray addObject:tmp];
			
			restFive++;
		}
	}
	
	return mArray;
}

- (NSMutableArray *) createVideosArray:(NSArray *)dic {
	NSMutableArray *mArray = [[NSMutableArray alloc] init];	
	
	BOOL gotNowPlaying = false;
	BOOL nowPlayingInFuture = false;
	int restFive = 0;
	
	NSLog(@"tomorrow: %@", [self getTomorrow]);
	
	for (int i = 0; i < [dic count]; i++){
		NSDictionary *d = [[NSDictionary alloc] initWithDictionary:[dic objectAtIndex:i]];
		NSArray *a = [d objectForKey:@"nodeChildArray"];
		
		NSMutableString *str = [NSMutableString stringWithFormat:@"%@ +0000", [[a objectAtIndex:2] valueForKey:@"nodeContent"]];
		str = [[str stringByReplacingOccurrencesOfString:@"T" withString:@" "]mutableCopy];
		//NSDate *date = [[NSDate alloc] initWithString:str];
		NSDateFormatter *dateFormatter3 = [[NSDateFormatter alloc] init];
        dateFormatter3.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        NSDate *date = [dateFormatter3 dateFromString:str];
        
		str = [NSMutableString stringWithFormat:@"%@ +0000", [[a objectAtIndex:3] valueForKey:@"nodeContent"]];
		str = [[str stringByReplacingOccurrencesOfString:@"T" withString:@" "]mutableCopy];
		//NSDate *endDate = [[NSDate alloc] initWithString:str];
		NSDateFormatter *dateFormatter4 = [[NSDateFormatter alloc] init];
        dateFormatter4.dateFormat = @"yyyy-MM-dd HH:mm:ss Z";
        NSDate *endDate = [dateFormatter4 dateFromString:str];
		
		NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
		
		
		if (i == 0 && [self isDateGreater:date] == YES && [mArray count] == 0 && gotNowPlaying == NO){
			NSString *s0 = [[NSString alloc] initWithString:@"No Program"];
			NSString *s1 = [[NSString alloc] initWithString:@""];
			NSString *s2 = [[NSString alloc] initWithString:@""];
			NSString *s3 = [[NSString alloc] initWithString:@""];
			NSString *s4 = [[NSString alloc] initWithString:@"0"];
			
			[tmp addObject:s0];
			[tmp addObject:s1];
			[tmp addObject:s2];
			[tmp addObject:s3];
			[tmp addObject:s4];
			
			[mArray addObject:tmp];
			
			nowPlayingInFuture = true;
		}
		
		if (nowPlayingInFuture == true && 6 > restFive){
			NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
			
			NSObject *v0 = [[NSObject alloc] init];
			v0 = [[a objectAtIndex:0] valueForKey:@"nodeContent"];
			
			NSObject *v1 = [[NSObject alloc] init];
			v1 = [[a objectAtIndex:1] valueForKey:@"nodeContent"];
			
			NSObject *v2 = [[NSObject alloc] init];
			v2 = [[a objectAtIndex:2] valueForKey:@"nodeContent"];
			
			NSObject *v3 = [[NSObject alloc] init];
			v3 = [[a objectAtIndex:3] valueForKey:@"nodeContent"];
			
			NSString *s0 = [[NSString alloc] init];
			NSString *s1 = [[NSString alloc] init];
			NSString *s2 = [[NSString alloc] init];
			NSString *s3 = [[NSString alloc] init];
			NSString *s4 = [[NSString alloc] init];
			
			if (v0 != NULL) s0 = [NSString stringWithFormat:@"%@", v0];				
			else s0 = @"";
			
			if (v1 != NULL) s1 = [NSString stringWithFormat:@"%@", v1];				
			else s1 = @"";
			
			if (v2 != NULL) s2 = [NSString stringWithFormat:@"%@", v2];				
			else s2 = @"";
			
			if (v3 != NULL) s3 = [NSString stringWithFormat:@"%@", v3];				
			else s3 = @"";
			
			s4 = [NSString stringWithFormat:@"%d", 0];
			
			[tmp addObject:s0];
			[tmp addObject:s1];
			[tmp addObject:s2];
			[tmp addObject:s3];
			[tmp addObject:s4];
			
			[mArray addObject:tmp];
			
			restFive++;
		}
		
		
		if (nowPlayingInFuture == false && [self getTodayProgram:date] == YES && gotNowPlaying == NO){
			int isObjNowPlaying = 0;
			
			if ([self compareDates:date] == NO && [self compareDates:endDate] == YES && gotNowPlaying == NO){
				gotNowPlaying = YES;
				isObjNowPlaying = 1;
			}
			
			NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
			
			NSObject *v0 = [[NSObject alloc] init];
			v0 = [[a objectAtIndex:0] valueForKey:@"nodeContent"];
			
			NSObject *v1 = [[NSObject alloc] init];
			v1 = [[a objectAtIndex:1] valueForKey:@"nodeContent"];
			
			NSObject *v2 = [[NSObject alloc] init];
			v2 = [[a objectAtIndex:2] valueForKey:@"nodeContent"];
			
			NSObject *v3 = [[NSObject alloc] init];
			v3 = [[a objectAtIndex:3] valueForKey:@"nodeContent"];
			
			NSString *s0 = [[NSString alloc] init];
			NSString *s1 = [[NSString alloc] init];
			NSString *s2 = [[NSString alloc] init];
			NSString *s3 = [[NSString alloc] init];
			NSString *s4 = [[NSString alloc] init];
			
			if (v0 != NULL) s0 = [NSString stringWithFormat:@"%@", v0];				
			else s0 = @"";
			
			if (v1 != NULL) s1 = [NSString stringWithFormat:@"%@", v1];				
			else s1 = @"";
			
			if (v2 != NULL) s2 = [NSString stringWithFormat:@"%@", v2];				
			else s2 = @"";
			
			if (v3 != NULL) s3 = [NSString stringWithFormat:@"%@", v3];				
			else s3 = @"";
			
			s4 = [NSString stringWithFormat:@"%d", isObjNowPlaying];
			
			[tmp addObject:s0];
			[tmp addObject:s1];
			[tmp addObject:s2];
			[tmp addObject:s3];
			[tmp addObject:s4];
			
			[mArray addObject:tmp];
		}
		
		if (nowPlayingInFuture == false && 6 > restFive && gotNowPlaying == YES){
			NSMutableArray *tmp = [[NSMutableArray alloc] initWithCapacity:5];
			
			NSObject *v0 = [[NSObject alloc] init];
			v0 = [[a objectAtIndex:0] valueForKey:@"nodeContent"];
			
			NSObject *v1 = [[NSObject alloc] init];
			v1 = [[a objectAtIndex:1] valueForKey:@"nodeContent"];
			
			NSObject *v2 = [[NSObject alloc] init];
			v2 = [[a objectAtIndex:2] valueForKey:@"nodeContent"];
			
			NSObject *v3 = [[NSObject alloc] init];
			v3 = [[a objectAtIndex:3] valueForKey:@"nodeContent"];
			
			NSString *s0 = [[NSString alloc] init];
			NSString *s1 = [[NSString alloc] init];
			NSString *s2 = [[NSString alloc] init];
			NSString *s3 = [[NSString alloc] init];
			NSString *s4 = [[NSString alloc] init];
			
			if (v0 != NULL) s0 = [NSString stringWithFormat:@"%@", v0];				
			else s0 = @"";
			
			if (v1 != NULL) s1 = [NSString stringWithFormat:@"%@", v1];				
			else s1 = @"";
			
			if (v2 != NULL) s2 = [NSString stringWithFormat:@"%@", v2];				
			else s2 = @"";
			
			if (v3 != NULL) s3 = [NSString stringWithFormat:@"%@", v3];				
			else s3 = @"";
			
			s4 = [NSString stringWithFormat:@"%d", 0];
			
			[tmp addObject:s0];
			[tmp addObject:s1];
			[tmp addObject:s2];
			[tmp addObject:s3];
			[tmp addObject:s4];
			
			[mArray addObject:tmp];
			
			restFive++;
		}
	}
	
	return mArray;
}


- (NSString *) getCurrentDateTime {
	NSDate *currentDateTime = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
	NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
	[dateFormatter release];

	return dateInString;
}

- (NSString *) getToday {
	NSDate *currentDateTime = [NSDate date];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
	NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
	[dateFormatter release];
	
	return dateInString;
}

- (NSString *) getTomorrow {
	NSDate *currentDateTime = [NSDate date];
	
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
	NSString *dateInString = [dateFormatter stringFromDate:currentDateTime];
	[dateFormatter release];
	
	return dateInString;
}

- (BOOL) compareDates:(NSDate *) prg {
	NSString *nowStr = [self getCurrentDateTime];
	NSDate *now = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000", nowStr]];
	
	NSComparisonResult result = [now compare:prg];
	BOOL returnResult = NO;
	
	switch (result)
	{
		case NSOrderedAscending: 
			returnResult = YES;
			break;
		case NSOrderedDescending: 
			returnResult = NO;
			break;
		case NSOrderedSame: 
			returnResult = YES;
			break;
		default: 
			returnResult = NO;
			break;
	}
	
	[now release];
	now = nil;
	
	return returnResult;
}

- (BOOL) getTodayProgram:(NSDate *) prg {
	NSString *nowStr = [self getToday];
	NSDate *today = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000", nowStr]];
	
	NSComparisonResult result = [today compare:prg];
	BOOL returnResult = NO;
	
	switch (result)
	{
		case NSOrderedAscending: 
			returnResult = YES;
			break;
		case NSOrderedDescending: 
			returnResult = NO;
			break;
		case NSOrderedSame: 
			returnResult = YES;
			break;
		default: 
			returnResult = NO;
			break;
	}
	
	[today release];
	today = nil;
	
	return returnResult;
}

- (BOOL) isDateGreater:(NSDate *) prg {
	NSString *nowStr = [self getCurrentDateTime];
	NSDate *now = [[NSDate alloc] initWithString:[NSString stringWithFormat:@"%@ +0000", nowStr]];
	
	NSComparisonResult result = [now compare:prg];
	BOOL returnResult = NO;
	
	switch (result)
	{
		case NSOrderedAscending: 
			returnResult = YES;
			break;
		case NSOrderedDescending: 
			returnResult = NO;
			break;
		case NSOrderedSame: 
			returnResult = NO;
			break;
		default: 
			returnResult = NO;
			break;
	}
	
	[now release];
	now = nil;
	
	return returnResult;
}

- (void) removeSplash {
	if(splashIsViewable) {
		[splashViewImage removeFromSuperview];
		[progress removeFromSuperview];
		[progressLabel removeFromSuperview];
		
		[window addSubview:[tabBarController view]];		
		
		splashIsViewable = NO;
	
		[splashViewImage release];
		splashViewImage = nil;
		[progress release];
		progress = nil;
		[progressLabel release];
		progressLabel = nil;
		
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
		//[[UIApplication sharedApplication] setStatusBarHidden:NO animated:YES];
	}
}

- (void) checkNetworkStatus:(NSNotification *)notice
{
	NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];

	switch (internetStatus)	
	{
		case NotReachable:
		{
			internetActive = NO;			
			break;			
		}
		case ReachableViaWiFi:
		{
			internetActive = YES;			
			break;			
		}
		case ReachableViaWWAN:
		{
			internetActive = YES;			
			break;			
		}
	}
	
	NetworkStatus hostStatus = [hostReachable currentReachabilityStatus];
	switch (hostStatus)
	
	{
		case NotReachable:
		{
			hostActive = NO;			
			break;			
		}
		case ReachableViaWiFi:
		{
			hostActive = YES;			
			break;			
		}
		case ReachableViaWWAN:
		{
			hostActive = YES;			
			break;			
		}
	}
	
	if (internetActive == YES && hostActive == YES){
		progressLabel.text = @"Checking Done...";
		[self initAppStuph];
	}
	else {
		UIAlertView *a = [[UIAlertView alloc] 
						  initWithTitle:@"Warning" 
						  message:@"No internet connection detected or the Kringvarp host is unreachable. Please close the application and try again later." 
						  delegate:nil 
						  cancelButtonTitle:@"Okay"
						  otherButtonTitles:nil];
		[progress removeFromSuperview];
		[progressLabel removeFromSuperview];

		[a show];
		[a release];
	}
}

- (void)applicationWillResignActive:(UIApplication *)application {

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {
	[[AVAudioSession sharedInstance] setActive:NO error:nil];

}



- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[xmlAudios release];
	[xmlVideos release];
	
    [tabBarController release];
    [window release];
    [super dealloc];
}

@end


#import <UIKit/UIKit.h>
#import "XPathQuery.h"
@class Reachability;
@interface WowazaTabsAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {
    UIWindow *window;
    UITabBarController *tabBarController;
	UIImageView *splashViewImage;
	UIProgressView *progress; 
	UILabel *progressLabel;
	
	NSMutableArray *xmlAudios;
	NSMutableArray *xmlVideos;
	NSMutableArray *nowPlayingAudio;
	
	BOOL splashIsViewable;
	
	Reachability* internetReachable;
    Reachability* hostReachable;
	
	BOOL internetActive;
	BOOL hostActive;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIImageView *splashViewImage;
@property (nonatomic, retain) IBOutlet UIProgressView *progress;
@property (nonatomic, retain) IBOutlet UILabel *progressLabel;

@property (nonatomic, retain) NSMutableArray *xmlAudios;
@property (nonatomic, retain) NSMutableArray *xmlVideos;
@property (nonatomic, retain) NSMutableArray *nowPlayingAudio;

- (NSMutableArray *) createArrays:(NSArray *)dic objects:(int)objects;
- (NSMutableArray *) createVideosArray:(NSArray *)dic;
- (NSString *) getCurrentDateTime;
- (BOOL) compareDates:(NSDate *) prg;
- (BOOL) isDateGreater:(NSDate *) prg;
- (void) checkNetworkStatus:(NSNotification *)notice;
- (void) initAppStuph;
- (void) fillAppData;
- (void) updateNowPlaying;
//- (NSData *)loadURL:(NSURL *)url;


@end

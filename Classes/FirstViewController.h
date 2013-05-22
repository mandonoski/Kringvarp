#import <UIKit/UIKit.h>
#import "WowazaTabsAppDelegate.h"
#import "MediaPlayer/MediaPlayer.h"

@interface FirstViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UIImageView *navBGImage;
	BOOL audioIsPlaying;
	
	UIView *playerView;
	UIView *movieHolderView;
	
	IBOutlet UIButton *playButton;
	IBOutlet UISlider *volumeSlider;
	
	UIImage	*playBtnBG;
	UIImage	*pauseBtnBG;
	
	MPMoviePlayerController *theMovie;
	MPVolumeView *volumeView;
	
	IBOutlet UIActivityIndicatorView *loader;
	
	BOOL audioHasError;
	BOOL initIsFine;
	
	UITableView *viewTable;
	
	NSIndexPath *currentPlayingPos;
	
	WowazaTabsAppDelegate *appDelegate;	
	
	int nowPlayingIndex;
}

@property (nonatomic, retain) UIImageView *navBGImage;
@property (nonatomic, retain) UIView *movieHolderView;
@property (nonatomic, retain) MPMoviePlayerController *theMovie;
@property (nonatomic, retain) UIView *playerView;
@property (nonatomic, retain) MPVolumeView *volumeView;
@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UISlider *volumeSlider;
@property (nonatomic, retain) UITableView *viewTable;
@property (nonatomic, retain) UIActivityIndicatorView *loader;
@property (nonatomic, retain) NSIndexPath *currentPlayingPos;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)volumeSliderMoved:(UISlider*)sender;
- (void)setIsPlaying;
- (void)initMediaPlayer;
- (void)startLoader;
- (void)stopLoader;
- (void)showAudioError;
- (void)getNowPlayingIndex;

@end

#import <UIKit/UIKit.h>
#import "WowazaTabsAppDelegate.h"
#import "MediaPlayer/MediaPlayer.h"

@interface SecondView : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UIImageView *navBGImage;
	UITableView *viewTable;
	MPMoviePlayerController *theMovie;
	
	BOOL videoIsPlaying;
	
	UIView *playerView;
	UIView *movieHolderView;
	
	IBOutlet UIButton *playButton;
	IBOutlet UISlider *volumeSlider;
	
	UIImage	*playBtnBG;
	UIImage	*pauseBtnBG;
	
	IBOutlet UIActivityIndicatorView *loader;
	
	MPVolumeView *volumeView;
	
	int nowPlayingIndex;
	
	WowazaTabsAppDelegate *appDelegate;	
	
	BOOL videoHasError;
	BOOL videoInitFine;
    BOOL needsToFlipBack;
}

@property (nonatomic, retain) UIImageView *navBGImage;
@property (nonatomic, retain) UITableView *viewTable;
@property (nonatomic, retain) MPMoviePlayerController *theMovie;

@property (nonatomic, retain) UIView *playerView;
@property (nonatomic, retain) MPVolumeView *volumeView;
@property (nonatomic, retain) UIView *movieHolderView;

@property (nonatomic, retain) UIButton *playButton;
@property (nonatomic, retain) UISlider *volumeSlider;

@property (nonatomic, retain) UIActivityIndicatorView *loader;

- (IBAction)playButtonPressed:(UIButton*)sender;
- (IBAction)volumeSliderMoved:(UISlider*)sender;
- (void)initMediaPlayer;
- (void)startLoader;
- (void)stopLoader;
- (void)showVideoError;

@end

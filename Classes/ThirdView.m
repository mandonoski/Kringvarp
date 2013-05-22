#import "ThirdView.h"
#define IS_IPHONE_5 (fabs((double)[[UIScreen mainScreen]bounds].size.height-(double)568)<DBL_EPSILON)

@implementation ThirdView




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NO;
}


- (void)didReceiveMemoryWarning {
   [super didReceiveMemoryWarning];
    
}

-(void)viewDidLoad{
    if(IS_IPHONE_5){
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background@2x.png"]]];
    }else
        [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"Background.png"]]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


- (void)dealloc {
    [super dealloc];
}


@end

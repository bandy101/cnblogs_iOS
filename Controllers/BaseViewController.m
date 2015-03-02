//
//  BaseViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-11-12.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//



#import "BaseViewController.h"
#import "SlideFrameViewController.h"
@interface BaseViewController ()
{


}
@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if( [self.parentViewController isKindOfClass:[UINavigationController class]])
    {
        self.viewBounds=[Common resizeViewBounds:self.view.bounds withNavBarHeight:k_navigationBarHeigh];
     
    }
  

}
-(void)changeNavBarTitleColor
{
    UIColor *cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
}
/*
- (SlideFrameViewController *)sliderFrameVC
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[SlideFrameViewController class]]) {
            return (SlideFrameViewController *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}
 */
-(void)canSwitchLeftMenu:(BOOL)can
{
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"canSwitchLeftMenu" object:[NSNumber numberWithBool:can]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

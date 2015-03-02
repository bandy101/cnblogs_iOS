//
//  BaseViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-12.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#define k_navigationBarHeigh 44.0f



#import <UIKit/UIKit.h>
#import "Config.h"
#import "APPInitObject.h"
@class SlideFrameViewController;
@interface BaseViewController : UIViewController
@property(nonatomic) CGRect viewBounds;
@property(nonatomic,strong) UIViewController *leftVC;
@property(nonatomic,strong) UIViewController *rightVC;
@property (strong,nonatomic) SlideFrameViewController *sliderFrameVC;
//改版navbar的颜色
-(void)changeNavBarTitleColor;
@end


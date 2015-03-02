//
//  IndexSlideViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-12.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import "SlideSwitchView.h"
@protocol IndexSlideViewControllerDelegate;
@interface IndexSlideViewController : BaseViewController<SlideSwitchViewDelegate>
@property(nonatomic,assign) id<IndexSlideViewControllerDelegate> delegate;
//首页还是分类页
-(id)initWithIsIndex:(BOOL)isIndex;
-(void)reset;
@end

@protocol IndexSlideViewControllerDelegate <NSObject>

@optional
-(void)indexSliderViewShowCategorySort;
@end

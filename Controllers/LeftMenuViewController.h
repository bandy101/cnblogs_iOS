//
//  LeftMenuViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-10-31.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LeftMenuViewControllerDelegate;
@interface LeftMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) id<LeftMenuViewControllerDelegate> delegate;
@end

@protocol LeftMenuViewControllerDelegate <NSObject>

@optional
-(void)leftMenuChangeSelected:(int)index;
@end

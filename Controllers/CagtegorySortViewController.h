//
//  CagtegorySortViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-27.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
@protocol CagtegorySortViewControllerDelegate;
@interface CagtegorySortViewController : BaseViewController
@property(nonatomic,assign) id<CagtegorySortViewControllerDelegate> delegate;
@end

@protocol CagtegorySortViewControllerDelegate <NSObject>

@optional
-(void)categorySortGoBack:(BOOL)changed;

@end
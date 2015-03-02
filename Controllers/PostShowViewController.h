//
//  PostShowViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//
#define k_ToolBarHeight 44.0f
#import "BaseViewController.h"
#import "PostObject.h"
#import "AuthorObject.h"
@protocol PostShowViewControllerDelegate;
@interface PostShowViewController : BaseViewController<UIScrollViewDelegate,UIWebViewDelegate>
@property(nonatomic,strong) PostObject *postObj;
@property(nonatomic,weak) id<PostShowViewControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isFromAuthorHome;
-(void)startLoading;
-(void)endLoading;
-(void)reset;
@end

@protocol PostShowViewControllerDelegate <NSObject>

@optional
-(void)postShowViewControllerBack:(PostShowViewController *)postVC;
-(void)postShowViewControllerComment:(PostShowViewController *)postVC;
-(void)postShowAuthorHome:(AuthorObject *)author;
@end
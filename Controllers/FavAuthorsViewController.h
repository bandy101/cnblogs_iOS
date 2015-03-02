//
//  FavAuthorsViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-19.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
@class AuthorObject;
@protocol FavAuthorsViewControllerDelegate;
@interface FavAuthorsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign) id<FavAuthorsViewControllerDelegate> delegate;
@end
@protocol FavAuthorsViewControllerDelegate <NSObject>

@optional
-(void)showAuthorListView;
-(void)showAuthorHomeView:(AuthorObject *)author;
@end

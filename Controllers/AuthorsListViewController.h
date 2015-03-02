//
//  AuthorsListViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-20.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshFooterView.h"
@protocol AuthorListViewControllerDelegate;
@interface AuthorsListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshFooterViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign) id<AuthorListViewControllerDelegate> delegate;
@end
@protocol AuthorListViewControllerDelegate <NSObject>

@optional
-(void)authorListGoBack;

@end

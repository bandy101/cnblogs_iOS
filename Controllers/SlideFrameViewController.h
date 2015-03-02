//
//  SlideFrameViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-4.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "RESideMenu.h"
#import "LeftMenuViewController.h"
#import "IndexSlideViewController.h"
#import "ListViewController.h"
#import "PostShowViewController.h"
#import "CommentViewController.h"
#import "FavAuthorsViewController.h"
#import "AuthorsListViewController.h"
#import "AuthorHomeViewController.h"
#import "FavPostViewController.h"
#import "AboutViewController.h"
#import "CagtegorySortViewController.h"
#import "LoginViewController.h"
@interface SlideFrameViewController : UIViewController< ListViewControllerDelegate,
                                                        PostShowViewControllerDelegate,
                                                        CommentViewControllerDelegate,
                                                        RESideMenuDelegate,
                                                        LeftMenuViewControllerDelegate,
                                                        FavAuthorsViewControllerDelegate,
                                                        AuthorListViewControllerDelegate,
                                                        AuthorHomeViewControllerDelegate,
                                                        FavPostViewControllerDelegate,
                                                        IndexSlideViewControllerDelegate,
                                                        CagtegorySortViewControllerDelegate>
@property(nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

@end

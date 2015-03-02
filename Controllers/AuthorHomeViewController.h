//
//  AuthorHomeViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-25.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import "AuthorObject.h"
#import "PostObject.h"
@protocol AuthorHomeViewControllerDelegate;
@interface AuthorHomeViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) AuthorObject *authorObj;
@property(nonatomic,assign) id<AuthorHomeViewControllerDelegate>delegate;
@property(nonatomic,assign) BOOL isFromPost;
-(void)reset;
@end

@protocol AuthorHomeViewControllerDelegate <NSObject>

@optional
-(void)authorHomeGoBack;
-(void)authorHome:(AuthorHomeViewController *)authorHome selectedPostObj:(PostObject *)postObj;
@end
//
//  ListViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-10-31.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "BaseViewController.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "PostObject.h"
#import "PostListJsonHandler.h"
#import "RefreshFooterView.h"
@protocol ListViewControllerDelegate;
@interface ListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource,MJRefreshBaseViewDelegate,PostListJsonHandlerDelegate,RefreshFooterViewDelegate>
@property(nonatomic,weak) id<ListViewControllerDelegate> delegate;
-(id)initWithCagtegory:(CategoryObject *)catObj;
-(void)needRefresh;
@end

@protocol ListViewControllerDelegate <NSObject>
@optional
-(void)listViewContoller:(ListViewController *)listVCT selectedPostObject:(PostObject *)postObj;

@end



//
//  CommentViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-17.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import "RefreshFooterView.h"
#import "CommentPostViewController.h"
@class PostObject;
@protocol CommentViewControllerDelegate;
@interface CommentViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,RefreshFooterViewDelegate,CommentPostViewControllerDelegate>
@property(nonatomic,assign) id<CommentViewControllerDelegate> delegate;
@property(nonatomic,strong) PostObject *postObj;
-(void)reset;
@end

@protocol CommentViewControllerDelegate <NSObject>

@optional
-(void)commentViewControllerBack:(CommentViewController *)commVC;

@end


@interface CommentObject : NSObject
@property(nonatomic,assign) int row;
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *author;
@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *authorURL;
@property(nonatomic,strong) NSString *body;
@end
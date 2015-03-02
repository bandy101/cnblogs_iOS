//
//  FavPostViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-26.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import "PostObject.h"
@protocol FavPostViewControllerDelegate;
@interface FavPostViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign) id<FavPostViewControllerDelegate> delegate;
@end


@protocol FavPostViewControllerDelegate <NSObject>

@optional
-(void)favPostView:(FavPostViewController *)favPVC selectedPostObject:(PostObject *)postObj;
@end
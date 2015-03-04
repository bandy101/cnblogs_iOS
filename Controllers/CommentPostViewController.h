//
//  CommentPostViewController.h
//  NewsBrowser
//
//  Created by Sampson on 15/3/4.
//  Copyright (c) 2015年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import "PostObject.h"
@protocol CommentPostViewControllerDelegate;
@interface CommentPostViewController : BaseViewController
@property(nonatomic,strong) PostObject *postObj;
@property(nonatomic,assign)id<CommentPostViewControllerDelegate>delegate;

-(void)hidden:(BOOL)hide;

@end

@protocol CommentPostViewControllerDelegate <NSObject>
@optional
-(void)CommentPostViewControllerPostSuccess;
@end

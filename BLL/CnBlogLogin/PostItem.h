//
//  PostItem.h
//  NewsBrowser
//
//  Created by Sampson on 15/3/3.
//  Copyright (c) 2015年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostItem : NSObject

@property(strong,nonatomic)NSString*blogApp;
@property(strong,nonatomic)NSString*body;
@property(nonatomic)long parentCommentId;
@property(nonatomic)long postId;
@end

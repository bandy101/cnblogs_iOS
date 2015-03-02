//
//  PostListJsonHandler.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-2.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#define k_tempHTMLPATH [[NSBundle mainBundle] pathForResource:@"PostListHander" ofType:@"html"]
#import <Foundation/Foundation.h>
#import "CategoryObject.h"
@protocol PostListJsonHandlerDelegate;
@interface PostListJsonHandler : NSObject<UIWebViewDelegate>
@property(nonatomic,weak) id <PostListJsonHandlerDelegate> delegate;
-(void)handlerCategoryObject:(CategoryObject *)catObj index:(int)index;
@property(nonatomic,strong) UIWebView *web;
@property(nonatomic,strong) NSString *ID;
@end

@protocol PostListJsonHandlerDelegate <NSObject>

-(void)PostListJsonhandler:(PostListJsonHandler *)handler withResult:(NSString *)result;

@end
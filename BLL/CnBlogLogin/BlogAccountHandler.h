//
//  BlogAccountHandler.h
//  NewsBrowser
//
//  Created by Sampson on 15/3/3.
//  Copyright (c) 2015年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostItem.h"
@interface BlogAccountHandler : NSObject

+(BlogAccountHandler*)shareBlogAccountHandlerInstance;
//判断是否成功登陆
-(BOOL)IsLogin;
//获取登陆前必备数据，比如ViewState,验证码
-(void)getPreLoginNecessary:(void(^)(NSDictionary*pre))callback;
//使用用户名密码登陆
-(void)loginWith:(NSString*)username Pwd:(NSString*)pwd Validate:(NSString*)vailImg result:(void(^)(BOOL success,NSString*errorMsg,NSDictionary*loginNecessary))result;

-(void)post:(PostItem*)content callback:(void(^)(BOOL success,NSString*errormsg))result;

@end

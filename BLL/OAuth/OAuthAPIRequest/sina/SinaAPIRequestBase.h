//
//  SinaAPIRequestBase.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIRequest.h"
#import "JSON.h"
typedef enum
{
    SinaAPIType_userinfo,
    SinaAPIType_post
}SinaAPIType;

@protocol SinaAPIRequestDelegate;
@interface SinaAPIRequestBase : NSObject<APIRequestDelegate>
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *method;
@property(nonatomic,strong) NSDictionary *paramDic;
@property(nonatomic,assign) SinaAPIType type;
@property(nonatomic,assign) id<SinaAPIRequestDelegate> delegate;
-(void)startRequest;

//处理返回结果，重载
-(void)hanleResult:(NSDictionary *)dic;
@end

@protocol SinaAPIRequestDelegate <NSObject>

@optional
-(void)SinaAPIRequest:(SinaAPIRequestBase *)reqeust success:(BOOL)success result:(NSDictionary *)resultDic;
@end
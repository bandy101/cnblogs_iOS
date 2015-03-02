//
//  UserInfoAPI.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "UserInfoAPI.h"

@implementation UserInfoAPI
-(id)initWithAccessToken:(NSString *)access UID:(NSString *)uid
{
    if (self=[super init]) {
        self.url=@"https://api.weibo.com/2/users/show.json";
        self.method=@"GET";
        self.type=SinaAPIType_userinfo;
        self.paramDic=[NSDictionary dictionaryWithObjectsAndKeys:uid,@"uid",access,@"access_token", nil];
    }
    return self;
}
-(void)hanleResult:(NSDictionary *)dic
{
    
}
@end

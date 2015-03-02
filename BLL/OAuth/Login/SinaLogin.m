//
//  SinaLogin.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//
#define kAppKey @"628520973"
#define kAppSecret @"b2c7b8af0351f98592188c3a4a136f2a"
#define kAppRedirectURI @"http://www.ethan.com/author.html"
#define kAuthorizeURL @"https://api.weibo.com/oauth2/authorize"
#define KAccessTokenURL @"https://api.weibo.com/oauth2/access_token"
#import "SinaLogin.h"

@implementation SinaLogin
-(id)init
{
    if (self=[super init]) {
       
    }
    return self;
}
//初始化参数
-(void)initParam
{
    [super initParam];
    self.type=OAuthLoginType_sina;
    self.typeName=@"绑定新浪微博";
    self.authorizeUrl=kAuthorizeURL;
    self.accessTokenUrl=KAccessTokenURL;
    self.matchCodeUrl=kAppRedirectURI;
    self.authorizeParam= [NSDictionary dictionaryWithObjectsAndKeys:
                          kAppKey, @"client_id",
                          @"code", @"response_type",
                          @"111", @"state",
                          self.matchCodeUrl, @"redirect_uri",
                          @"mobile", @"display", nil];
}
//获得code之后初始请求accesstoken的参数
-(void)handleCodeWithUrl:(NSString *)url
{
    NSString *code=[self getParamValueFromUrl:url paramName:@"code"];
    if (code.length>0) {
        self.accessTokenParam= [NSDictionary dictionaryWithObjectsAndKeys:
                                kAppKey, @"client_id",
                                kAppSecret, @"client_secret",
                                @"authorization_code", @"grant_type",
                                kAppRedirectURI, @"redirect_uri",
                                code, @"code", nil];
    }

}
//获取accessToken
-(void)handleAccessTokenWithResponse:(NSString *)result
{
    //{"access_token":"2.00ixudXC0DBNXg4b45dbdafe0t1Gww","remind_in":"157679999","expires_in":157679999,"uid":"2329398510"}
    NSDictionary *dic=[result JSONValue];
    if ([[dic allKeys] containsObject:@"access_token"]) {
        self.accessToken=[dic objectForKey:@"access_token"];
        self.userID=[dic objectForKey:@"uid"];
        NSString *remind_in = [dic objectForKey:@"expires_in"];
        if (remind_in != nil)
        {
            int expVal = [remind_in intValue];
            if (expVal == 0)
            {
                self.expirationDate = [NSDate distantFuture];
            }
            else
            {
                self.expirationDate = [NSDate dateWithTimeIntervalSinceNow:expVal];
            }
        }
        [self getAccessTokenSuccess:YES];
    }
    else
    {
         [self getAccessTokenSuccess:NO];
    }

}
//获取用户名
-(void)getUserName
{
    api=[[UserInfoAPI alloc] initWithAccessToken:self.accessToken UID:self.userID];
    api.delegate=self;
    [api startRequest];
}
#pragma -
#pragma 处理结果
-(void)SinaAPIRequest:(SinaAPIRequestBase *)reqeust success:(BOOL)success result:(NSDictionary *)resultDic
{
    if (reqeust.type==SinaAPIType_userinfo&&success) {
        self.userName=[resultDic objectForKey:@"screen_name"];
        [self loginSuccess:YES];
    }
}
@end

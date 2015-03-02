//
//  OAuthLogin.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "OAuthLogin.h"
#import "SVProgressHUD.h"
#import "APIRequest.h"
@interface OAuthLogin()<APIRequestDelegate>
{
    OAuthLoginViewController *OAuthVC;
    UINavigationController *OAuthNavVC;
    
}

@end
@implementation OAuthLogin
-(id)init
{
    if (self=[super init]) {
        [self initParam];
        [self initOAuthVC];
    }
    return self;
}
//初始化授权页面
-(void)initOAuthVC
{

    NSString *url=[self serializeURL:self.authorizeUrl params:self.authorizeParam httpMethod:@"GET"];
    OAuthVC=[[OAuthLoginViewController alloc] init];
    OAuthVC.loginTitle=self.typeName;
    OAuthVC.loginURL=url;
    OAuthVC.matchURL=self.matchCodeUrl;
    OAuthVC.delegate=self;
    OAuthNavVC=[[UINavigationController alloc] initWithRootViewController:OAuthVC];
}
//显示授权页面
-(void)loginWithViewController:(UIViewController *)vc
{
    
    [vc presentViewController:OAuthNavVC animated:YES completion:^{
        [OAuthVC start];
    }];
    
}
//code 换取accesstoken
-(void)getAccessToken
{

    APIRequest *request=[[APIRequest alloc] initWithapiURL:self.accessTokenUrl
                                                       method:@"POST"
                                                       params:self.accessTokenParam
                                                     delegate:self];
    request.ID=@"AccessToken";
    [request request];
}
-(void)getAccessTokenSuccess:(BOOL)success
{
    if (success)
    {
        //如果用户名不存在则去请求用户名
        if (self.userName.length==0) {
            [self getUserName];
        }
        else
        {
            [self loginSuccess:YES];
        }
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }
}

-(void)loginSuccess:(BOOL)success
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(OAuthLogin:success:)]) {
        [self.delegate OAuthLogin:self success:YES];
    }
}
//拼接url
-(NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod
{
    NSURL* parsedURL = [NSURL URLWithString:baseURL];
    NSString* queryPrefix = parsedURL.query ? @"&" : @"?";
    
    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
        if (([[params objectForKey:key] isKindOfClass:[UIImage class]])
            ||([[params objectForKey:key] isKindOfClass:[NSData class]]))
        {
            if ([httpMethod isEqualToString:@"GET"])
            {
                NSLog(@"can not use GET to upload a file");
            }
            continue;
        }
        CFStringRef escaped_valuecf=CFURLCreateStringByAddingPercentEscapes(
                                                                            NULL, /* allocator */
                                                                            (CFStringRef)[params objectForKey:key],
                                                                            NULL, /* charactersToLeaveUnescaped */
                                                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                            kCFStringEncodingUTF8);
        
        NSString* escaped_value =[NSString stringWithFormat:@"%@",escaped_valuecf];
        CFRelease(escaped_valuecf);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
        
    }
    NSString* query = [pairs componentsJoinedByString:@"&"];
    return [NSString stringWithFormat:@"%@%@%@", baseURL, queryPrefix, query];
}
//从url中获取某个参数
-(NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName
{
    if (![paramName hasSuffix:@"="])
    {
        paramName = [NSString stringWithFormat:@"%@=", paramName];
    }
    
    NSString * str = nil;
    NSRange start = [url rangeOfString:paramName];
    if (start.location != NSNotFound)
    {
        // confirm that the parameter is not a partial name match
        unichar c = '?';
        if (start.location != 0)
        {
            c = [url characterAtIndex:start.location - 1];
        }
        if (c == '?' || c == '&' || c == '#')
        {
            NSRange end = [[url substringFromIndex:start.location+start.length] rangeOfString:@"&"];
            NSUInteger offset = start.location+start.length;
            str = end.location == NSNotFound ?
            [url substringFromIndex:offset] :
            [url substringWithRange:NSMakeRange(offset, end.location)];
            str = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        }
    }
    return str;
}
#pragma -
#pragma OAthorView delegate
-(void)OAuthLoginViewController:(OAuthLoginViewController *)vc success:(BOOL)success
{
    if (!success) {
        [SVProgressHUD showErrorWithStatus:@"取消登录"];
    }
}
-(void)OAuthLoginViewController:(OAuthLoginViewController *)vc codeUrl:(NSString *)url
{
    [self handleCodeWithUrl:url];
    if (self.accessTokenParam) {
        [self getAccessToken];
    }
    else
    {
         [SVProgressHUD showErrorWithStatus:@"授权失败"];
    }
}
#pragma APIrequet delegate
- (void)request:(APIRequest *)request didFailWithError:(NSError *)error
{

    [SVProgressHUD showErrorWithStatus:error.localizedDescription];
}
- (void)request:(APIRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    [self handleAccessTokenWithResponse:result];
}
//以下函数分平台，子类需要重载
//初始化平台信息
-(void)initParam
{
    
}
//获取code
-(void)handleCodeWithUrl:(NSString *)url
{
    
}
//获取accessToken
-(void)handleAccessTokenWithResponse:(NSString *)result
{
    
}
-(void)getUserName
{
    
}
@end

//
//  OAuthLogin.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

typedef enum
{
    OAuthLoginType_sina=1
}OAuthLoginType;

#import <Foundation/Foundation.h>
#import "OAuthLoginViewController.h"
#import "JSON.h"
@protocol OAuthLoginDelegate;
@interface OAuthLogin : NSObject<OAuthLoginViewControllerDelegate>
//登录相关信息，在子类中赋值,入参
@property(nonatomic,assign) OAuthLoginType type;
@property(nonatomic,strong) NSString *typeName;
@property(nonatomic,strong) NSString *authorizeUrl;
@property(nonatomic,strong) NSString *matchCodeUrl;
@property(nonatomic,strong) NSString *accessTokenUrl;
@property(nonatomic,assign) id<OAuthLoginDelegate> delegate;
//请求登录参数
@property(nonatomic,strong) NSDictionary *authorizeParam;
//换取accessToke参数
@property(nonatomic,strong) NSDictionary *accessTokenParam;

//获取到的AccessToken等信息
@property(nonatomic,retain) NSString *accessToken;
@property(nonatomic,retain) NSDate *expirationDate;
@property(nonatomic,strong) NSString *userID;
@property(nonatomic,strong) NSString *userName;


/*!
 *  请求用户授权
 *
 *  @param vc <#vc description#>
 */
-(void)loginWithViewController:(UIViewController *)vc;
/*!
 *  从url获取参数值
 *
 *  @param url       -http://www.ethan.com/author.html?state=111&code=38ee2ff4dcc406396edfa0f6593fc812
 *  @param paramName code
 *
 *  @return 38ee2ff4dcc406396edfa0f6593fc812
 */
-(NSString *)getParamValueFromUrl:(NSString*)url paramName:(NSString *)paramName;
//获取accesstokey是否成功
-(void)getAccessTokenSuccess:(BOOL)success;
//整个登录成功
-(void)loginSuccess:(BOOL)success;
//以下函数分平台，子类需要重载
//初始化平台信息
-(void)initParam;
//获取code 并初始化accessTokenParam
-(void)handleCodeWithUrl:(NSString *)url;
//获取accessToken
-(void)handleAccessTokenWithResponse:(NSString *)result;
-(void)getUserName;
@end

@protocol OAuthLoginDelegate <NSObject>

@optional
-(void)OAuthLogin:(OAuthLogin *)login success:(BOOL)success;
@end


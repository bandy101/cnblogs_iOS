//
//  SinaShareObject.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SinaLogin.h"
#import "SinaAPI_update.h"
@interface SinaShareObject : NSObject<OAuthLoginDelegate,SinaAPIRequestDelegate,UIActionSheetDelegate>
{
    SinaLogin *sina;
    SinaAPI_update *updateAPI;
    UIViewController *parentVC;
}
@property(nonatomic,strong) NSString *content;
//已经登录过的所有新浪用户信息
@property(nonatomic,strong) NSArray *userInfoArray;
+(SinaShareObject *)share;
-(void)shareWithContent:(NSString *)conent pVC:(UIViewController *)pvc;
@end

//
//  SinaLogin.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "OAuthLogin.h"
#import "UserInfoAPI.h"
@interface SinaLogin : OAuthLogin<SinaAPIRequestDelegate>
{
    UserInfoAPI *api;
}
@end

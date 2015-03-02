//
//  UserInfoAPI.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "SinaAPIRequestBase.h"

@interface UserInfoAPI : SinaAPIRequestBase
-(id)initWithAccessToken:(NSString *)access UID:(NSString *)uid;

@end

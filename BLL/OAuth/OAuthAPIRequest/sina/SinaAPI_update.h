//
//  SinaAPI_update.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "SinaAPIRequestBase.h"

@interface SinaAPI_update : SinaAPIRequestBase
-(id)initWithAccessToken:(NSString *)access conent:(NSString *)content;
@end

//
//  SinaAPI_update.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "SinaAPI_update.h"

@implementation SinaAPI_update
-(id)initWithAccessToken:(NSString *)access conent:(NSString *)content
{
    if (self=[super init]) {
        self.url=@"https://api.weibo.com/2/statuses/update.json";
        self.method=@"POST";
        self.type=SinaAPIType_post;
        //content=[content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.paramDic=[NSDictionary dictionaryWithObjectsAndKeys:content,@"status",access,@"access_token", nil];
    }
    return self;
}
@end

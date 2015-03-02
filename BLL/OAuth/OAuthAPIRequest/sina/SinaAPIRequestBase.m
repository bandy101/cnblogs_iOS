//
//  SinaAPIRequestBase.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "SinaAPIRequestBase.h"

@implementation SinaAPIRequestBase
-(void)startRequest
{
    APIRequest *request=[[APIRequest alloc] initWithapiURL:self.url
                                                    method:self.method
                                                    params:self.paramDic
                                                  delegate:self];
    [request request];
}
-(void)hanleResult:(NSDictionary *)dic
{
    
}
- (void)request:(APIRequest *)request didFailWithError:(NSError *)error
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(SinaAPIRequest:success:result:)]) {
        [self.delegate SinaAPIRequest:self success:NO result:nil];
    }
}
- (void)request:(APIRequest *)request didFinishLoadingWithResult:(NSString *)result
{
    NSDictionary *resultDic=[result JSONValue];
    if ([[resultDic objectForKey:@"error_code"] intValue]>0) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(SinaAPIRequest:success:result:)]) {
            [self.delegate SinaAPIRequest:self success:NO result:resultDic];
        }
    }
    else
    {
        [self hanleResult:resultDic];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(SinaAPIRequest:success:result:)]) {
            [self.delegate SinaAPIRequest:self success:YES result:resultDic];
        }
    }
}
@end

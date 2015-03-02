//
//  APIRequest.h
//  UcanOAuth
//
//  Created by Ethan on 13-1-25.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class APIRequest;


@protocol APIRequestDelegate <NSObject>
@optional
- (void)request:(APIRequest *)request didReceiveResponse:(NSURLResponse *)response;
- (void)request:(APIRequest *)request didReceiveRawData:(NSData *)data;
- (void)request:(APIRequest *)request didFailWithError:(NSError *)error;
- (void)request:(APIRequest *)request didFinishLoadingWithResult:(NSString *)result;
@end
@interface APIRequest : NSObject
{

}
@property(nonatomic,retain) NSString *apiURL;
@property(nonatomic,retain) NSString *method;
@property(nonatomic,retain) NSDictionary *params;
@property(nonatomic,assign) id<APIRequestDelegate> delegate;
@property(nonatomic,assign) BOOL isSimplePost;
@property(nonatomic,strong) NSString *ID;
-(id)initWithapiURL:(NSString *)url
             method:(NSString *)type
             params:(NSDictionary *)dic
           delegate:(id<APIRequestDelegate>)_delegate;
-(void)request;
//格式化url和参数
-(NSString *)serializeURL:(NSString *)baseURL params:(NSDictionary *)params httpMethod:(NSString *)httpMethod;
@end

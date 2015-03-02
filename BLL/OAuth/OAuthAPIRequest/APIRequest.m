//
//  APIRequest.m
//  UcanOAuth
//
//  Created by Ethan on 13-1-25.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//
#define kRequestTimeOutInterval   180.0
#define kRequestStringBoundary    @"293iosfksdfkiowjksdf31jsiuwq003s02dsaffafass3qw"
#import "APIRequest.h"
@interface APIRequest()
{
    NSURLConnection *connection;
    NSMutableData *responseData;
    
}
@end


@implementation APIRequest

-(id)initWithapiURL:(NSString *)url
             method:(NSString *)type
             params:(NSDictionary *)dic
           delegate:(id<APIRequestDelegate>)delegate;
{
    self=[super init];
    if (self) {
        self.apiURL=url;
        self.method=type;
        self.params=dic;
        self.delegate=delegate;
        self.isSimplePost=NO;
    }
    return self;
}
-(void)request
{
    NSString *urlString = [self serializeURL:self.apiURL params:self.params httpMethod:self.method];
    NSMutableURLRequest* request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                      timeoutInterval:kRequestTimeOutInterval];
    
    [request setHTTPMethod:self.method];
    NSString* contentType = [NSString
                             stringWithFormat:@"application/x-www-form-urlencoded; boundary=%@", kRequestStringBoundary];
    if ([self.method isEqualToString: @"POST"])
    {
        
        BOOL hasRawData = NO;
        [request setHTTPBody:[self postBodyHasRawData:&hasRawData]];
        
        if (hasRawData)
        {
            contentType = [NSString
                                     stringWithFormat:@"multipart/form-data; boundary=%@", kRequestStringBoundary];
        }
        [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
    
   connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
}

- (void)appendUTF8Body:(NSMutableData *)body dataString:(NSString *)dataString
{
    [body appendData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (NSMutableData *)postBodyHasRawData:(BOOL*)hasRawData
{
     NSMutableData *body = [NSMutableData data];
    if (self.isSimplePost) {
        [self appendUTF8Body:body dataString:[self serializeparams:self.params]];
        return body;
    }
    NSString *bodyPrefixString = [NSString stringWithFormat:@"--%@\r\n", kRequestStringBoundary];
    NSString *bodySuffixString = [NSString stringWithFormat:@"\r\n--%@--\r\n", kRequestStringBoundary];
    
    NSMutableDictionary *dataDictionary = [NSMutableDictionary dictionary];
    
    [self appendUTF8Body:body dataString:bodyPrefixString];
    for (id key in [self.params keyEnumerator])
    {
        [self appendUTF8Body:body dataString:bodyPrefixString];
        if (([[self.params valueForKey:key] isKindOfClass:[UIImage class]]) || ([[self.params valueForKey:key] isKindOfClass:[NSData class]]))
        {
            [dataDictionary setObject:[self.params valueForKey:key] forKey:key];
            continue;
        }
        
        [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@\r\n", key, [self.params valueForKey:key]]];
        [self appendUTF8Body:body dataString:bodyPrefixString];
    }
    
    if ([dataDictionary count] > 0)
    {
        *hasRawData = YES;
        for (id key in dataDictionary)
        {
            
            NSObject *dataParam = [dataDictionary valueForKey:key];
            
            if ([dataParam isKindOfClass:[UIImage class]])
            {
                NSData* imageData = UIImagePNGRepresentation((UIImage *)dataParam);
                [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", key,@"file"]];
                [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Type: image/png\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
                [body appendData:imageData];
            }
            else if ([dataParam isKindOfClass:[NSData class]])
            {
                [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"file\"\r\n", key]];
                [self appendUTF8Body:body dataString:[NSString stringWithFormat:@"Content-Type: content/unknown\r\nContent-Transfer-Encoding: binary\r\n\r\n"]];
                [body appendData:(NSData*)dataParam];
            }
            [self appendUTF8Body:body dataString:bodySuffixString];
        }
    }

    return body;
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

-(NSString *)serializeparams:(NSDictionary *)params
{

    NSMutableArray* pairs = [NSMutableArray array];
    for (NSString* key in [params keyEnumerator])
    {
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
    
    return [NSString stringWithFormat:@"%@", query];
}

//处理请求结果
- (void)handleResponseData:(NSData *)data
{
	NSString *response=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
    NSString *result=[NSString stringWithString:response];

    if ([self.delegate respondsToSelector:@selector(request:didFinishLoadingWithResult:)]) {
        [self.delegate request:self didFinishLoadingWithResult:result];
    }
   
}
#pragma mark - NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	responseData = [[NSMutableData alloc] init];
	
	if ([self.delegate respondsToSelector:@selector(request:didReceiveResponse:)])
    {
		[self.delegate request:self didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
				  willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
	return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
    [self handleResponseData:responseData];
	responseData = nil;
    
    [connection cancel];
	connection = nil;

}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(request:didFailWithError:)])
    {
        [self.delegate request:self didFailWithError:error];
    }

	responseData = nil;
    
    [connection cancel];
	connection = nil;

}
@end

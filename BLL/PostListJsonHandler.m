//
//  PostListJsonHandler.m
//  NewsBrowser
//  将博客园html转为可用json
//  Created by Ethan on 13-12-2.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "PostListJsonHandler.h"
#import "HTMLParser.h"
#import "AFNetworking.h"
#import "APPInitObject.h"

@implementation PostListJsonHandler
-(id)init
{
    if (self=[super init]) {
        self.web=[[UIWebView alloc] initWithFrame:CGRectZero];
        self.web.delegate=self;
   
    }
    return self;
}
-(void)handlerCategoryObject:(CategoryObject *)catObj index:(int)index
{
    NSString *url=catObj.categoryURL;
    //这里要将url设置为空
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:catObj.categoryAccept];
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc] init];
    for (int i=0; i<[catObj.categoryPostDic allKeys].count; i++) {
        NSString *key=[[catObj.categoryPostDic allKeys] objectAtIndex:i];
        id value=[catObj.categoryPostDic objectForKey:key];
        if ([value isKindOfClass:[NSString class]]&&[value isEqualToString:@"{index}"])
        {
            NSNumber *num=[NSNumber numberWithInt:index];
            [paramDic setObject:num forKey:key];
        }
        else
        {
            [paramDic setObject:[catObj.categoryPostDic objectForKey:key] forKey:key];
        }
    }
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    [httpClient postPath:url parameters:paramDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            if (responseStr.length>0) {
                NSError *error=nil;
                NSString  *webstr=[[NSString alloc] initWithContentsOfFile:k_tempHTMLPATH encoding:NSUTF8StringEncoding error:&error];
                webstr=[webstr stringByReplacingOccurrencesOfString:@"[$POSTLIST]" withString:responseStr];
                
                NSString *js=[APPInitObject share].postListHandlerJS;
                webstr=[webstr stringByReplacingOccurrencesOfString:@"[$HANDLERJS]" withString:js];
                if (webstr.length>0) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.web loadHTMLString:webstr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
                    });
                }
            }
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"post error: %@", error);
    }];
   

}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url=[request.URL absoluteString];
    url=[self decodeFromPercentEscapeString:url];
    if ([url hasPrefix:@"http://localhost/handle.aspx?data="]) {
        NSString *data=[url stringByReplacingOccurrencesOfString:@"http://localhost/handle.aspx?data=" withString:@""];
        if (self.delegate) {
            [self.delegate PostListJsonhandler:self withResult:data];
        }
        return NO;
    }
    return YES;
}

- (NSString *)decodeFromPercentEscapeString:(NSString *) string {
    CFStringRef s=CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                          (__bridge CFStringRef) string,
                                                                          CFSTR(""),
                                                                          kCFStringEncodingUTF8);
    NSString *ss=[NSString stringWithFormat:@"%@",s];
    CFRelease(s);
    return ss;
}
@end

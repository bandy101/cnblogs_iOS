//
//  BlogAccountHandler.m
//  NewsBrowser
//
//  Created by Sampson on 15/3/3.
//  Copyright (c) 2015年 Ethan. All rights reserved.
//

#import "BlogAccountHandler.h"
#import "AFNetworking.h"
#import "JSON.h"

#define LOGIN_ROOT @"http://passport.cnblogs.com"
#define LOGIN_URL @"http://passport.cnblogs.com/login.aspx"
#define HOME_URL @"http://home.cnblogs.com/"
#define POST_URL @"http://www.cnblogs.com/mvc/PostComment/Add.aspx"
@implementation BlogAccountHandler{
    AFHTTPClient*client;
    BOOL islogin;
  
}
 static NSMutableDictionary*necessaryDict;

+(BlogAccountHandler *)shareBlogAccountHandlerInstance{
    static BlogAccountHandler *shareInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareInstance = [[self alloc] init];
        necessaryDict=[[NSMutableDictionary alloc]init];
    });
    return shareInstance;
}

-(BOOL)IsLogin{
    return client!=nil&&islogin;
}

-(void)getPreLoginNecessary:(void(^)(NSDictionary*pre))callback{
    if (client==nil) {
        client=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
        [client setDefaultHeader:@"user-agent" value:@"ozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"];
    }
     [client setParameterEncoding:AFFormURLParameterEncoding];
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [client getPath:LOGIN_URL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString*content=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary*param =[self dealLoginContent:content];
        callback(param);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callback(nil);
    }];
}

-(void)loginWith:(NSString*)username Pwd:(NSString*)pwd Validate:(NSString*)vailImg result:(void(^)(BOOL success,NSString*errorMsg,NSDictionary*loginNecessary))result{
    vailImg=(vailImg==nil||vailImg.length==0)?nil:vailImg;
    [necessaryDict setValue:username forKey:@"tbUserName"];
    [necessaryDict setValue:pwd forKey:@"tbPassword"];
    [necessaryDict setValue:vailImg forKey:@"CaptchaCodeTextBox"];
    [client setParameterEncoding:AFFormURLParameterEncoding];
     [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [client postPath:LOGIN_URL parameters:necessaryDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([HOME_URL isEqualToString:operation.response.URL.absoluteString]) {
            islogin=YES;
            result(YES,nil,nil);
        }else{
            NSString*content=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary*param =[self dealLoginContent:content];
            NSString*err=[self regexGetError:content];
            result(NO,err,param);
        }
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result(NO,error.description,nil);
    }];
   
}

-(NSDictionary*)dealLoginContent:(NSString*)content{
    [necessaryDict removeAllObjects];
    NSMutableDictionary*param=[[NSMutableDictionary alloc]init];
    [necessaryDict setValue:@"" forKey:@"__EVENTTARGET"];
    [necessaryDict setValue:@"" forKey:@"__EVENTARGUMENT"];
    [necessaryDict setObject:[self regexgetValue:@"__VIEWSTATE" from:content] forKey:@"__VIEWSTATE"];
    [necessaryDict setObject:[self regexgetValue:@"__EVENTVALIDATION" from:content] forKey:@"__EVENTVALIDATION"];
    [necessaryDict setValue:@"用户名" forKey:@"tbUserName"];
    [necessaryDict setValue:@"密码" forKey:@"tbPassword"];
    
    [necessaryDict setValue:[self regexgetValue:@"LBD_VCID_c_login_logincaptcha" from:content] forKey:@"LBD_VCID_c_login_logincaptcha"];
    [necessaryDict setValue:@"1" forKey:@"LBD_BackWorkaround_c_login_logincaptcha"];
    NSString*img=[self regexGetValidateImgUrlFrom:content];
    if (img!=nil) {
        [necessaryDict setValue:@"" forKey:@"CaptchaCodeTextBox"];
        [param setValue:[NSString stringWithFormat:@"%@%@",LOGIN_ROOT,img] forKey:@"CaptchaCodeTextBox"];
    }
    
    [necessaryDict setValue:@"登  录" forKey:@"btnLogin"];
    [necessaryDict setValue:HOME_URL forKey:@"txtReturnUrl"];
    return param;
}

-(void)post:(PostItem*)content callback:(void(^)(BOOL success,NSString*errormsg))result{
    if (!self.IsLogin) {
        result(NO,@"没有登录");
    }else{
        [client setParameterEncoding:AFJSONParameterEncoding];
        //[client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        NSDictionary*per=[[NSDictionary alloc]initWithObjectsAndKeys:
                          content.blogApp,@"blogApp"
                          ,content.body,@"body"
                          ,@(content.parentCommentId),@"parentCommentId"
                          ,@(content.postId),@"postId"
                          ,nil];
        
        [client postPath:POST_URL parameters:per success:^(AFHTTPRequestOperation *operation, id responseObject) {
           // NSString*contentStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSDictionary*dic=[responseObject JSONValue];
            
            if([[dic objectForKey:@"IsSuccess"] boolValue]){
                result(YES,nil);
            }else{
                result(NO,@"评论提交失败!");
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
            result(NO,error.description);
        }];
    
    }
}


//正则获取数据,此处简化了正则要求
-(NSString*)regexgetValue:(NSString*)idStr from:(NSString*)from{
    NSError*error;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:[NSString stringWithFormat:@"id=\"%@\" value=\"(.*?)\"",idStr] options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result1 = [regex1 firstMatchInString:from options:0 range:NSMakeRange(0, [from length])];
    if (result1) {
        NSRange r1 = [result1 rangeAtIndex:1];
        NSString *tagName = [from substringWithRange:r1];
        return tagName;
    }
    return nil;
}

//获取验证码的相对地址
-(NSString*)regexGetValidateImgUrlFrom:(NSString*)content{
    NSError*error;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"\"c_login_logincaptcha_CaptchaImage\" src=\"(.*?)\"" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result1 = [regex1 firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result1) {
        NSRange r1 = [result1 rangeAtIndex:1];
        NSString *tagName = [content substringWithRange:r1];
        return tagName;
    }
    return nil;
}

-(NSString*)regexGetError:(NSString*)content{
    NSError*error;
    NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"<span id=\"Message\" class=\"ErrorMessage\" style=\"color:Red;\">(.*?)</span>" options:NSRegularExpressionCaseInsensitive error:&error];
    NSTextCheckingResult *result1 = [regex1 firstMatchInString:content options:0 range:NSMakeRange(0, [content length])];
    if (result1) {
        NSRange r1 = [result1 rangeAtIndex:1];
        NSString *tagName = [content substringWithRange:r1];
        return tagName;
    }
    return nil;
}
@end

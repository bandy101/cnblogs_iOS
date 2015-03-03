//
//  LoginViewController.m
//  NewsBrowser
//
//  Created by Ethan on 14-6-12.
//  Copyright (c) 2014年 Ethan. All rights reserved.
//

#import "LoginViewController.h"
#import "AFNetworking.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *url=@"http://passport.cnblogs.com/login.aspx";
    AFHTTPClient*httpClient=[[AFHTTPClient alloc]initWithBaseURL:[NSURL URLWithString:@""]];
    [httpClient setDefaultHeader:@"user-agent" value:@"ozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/36.0.1985.143 Safari/537.36"];
    [httpClient getPath:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *searchText = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSError *error = NULL;
        NSMutableDictionary*param=[[NSMutableDictionary alloc]init];
        [param setValue:@"" forKey:@"__EVENTTARGET"];
        [param setValue:@"" forKey:@"__EVENTARGUMENT"];
        
        NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"id=\"__VIEWSTATE\" value=\"(.*?)\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result1 = [regex1 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (result1) {
            NSRange r1 = [result1 rangeAtIndex:1];
            NSString *tagName = [searchText substringWithRange:r1];
            [param setValue:tagName forKey:@"__VIEWSTATE"];
        }
        
        NSRegularExpression *regex2 = [NSRegularExpression regularExpressionWithPattern:@"id=\"__EVENTVALIDATION\" value=\"(.*?)\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result2 = [regex2 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (result2) {
            NSRange r1 = [result2 rangeAtIndex:1];
            NSString *tagName = [searchText substringWithRange:r1];
            [param setValue:tagName forKey:@"__EVENTVALIDATION"];
        }
        
        [param setValue:@"用户名" forKey:@"tbUserName"];
        [param setValue:@"密码" forKey:@"tbPassword"];
        
        NSRegularExpression *regex3 = [NSRegularExpression regularExpressionWithPattern:@"id=\"LBD_VCID_c_login_logincaptcha\" value=\"(.*?)\"" options:NSRegularExpressionCaseInsensitive error:&error];
        NSTextCheckingResult *result3 = [regex3 firstMatchInString:searchText options:0 range:NSMakeRange(0, [searchText length])];
        if (result3) {
            NSRange r1 = [result3 rangeAtIndex:1];
            NSString *tagName = [searchText substringWithRange:r1];
            [param setValue:tagName forKey:@"LBD_VCID_c_login_logincaptcha"];
        }
        [param setValue:@"1" forKey:@"LBD_BackWorkaround_c_login_logincaptcha"];
        //图片验证码暂缓
        [param setValue:@"登  录" forKey:@"btnLogin"];
        [param setValue:@"http://home.cnblogs.com/" forKey:@"txtReturnUrl"];
  
        [httpClient postPath:url parameters:param success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString*content=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSLog(@"%@",content);
        
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

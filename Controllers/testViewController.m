//
//  testViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-4.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "testViewController.h"
#import "RefreshArcView.h"
#import <QuartzCore/QuartzCore.h>
#import "AFNetworking.h"
@interface testViewController ()
{
    
}

@end

@implementation testViewController

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
    /*
     CategoryId: 808
     CategoryType: "SiteHome"
     ItemListActionName: "PostList"
     PageIndex: 2
     ParentCategoryId: 0
     */
    NSString *url=@"http://www.cnblogs.com/mvc/AggSite/PostList.aspx";
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@""]];//这里要将url设置为空
    httpClient.parameterEncoding = AFJSONParameterEncoding;
    [httpClient setDefaultHeader:@"Accept" value:@"text/plain"];
    
    NSMutableDictionary *params=[[NSMutableDictionary alloc] init];   // 要传递的json数据是一个字典
    [params setObject:[NSNumber numberWithInt:808] forKey:@"CategoryId"];
    [params setObject:@"SiteHome" forKey:@"CategoryType"];
    [params setObject:@"PostList" forKey:@"ItemListActionName"];
    [params setObject:[NSNumber numberWithInt:2] forKey:@"PageIndex"];
    [params setObject:[NSNumber numberWithInt:0]  forKey:@"ParentCategoryId"];
    
    // httpClient 的postPath就是上文中的pathStr，即你要访问的URL地址，这里是向服务器提交一个数据请求，
    [httpClient postPath:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"data====%@",params);
        NSString *responseStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"Request Successful, response '%@'", responseStr);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"[HTTPClient Error]: %@", error);
    }];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

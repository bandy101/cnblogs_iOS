//
//  LoginViewController.m
//  NewsBrowser
//
//  Created by Ethan on 14-6-12.
//  Copyright (c) 2014年 Ethan. All rights reserved.
//

#import "LoginViewController.h"

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
    UIWebView *web=[[UIWebView alloc] initWithFrame:self.viewBounds];
    [self.view addSubview:web];
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://passport.cnblogs.com/login.aspx"]];
    [web loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

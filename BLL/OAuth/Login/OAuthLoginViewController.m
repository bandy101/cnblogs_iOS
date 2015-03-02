//
//  OAuthLoginViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "OAuthLoginViewController.h"

@interface OAuthLoginViewController ()
{
    UIWebView *webView;
    UIActivityIndicatorView *actView;
}
@end

@implementation OAuthLoginViewController

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
	webView=[[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.delegate=self;
    [self.view addSubview:webView];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:actView];
    actView.center=webView.center;
    //done
    UIBarButtonItem *done=[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeWebView)];
    self.navigationItem.rightBarButtonItem=done;
}
-(void)start
{
    self.title=self.loginTitle;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.loginURL]];
    [webView loadRequest:request];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url=[request.URL absoluteString];
    if ([url hasPrefix:self.matchURL]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(OAuthLoginViewController:codeUrl:)]) {
            [self.delegate OAuthLoginViewController:self codeUrl:url];
        }
        [self dismissModalViewControllerAnimated:YES];
        return NO;
    }
    [actView startAnimating];
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [actView stopAnimating];
}
-(void)closeWebView
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(OAuthLoginViewController:success:)]) {
        [self.delegate OAuthLoginViewController:self success:NO];
    }
    self.delegate=nil;
    [self dismissModalViewControllerAnimated:YES];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

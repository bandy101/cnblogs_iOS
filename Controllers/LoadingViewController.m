//
//  LoadingViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-11-14.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "LoadingViewController.h"
#import "Config.h"
#import "APPInitObject.h"
#import "SlideFrameViewController.h"
@interface LoadingViewController ()
{
    NSString *downURL;
    BOOL showAlert;
    NSDictionary *loadingDic;
    UIActivityIndicatorView *actView;
}
@end

@implementation LoadingViewController

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
    showAlert=NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    UIImageView *bgImgView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [bgImgView setImage:[self loadingImage]];
    [bgImgView setContentMode:UIViewContentModeBottom];
    [self.view addSubview:bgImgView];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [actView setCenter:self.view.center];
    [self.view addSubview:actView];
    [actView startAnimating];
    
    [self performSelector:@selector(initAPPSetting) withObject:self afterDelay:0.0];
    
}

- (BOOL)prefersStatusBarHidden
{
    return YES;//隐藏为YES，显示为NO
}
//读取启动图片信息
-(UIImage *)loadingImage
{
    UIImage *img=nil;
     if ([Common fileExists:k_LoadingjsonPath])
     {
        NSString *loadingStr=[Common readLocalString:k_LoadingjsonPath];
        loadingDic=[loadingStr JSONValue];
        if (loadingDic) {
            NSString *loadingImgName=[NSString stringWithFormat:@"%@.png",[loadingDic objectForKey:@"version"]];
            //NSString *loadingLink=[loadingDic objectForKey:@"link"];
            //NSString *loadingImgUrl=[loadingDic objectForKey:@"img"];
            if ([Common fileExists:[k_LoadingPath stringByAppendingFormat:@"/%@",loadingImgName]]) {
                img=[UIImage imageWithContentsOfFile:[k_LoadingPath stringByAppendingFormat:@"/%@",loadingImgName]];
                return img;
            }
        }
     }
    img=[UIImage imageNamed:k_defaultLoadingImage];
    return img;
}
-(void)presentToIndex
{
    if (showAlert) {
        return;
    }
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {

    }
    else
    {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
    SlideFrameViewController *frame=[[SlideFrameViewController alloc] init];
    [self presentViewController:frame];


}
- (void)presentViewController:(UIViewController *)aViewController
{
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.75];
    [animation setType: kCATransitionFade];
    [animation setSubtype:kCATransitionFromRight];//从上推入
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [[self.view window].layer addAnimation:animation forKey:kCATransitionFade];
    [self presentViewController:aViewController animated:NO completion:nil];
    
    
}
-(void)initFailure
{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@""
                                                  message:@"初始化数据失败"
                                                 delegate:self
                                        cancelButtonTitle:@"退出" otherButtonTitles:nil, nil];
    [alert setTag:3];
    [alert show];
}
//从网络获取最新应用信息
-(void)initAPPSetting
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:k_initUrl] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data=(NSData *)responseObject;
        [[APPInitObject share] initWithJsonString:[data JSONValue]];
        NSURLRequest *request2= [NSURLRequest requestWithURL:[NSURL URLWithString:[APPInitObject share].postListHandlerJSURL] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20.0f];
        AFHTTPRequestOperation *operation2 =[[AFHTTPRequestOperation alloc] initWithRequest:request2];
        [operation2 setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSData *data=(NSData *)responseObject;
            [APPInitObject share].postListHandlerJS=[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            [self checkAPPVersion];
            [self updateLoadingInfo];
            [self performSelector:@selector(presentToIndex) withObject:self afterDelay:0.0];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self initFailure];
        }];
        [operation2 start];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self initFailure];
    }];
    [operation start];
}
//更新启动图片
-(void)updateLoadingInfo
{
    NSString *picNameLocal=@"";
    if (loadingDic) {
        picNameLocal=[loadingDic objectForKey:@"version"];
      
    }
    if ([picNameLocal intValue]<[[APPInitObject share].loading.version intValue]) {
        //下载最新图片
        if (![Common fileExists:k_LoadingPath]) {
             NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createDirectoryAtPath:k_LoadingPath
                   withIntermediateDirectories:NO
                                    attributes:nil error:nil];
        }
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[APPInitObject share].loading.img]];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        NSString *picName=[NSString stringWithFormat:@"%@.png",[APPInitObject share].loading.version];
        operation.outputStream = [NSOutputStream outputStreamToFileAtPath:[k_LoadingPath stringByAppendingPathComponent:picName] append:NO];
        NSString *version=[APPInitObject share].loading.version;
        NSString *url=[APPInitObject share].loading.link;
        NSString *img=[APPInitObject share].loading.img;
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *loadingJson=[NSString stringWithFormat:@"{\"version\":\"%@\",\"link\":\"%@\",\"img\":\"%@\"}",version,url,img];
            [Common writeString:loadingJson toPath:k_LoadingjsonPath];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
        }];
        [operation start];
    }
}
//检查应用版本号1.1 大版本号不同强制更新 小版本号不同选择更新
-(void)checkAPPVersion
{
    NSString *versionLocalDicStr=[Common readLocalString:[[NSBundle mainBundle] pathForResource:@"version" ofType:@"txt"]];
    NSDictionary *versionLocalDic=[versionLocalDicStr JSONValue];
    NSString *versionLocal=[versionLocalDic objectForKey:@"version"];
    if ([[APPInitObject share].version.version isEqualToString:versionLocal]) {
        return;
    }
    NSArray *versionArrLocal=[versionLocal componentsSeparatedByString:@"."];
    NSArray *versionArrNet=[[APPInitObject share].version.version componentsSeparatedByString:@"."];
    if (versionArrLocal.count<1||versionArrNet.count<1) {
        return;
    }
    downURL=[NSString stringWithFormat:@"%@",[APPInitObject share].version.URL];
    //大版本号不同
    if ([[versionArrNet objectAtIndex:0] intValue] >[[versionArrLocal objectAtIndex:0] intValue]) {
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"当前版本不可用"
                                                      message:[APPInitObject share].version.note
                                                     delegate:self
                                            cancelButtonTitle:@"立即更新"
                                            otherButtonTitles:@"退出应用", nil];
        [alert setTag:1];
        [alert show];
        showAlert=YES;
        return;
    }
    if ([[versionArrNet objectAtIndex:1] intValue] >[[versionArrLocal objectAtIndex:1] intValue]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"版本更新"
                                                      message:[APPInitObject share].version.note
                                                     delegate:self
                                            cancelButtonTitle:@"立即更新"
                                            otherButtonTitles:@"稍后更新", nil];
        [alert setTag:2];
        [alert show];
        showAlert=YES;
        return;
    }

    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma alertView delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==1) {
        if (buttonIndex==1) {
            exit(0);
        }
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downURL]];
        }
    }
    if (alertView.tag==2)
    {
        if (buttonIndex==0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:downURL]];
        }
        else
        {
            showAlert=NO;
            [self presentToIndex];
        }
    }
    if (alertView.tag==3) {
        if (buttonIndex==0) {
             exit(0);
        }
    }
    
}
#pragma sideMenu delegate
- (void)sideMenu:(RESideMenu *)sideMenu didRecognizePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu willShowMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu didShowMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu willHideMenuViewController:(UIViewController *)menuViewController
{
    
}
- (void)sideMenu:(RESideMenu *)sideMenu didHideMenuViewController:(UIViewController *)menuViewController
{
    
}
@end

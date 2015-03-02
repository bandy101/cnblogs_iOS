//
//  PostShowViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-11-28.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "PostShowViewController.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "DBManager.h"
#import "SVProgressHUD.h"
#import "SinaShareObject.h"


@interface PostShowViewController ()
{
    
    UIActivityIndicatorView *actView;
    UILabel *loadingLabel;
    NSString *htmTemp;
    UIButton *commentBtn;
    UIView *loadingView;
    UIToolbar *toolBar;
    UIButton *favBtn;
    BOOL isFav;
    BOOL isFirstLoad;//解决web黑色
    
   
}
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation PostShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    isFirstLoad=YES;
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
       self.automaticallyAdjustsScrollViewInsets=NO;
    }
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //webview
    float webViewHeith= self.view.bounds.size.height-k_ToolBarHeight;
    float webViewY=0;
    if (![Common isIOS7]) {
        webViewHeith-=k_navigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_detail_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,webViewY,self.view.bounds.size.width,webViewHeith) ];
    if ([Common isIOS7]) {
        self.webView.scrollView.contentInset=UIEdgeInsetsMake(20+k_navigationBarHeigh, 0, 0, 0);
        self.webView.scrollView.scrollIndicatorInsets=UIEdgeInsetsMake(20+k_navigationBarHeigh, 0, 0, 0);
    }
    else
    {
        // remove shadow view when drag web view
        for (UIView *subView in [self.webView subviews]) {
            if ([subView isKindOfClass:[UIScrollView class]]) {
                for (UIView *shadowView in [subView subviews]) {
                    if ([shadowView isKindOfClass:[UIImageView class]]) {
                        shadowView.hidden = YES;
                    }
                }
            }
        }
    }
    [self.webView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    self.webView.delegate=self;

    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;
    
    commentBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [commentBtn addTarget:self action:@selector(showComment) forControlEvents:UIControlEventTouchUpInside];
    UIImage *btnBg=[UIImage imageNamed:@"comment_icon.png"];
    btnBg=[btnBg stretchableImageWithLeftCapWidth:10 topCapHeight:5];
    [commentBtn setBackgroundImage:btnBg forState:UIControlStateNormal];
    UIBarButtonItem *right=[[UIBarButtonItem alloc] initWithCustomView:commentBtn];
    self.navigationItem.rightBarButtonItem=right;
    
    //获取htmltemp
    htmTemp=[Common readLocalString:[[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"]];
    //toolbar
    toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, webViewHeith, self.view.bounds.size.width, k_ToolBarHeight)];
    [toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg.png"] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [toolBar setTintColor:[UIColor darkGrayColor]];
    [self.view addSubview:toolBar];
   
    

    
    //加载显示
    loadingView=[[UIView alloc] initWithFrame:self.webView.frame];
    [loadingView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center=self.webView.center;
    loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.webView.bounds.size.width, 30)];
    loadingLabel.center=CGPointMake(self.webView.center.x, self.webView.center.y+30);
    [loadingLabel setTextColor:[UIColor lightGrayColor]];
    [loadingLabel setFont:[UIFont systemFontOfSize:12]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingView addSubview:actView];
    [loadingView addSubview:loadingLabel];
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postShowViewControllerBack:)]) {
        [self.delegate postShowViewControllerBack:self];
        
    }
}
-(void)showComment
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(postShowViewControllerComment:)]) {
        [self.delegate postShowViewControllerComment:self];
        
    }
}
-(void)reset
{
    self.isFromAuthorHome=NO;
    [self.webView loadHTMLString:@"" baseURL:nil];
    [self.webView removeFromSuperview];

}
-(void)startLoading
{
    [self.view addSubview:self.webView];
    [self.view addSubview:loadingView];
    [actView startAnimating];
    [loadingLabel setText:@"正在加载..."];
    [self.view bringSubviewToFront:toolBar];
}
-(void)endLoading
{

    [actView stopAnimating];
    [loadingView removeFromSuperview];
  

}
-(void)setComment
{

    NSString *comment=[NSString stringWithFormat:@"%@ 评论 ",self.postObj.comment];
    [commentBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
    CGSize size=[comment sizeWithFont:[UIFont systemFontOfSize:12]];
    [commentBtn setFrame:CGRectMake(commentBtn.frame.origin.x, commentBtn.frame.origin.y, size.width+20, 44)];
    [commentBtn setTitle:comment forState:UIControlStateNormal];


}
-(void)setTabBarItems
{
   //是否已收藏
    isFav=[[DBManager share] postIsInFavorites:[self.postObj.ID stringValue]];
    NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
    favBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 44)];
    [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
    [favBtn addTarget:self action:@selector(handleFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *favItem=[[UIBarButtonItem alloc] initWithCustomView:favBtn];
   
    
    //分享
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"icon_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(sharePost) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    //博客
    UIButton *authorBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [authorBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [authorBtn setBackgroundImage:[UIImage imageNamed:@"icon_author.png"] forState:UIControlStateNormal];
    [authorBtn addTarget:self action:@selector(authorHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *authorItem=[[UIBarButtonItem alloc] initWithCustomView:authorBtn];
    
    
    
    //blank
    UIBarButtonItem *blank=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:authorItem,blank,shareItem,favItem, nil]];
}
//分享
-(void)sharePost
{
    NSString *content=[NSString stringWithFormat:@"%@%@",self.postObj.title,self.postObj.url];
    [[SinaShareObject share] shareWithContent:content pVC:self.parentViewController];
}
-(void)authorHome
{
    if (self.isFromAuthorHome) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(postShowViewControllerBack:)]) {
            [self.delegate postShowViewControllerBack:self];
            
        }
    }
    else
    {
        AuthorObject *authorObj=[[AuthorObject alloc] init];
        authorObj.ID=self.postObj.authorID;
        authorObj.name=self.postObj.author;
        authorObj.header=self.postObj.header;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(postShowAuthorHome:)]) {
            [self.delegate postShowAuthorHome:authorObj];
            
        }
    }
}
-(void)handleFav
{
    if (isFav) {
        if([[DBManager share] delPostFromFavorites:[self.postObj.ID stringValue]])
        {
            isFav=!isFav;
            [SVProgressHUD showSuccessWithStatus:@"取消收藏"];
            NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
            [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
        }
    }
    else
    {
        if ([[DBManager share] insertPostToFavorites:self.postObj]) {
            isFav=!isFav;
            [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            NSString *favBtnBg=isFav?@"icon_star_full.png":@"icon_star.png";
            [favBtn setBackgroundImage:[UIImage imageNamed:favBtnBg] forState:UIControlStateNormal];
        }
    }
}
-(void)setPostObj:(PostObject *)postObj
{
    
    [self startLoading];
    _postObj=postObj;
    [self setComment];
    [self setTabBarItems];
    NSString *rr=[[APPInitObject share] APIForType:APIType_body];
    NSLog(@"11-%@",rr);
    NSString *dd=[rr stringByReplacingOccurrencesOfString:@"{ID}" withString:[NSString stringWithFormat:@"%@",postObj.ID]];
    NSLog(@"22-%@",dd);
    NSString *url=[[[APPInitObject share] APIForType:APIType_body] stringByReplacingOccurrencesOfString:@"{ID}" withString:[NSString stringWithFormat:@"%@",postObj.ID]];
   NSLog(@"ur-%@",url);
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSData *data=(NSData *)responseObject;
        NSError *error=nil;
        GDataXMLDocument *xml=[[GDataXMLDocument alloc] initWithData:data error:&error];
        GDataXMLNode *node= [xml firstNodeForXPath:[[[APPInitObject share] XPathForType:APIType_body] objectForKey:@"body"] error:nil];
        NSString *html=[htmTemp stringByReplacingOccurrencesOfString:@"[$Title]" withString:_postObj.title];
        html=[html stringByReplacingOccurrencesOfString:@"[$Author]" withString:_postObj.author];
        html=[html stringByReplacingOccurrencesOfString:@"[$Time]" withString:_postObj.date];
        html=[html stringByReplacingOccurrencesOfString:@"[$Body]" withString:[node stringValue]];
        [self.webView loadHTMLString:html baseURL:nil];
        if (!isFirstLoad) {
            [self endLoading];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loadingLabel setText:@"加载失败"];
    }];
    [operation start];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma scrollview delegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([[request.URL absoluteString] hasPrefix:@"http://"]) {
        return NO;
    }
    return YES;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (isFirstLoad) {
        [self endLoading];
        isFirstLoad=NO;
    }
}

@end

//
//  CommentViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-17.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "CommentViewController.h"
#import "PostObject.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
#import "CommentCell.h"
@interface CommentViewController ()
{
    UIActivityIndicatorView *actView;
    UILabel *loadingLabel;
    UIView *loadingView;
    RefreshFooterView *_footer;
    int currentPageIndex;
    int currentPageSize;
    BOOL noMore;
    BOOL initData;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listData;
@end

@implementation CommentViewController

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

    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets=YES;
    }
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.listData=[[NSMutableArray alloc] init];
    currentPageIndex=1;
    currentPageSize=20;
    noMore=NO;
    //tableview
    float tableViewHeith= self.view.bounds.size.height;
    float tableViewY=0;
    if (![Common isIOS7]) {
        tableViewHeith-=k_navigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_detail_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,tableViewY,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [self.view addSubview:tableView];
        tableView;
    });
    _footer=[RefreshFooterView footerWithWidth:self.tableView.bounds.size.width];
    _footer.delegate=self;


    
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;
    

    //加载显示
    loadingView=[[UIView alloc] initWithFrame:self.tableView.frame];
    [loadingView setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    actView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    actView.center=self.tableView.center;
    loadingLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 30)];
    loadingLabel.center=CGPointMake(self.tableView.center.x, self.tableView.center.y+30);
    [loadingLabel setTextColor:[UIColor lightGrayColor]];
    [loadingLabel setFont:[UIFont systemFontOfSize:12]];
    [loadingLabel setTextAlignment:NSTextAlignmentCenter];
    [loadingLabel setBackgroundColor:[UIColor clearColor]];
    [loadingView addSubview:actView];
    [loadingView addSubview:loadingLabel];
    
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(commentViewControllerBack:)]) {
        [self.delegate commentViewControllerBack:self];
        
    }
}

-(void)setPostObj:(PostObject *)postObj
{
    _postObj=postObj;
    [self.tableView reloadData];
}
-(void)reset
{
    initData=NO;
    noMore=NO;
    currentPageIndex=1;
    [self.listData removeAllObjects];
    [self.tableView reloadData];
}
-(void)endLoad
{
    if(self.listData.count<currentPageSize*(currentPageIndex-1))
        noMore=YES;
    [actView stopAnimating];
    [loadingView removeFromSuperview];
    [self.tableView reloadData];
}
-(void)initData
{
    initData=YES;
 // "http://wcf.open.cnblogs.com/blog/post/{POSTID}/comments/{PAGEINDEX}/{PAGESIZE}";
    NSString *url=[[APPInitObject share] APIForType:APIType_comment];
    
    url=[url stringByReplacingOccurrencesOfString:@"{POSTID}" withString:[self.postObj.ID stringValue]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",currentPageSize]];
  
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data=(NSData *)responseObject;
            NSError *error=nil;
            NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *modifiedXMLString = [xmlString stringByReplacingOccurrencesOfString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"xmlns"] withString:@"foobar="];
            NSData *modifiedXMLData = [modifiedXMLString dataUsingEncoding:NSUTF8StringEncoding];
            
            GDataXMLDocument *xml=[[GDataXMLDocument alloc] initWithData:modifiedXMLData error:&error];
            NSArray *commNodes=[xml nodesForXPath:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"entry"] error:nil];
            int i=1;
            for (GDataXMLNode *node in commNodes) {
                CommentObject *commObj=[[CommentObject alloc] init];
                NSString *nodePath=[NSString stringWithFormat:@"%@[%d]",[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"entry"],i];
                GDataXMLNode *IDNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"id"]] error:nil];
                GDataXMLNode *dateNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"published"]] error:nil];
                GDataXMLNode *authorNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"authorname"]] error:nil];
                GDataXMLNode *authorURLNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"authorurl"]] error:nil];
                GDataXMLNode *bodyNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"content"]] error:nil];
                commObj.ID=[IDNode stringValue];
                commObj.date=[dateNode stringValue];
                commObj.author=[authorNode stringValue];
                commObj.authorURL=[authorURLNode stringValue];
                commObj.body=[self handleCommBody:[bodyNode stringValue]];
                [self.listData addObject:commObj];
                i++;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPageIndex++;
                [self endLoad];
            });

        });
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [loadingLabel setText:@"加载失败"];
    }];
    [operation start];

}
-(NSString *)handleCommBody:(NSString *)input
{
    //删除<fieldset></fieldset>
    // <img />
    NSString *strRegex=nil;
    NSError *error=nil;
    NSRegularExpression *regexExpression=nil;
    NSArray *matches =nil;
    
    NSMutableArray *matchArray=[[NSMutableArray alloc] init];
    for (NSString *reg in [[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"delhtml"])
    {
        strRegex=reg;
        regexExpression = [NSRegularExpression regularExpressionWithPattern:strRegex
                                                                                         options:NSRegularExpressionCaseInsensitive
                                                                                           error:&error];
        matches = [regexExpression matchesInString:input
                                                    options:0
                                                      range:NSMakeRange(0,input.length)];
        
        matchArray=[[NSMutableArray alloc] init];
        for (NSTextCheckingResult *match in matches)
        {
            NSRange matchRange = [match range];
            NSString *matchStr=[input substringWithRange:matchRange];
            [matchArray addObject:matchStr];
            
        }
        for (NSString *str in matchArray) {
            input=[input stringByReplacingOccurrencesOfString:str withString:@""];
        }
        [matchArray removeAllObjects];

    }
       //取<a ....>文字</a>   <b>aaaa</b>  的文字
    //strRegex=@"<a[^<]+</a>";
    strRegex=[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"replacehtml"];
    regexExpression = [NSRegularExpression regularExpressionWithPattern:strRegex
                                                                                     options:NSRegularExpressionCaseInsensitive
                                                                                       error:&error];
    matches = [regexExpression matchesInString:input
                                                options:0
                                                  range:NSMakeRange(0,input.length)];
    
    
    for (NSTextCheckingResult *match in matches)
    {
        NSRange matchRange = [match range];
        NSString *matchStr=[input substringWithRange:matchRange];
        [matchArray addObject:matchStr];
        
    }
    for (NSString *str in matchArray) {
    
        NSString *tempStr=[str substringFromIndex:[str rangeOfString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"pre"]].location+1];
        tempStr=[tempStr substringToIndex:[tempStr rangeOfString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"suf"]].location];
        input=[input stringByReplacingOccurrencesOfString:str withString:tempStr];
    }
    [matchArray removeAllObjects];
    input=[input stringByReplacingOccurrencesOfString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"br1"] withString:@"\n"];
    input=[input stringByReplacingOccurrencesOfString:[[[APPInitObject share] XPathForType:APIType_comment] objectForKey:@"br2"] withString:@"\n"];
    return input;

}
-(void)viewWillAppear:(BOOL)animated
{
    if (!initData) {
        [self.view addSubview:loadingView];
        [actView startAnimating];
        [loadingLabel setText:@"加载评论..."];
        [self initData];
    }
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma footer refresh delegate
-(void)refreshFooterBegin:(RefreshFooterView *)view
{
    //加载更多
    [self initData];

}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count) {
        return k_RefreshFooterViewHeight;
    }
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (_footer) {
        return self.listData.count+1;
    }
    return self.listData.count;
    
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count)
    {
        FooterRefreshState status;
        status=FooterRefreshStateNormal;
        if (noMore) {
            status=FooterRefreshStateDiseable;
        }
        _footer.status=status;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count) {
        //底部刷新
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footer"];
        [_footer setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [cell.contentView addSubview:_footer];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *cellIdentifier = @"Cell";
   
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }
    
    CommentObject *commObj=[self.listData objectAtIndex:indexPath.row];
    commObj.row=indexPath.row+1;
    cell.commObj=commObj;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
@implementation CommentObject



@end

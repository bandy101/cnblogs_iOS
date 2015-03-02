//
//  AuthorHomeViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-25.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AuthorHomeViewController.h"
#import "AFNetworking.h"
#import "AuthorObject.h"
#import "PostObject.h"
#import "ListViewCell.h"
#import "GDataXMLNode.h"
#import "RefreshFooterView.h"
#import "SVProgressHUD.h"
#import "DBManager.h"
@interface AuthorHomeViewController ()<RefreshFooterViewDelegate>
{
    int currentPageIndex;
    int currentPageSize;
    RefreshFooterView *_footer;
    BOOL noMore;
    UIButton *favBtn;
    BOOL isFav;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listData;
@end

@implementation AuthorHomeViewController

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
    [super viewDidLoad];
    float tableViewHeith=self.view.bounds.size.height;
    noMore=NO;
    currentPageSize=10;
    currentPageIndex=1;
    if([Common isIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets=YES;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    }
    else
    {
        tableViewHeith-=k_navigationBarHeigh;
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    self.title=@"";
    UIColor *cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.listData=[[NSMutableArray alloc] init];
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;
    
    favBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [favBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [favBtn addTarget:self action:@selector(handleFav) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fav=[[UIBarButtonItem alloc] initWithCustomView:favBtn];
    self.navigationItem.rightBarButtonItem=fav;

   
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        tableView;
    });
    _footer=[RefreshFooterView footerWithWidth:self.tableView.bounds.size.width];
    _footer.status=FooterRefreshStateNormal;
    _footer.delegate=self;
}
-(void)setAuthorObj:(AuthorObject *)authorObj
{
    
    [self.view addSubview:self.tableView];
   
    _authorObj=authorObj;
    self.title=self.authorObj.name;
    _footer.status=FooterRefreshStateNormal;
    [self initFavBtn];
    if (self.listData.count==0) {
        [self getPostList];
    }
    
    
}
-(void)handleFav
{
    if (isFav) {
        [SVProgressHUD showSuccessWithStatus:@"取消关注"];
        [[DBManager share] delAuthor:self.authorObj.ID];
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"添加关注"];
        [[DBManager share] insertAuthor:self.authorObj];
    }
    isFav=!isFav;
    NSString *favImageName=isFav?@"imageset_toolbar_fav.png":@"imageset_toolbar_fav_empty.png";
    [favBtn setBackgroundImage:[UIImage imageNamed:favImageName] forState:UIControlStateNormal];
}
-(void)initFavBtn
{
    isFav=[[DBManager share] authorIsInFavorites:self.authorObj.ID];
    NSString *favImageName=isFav?@"imageset_toolbar_fav.png":@"imageset_toolbar_fav_empty.png";
    [favBtn setBackgroundImage:[UIImage imageNamed:favImageName] forState:UIControlStateNormal];
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(authorHomeGoBack)]) {
        [self.delegate authorHomeGoBack];
    }
}
-(void)reset
{
    currentPageIndex=1;
    [self.listData removeAllObjects];
    [self.tableView removeFromSuperview];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getPostList
{
    [SVProgressHUD showWithStatus:@"数据加载..."];
    NSString *url=[[APPInitObject share] APIForType:APIType_authorhome];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",currentPageSize]];
    url=[url stringByReplacingOccurrencesOfString:@"{BLOGAPP}" withString:self.authorObj.ID];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data=(NSData *)responseObject;
            NSError *error=nil;
            NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString *modifiedXMLString = [xmlString stringByReplacingOccurrencesOfString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"xmlns"] withString:@"foobar="];
            NSData *modifiedXMLData = [modifiedXMLString dataUsingEncoding:NSUTF8StringEncoding];
            
            GDataXMLDocument *xml=[[GDataXMLDocument alloc] initWithData:modifiedXMLData error:&error];
            NSArray *commNodes=[xml nodesForXPath:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"entry"] error:nil];
            if (commNodes.count<currentPageSize) {
                noMore=YES;
            }
            int i=1;
            for (GDataXMLNode *node in commNodes) {
                PostObject *obj=[[PostObject alloc] init];
                NSString *nodePath=[NSString stringWithFormat:@"%@[%d]",[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"entry"],i];
                GDataXMLNode *titleNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"title"]] error:nil];
                GDataXMLNode *dateNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"published"]] error:nil];
                GDataXMLNode *commentsNode=[node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"comments"]] error:nil];
                GDataXMLNode *IDNode=[node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"id"]] error:nil];
                obj.title=[titleNode stringValue];
                obj.comment=[NSNumber numberWithInt:[[commentsNode stringValue] intValue]];
                obj.date=[[dateNode stringValue] substringToIndex:10];
                obj.authorID=self.authorObj.ID;
                obj.author=self.authorObj.name;
                obj.ID=[NSNumber numberWithInt:[[IDNode stringValue] intValue]];
                [self.listData addObject:obj];
                obj=nil;
                i++;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                _footer.status=FooterRefreshStateNormal;
                currentPageIndex++;
                [SVProgressHUD showSuccessWithStatus:@"加载成功"];
            });
            
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showSuccessWithStatus:@"加载失败"];
        
    }];
    [operation start];
   
}
#pragma footer refresh delegate
-(void)refreshFooterBegin:(RefreshFooterView *)view
{
    //加载更多
    if (self.listData.count==0) {
        return;
    }
    [self getPostList];
    
}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row]==self.listData.count) {
        return k_RefreshFooterViewHeight;
    }
    return k_ListViewCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (_footer&&self.listData.count>0) {
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
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        UIView *sbg=[[UIView alloc] initWithFrame:cell.frame];
        sbg.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.1];
        cell.selectedBackgroundView = sbg;
        
    }
    
    PostObject *postObj=[self.listData objectAtIndex:indexPath.row];
    cell.post=postObj;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([indexPath row]==self.listData.count)
    {
        return;
        
    }
 
    PostObject *postObj=[self.listData objectAtIndex:indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(authorHome:selectedPostObj:)])
    {
        [self.delegate authorHome:self selectedPostObj:postObj];
    }

}



@end

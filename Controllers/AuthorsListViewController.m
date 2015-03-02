//
//  AuthorsListViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-20.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AuthorsListViewController.h"
#import "AFNetworking.h"
#import "AuthorObject.h"
#import "GDataXMLNode.h"
#import "SVProgressHUD.h"
#import "AuthorListCell.h"
#import "SlideFrameViewController.h"
#import "DBManager.h"
@interface AuthorsListViewController ()
{
    UISearchDisplayController *searchDisplay;
    UISearchBar *searchBar;
    int currentPageIndex;
    int currentPageSize;
    RefreshFooterView *_footer;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listData;
@property(nonatomic,strong) NSMutableArray *searchListData;
@end

@implementation AuthorsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [SVProgressHUD dismiss];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
 
    [super viewDidLoad];
    float tableViewHeith=self.view.bounds.size.height;
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

    currentPageIndex=1;
    currentPageSize=20;
    self.listData=[[NSMutableArray alloc] init];
    self.searchListData=[[NSMutableArray alloc] init];
    self.title=@"";
    UIColor *cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    self.navigationItem.leftBarButtonItem=back;

    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [self.view addSubview:tableView];
        tableView;
    });
    _footer=[RefreshFooterView footerWithWidth:self.tableView.bounds.size.width];
    _footer.status=FooterRefreshStateNormal;
    _footer.delegate=self;
    
    searchBar = [[UISearchBar alloc] init];
    [searchBar sizeToFit];
    searchBar.placeholder=@"搜索其他博客";
    //[searchBar setBackgroundImage:[[UIImage alloc] init]];
    [searchBar setTranslucent:YES];
    searchBar.delegate = self;
    self.tableView.tableHeaderView=searchBar;
    searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplay.delegate = self;
    searchDisplay.searchResultsDataSource = self;
    searchDisplay.searchResultsDelegate = self;
    [self getlistDataFraomWeb];


}

-(void)successLoadList
{
    [SVProgressHUD showSuccessWithStatus:@"加载成功"];
    _footer.status=FooterRefreshStateNormal;
   
}

-(void)searchListWithKey:(NSString *)key
{
    [SVProgressHUD showWithStatus:@"搜索数据..."];
    key=[key stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url=[[APPInitObject share] APIForType:APIType_searchauthor];
    url=[url stringByReplacingOccurrencesOfString:@"{TERM}" withString:key];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self.searchListData removeAllObjects];
            [self changeData:responseObject toOjb:self.searchListData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self successLoadList];
                [searchDisplay.searchResultsTableView reloadData];
            });
            
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[loadingLabel setText:@"加载失败"];
        [SVProgressHUD showErrorWithStatus:@"搜索失败"];
    }];
    [operation start];
}
-(void)changeData:(id)dataobj toOjb:(NSMutableArray *)arr
{
    NSData *data=(NSData *)dataobj;
    NSError *error=nil;
    NSString *xmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *modifiedXMLString = [xmlString stringByReplacingOccurrencesOfString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"xmlns"] withString:@"foobar="];
    NSData *modifiedXMLData = [modifiedXMLString dataUsingEncoding:NSUTF8StringEncoding];
    
    GDataXMLDocument *xml=[[GDataXMLDocument alloc] initWithData:modifiedXMLData error:&error];
    NSArray *commNodes=[xml nodesForXPath:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"entry"] error:nil];
    int i=1;
    for (GDataXMLNode *node in commNodes) {
        AuthorObject *obj=[[AuthorObject alloc] init];
        NSString *nodePath=[NSString stringWithFormat:@"%@[%d]",[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"entry"],i];
        GDataXMLNode *nameNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"name"]] error:nil];
        GDataXMLNode *urlNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"url"]] error:nil];
        GDataXMLNode *headerNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"header"]] error:nil];
        GDataXMLNode *updatedNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"updated"]] error:nil];
        GDataXMLNode *IDNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"id"]] error:nil];
        GDataXMLNode *countNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authors] objectForKey:@"count"]] error:nil];
        obj.ID=[IDNode stringValue];
        obj.name=[nameNode stringValue];
        obj.header=[headerNode stringValue];
        obj.updated=[updatedNode stringValue];
        obj.count=[countNode stringValue];
        obj.url=[urlNode stringValue];
        [arr addObject:obj];
        obj=nil;
        i++;
    }
}
-(void)getlistDataFraomWeb
{
    [SVProgressHUD showWithStatus:@"加载数据..."];
    NSString *url=[[APPInitObject share] APIForType:APIType_authors];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",currentPageIndex]];
    url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",currentPageSize]];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    AFHTTPRequestOperation *operation =[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self changeData:responseObject toOjb:self.listData];
            dispatch_async(dispatch_get_main_queue(), ^{
                currentPageIndex++;
                [self successLoadList];
                [self.tableView reloadData];
            });
            
        });
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //[loadingLabel setText:@"加载失败"];
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    [operation start];

}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(authorListGoBack)]) {
        [self.delegate authorListGoBack];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma footer refresh delegate
-(void)refreshFooterBegin:(RefreshFooterView *)view
{
    //加载更多
    [self getlistDataFraomWeb];
    
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView) {
        if ([indexPath row]==self.listData.count) {
            return k_RefreshFooterViewHeight;
        }
    }

    return k_AuthorListCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    if (tableView==self.tableView)
        return self.listData.count+1;
    else
        return self.searchListData.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (tableView==self.tableView)
     {
         if ([indexPath row]==self.listData.count) {
         //底部刷新
         UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"footer"];
         [_footer setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
         [cell.contentView addSubview:_footer];
         cell.selectionStyle=UITableViewCellSelectionStyleNone;
         return cell;
         }
     }
  
    
     static NSString *cellIdentifier = @"Cell";
     
     AuthorListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
         cell = [[AuthorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
         UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
         bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
         cell.backgroundView = bg;
         cell.selectionStyle=UITableViewCellSelectionStyleGray;
         cell.accessoryView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subs_add.png"]];
     }
     
    AuthorObject *obj=nil;
     if (tableView==self.tableView)
     {
         obj=[self.listData objectAtIndex:indexPath.row];
     }
     else
     {
         obj=[self.searchListData objectAtIndex:indexPath.row];
     }
     cell.author=obj;
     return cell;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.tableView)
    {
        if ([indexPath row]==self.listData.count)
        {
            return NO;
        }
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index=indexPath.row;
    AuthorObject *obj=nil;
    if (tableView==self.tableView) {
        obj=[self.listData objectAtIndex:index];
    }
    else
    {
        obj=[self.searchListData objectAtIndex:index];
    }
    [[DBManager share] insertAuthor:obj];
    [SVProgressHUD showSuccessWithStatus:@"关注成功"];
}



#pragma search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar_
{
    [self searchListWithKey:searchBar_.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar
{
    [self.searchListData removeAllObjects];
}
@end

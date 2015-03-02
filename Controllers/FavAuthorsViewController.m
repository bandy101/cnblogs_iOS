//
//  FavAuthorsViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-19.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "FavAuthorsViewController.h"
#import "DBManager.h"
#import "AuthorsListViewController.h"
#import "AuthorListDetailCell.h"
#import "RESideMenu.h"
#import "UIViewController+RESideMenu.h"
#import "AFNetworking.h"
#import "GDataXMLNode.h"
@interface FavAuthorsViewController ()<AuthorListDetailCellDelegate>
{
    UILabel *messageLable;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listData;
@end

@implementation FavAuthorsViewController

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
    self.title=@"关注";
    UIColor *cc = [UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UIButton *rightBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 44)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"addauthor.png"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(showAuthorList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        [self.view addSubview:tableView];
        tableView;
    });
   
    
	// Do any additional setup after loading the view.
}
-(void)selectAuthors
{
    self.listData=[NSMutableArray arrayWithArray:[[DBManager share] selectAuthors]];
    if (self.listData.count==0&&messageLable==nil) {
        [self initMessageLable];
    }
    else
    {
        if (messageLable) {
            [messageLable removeFromSuperview];
        }
    }
    [self.tableView reloadData];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self selectAuthors];
    [super viewWillAppear:animated];
}
-(void)initMessageLable;
{
    messageLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    messageLable.center=CGPointMake(self.view.center.x, messageLable.center.y);
    [messageLable setTextAlignment:NSTextAlignmentCenter];
    [messageLable setText:@"点击右上角添加按钮，选择添加博客"];
    [messageLable setBackgroundColor:[UIColor clearColor]];
    [messageLable setFont:[UIFont systemFontOfSize:13]];
    [messageLable setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:messageLable];
}
-(void)showAuthorList
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showAuthorListView)]) {
        [self.delegate showAuthorListView];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return k_AuthorListDetailCell_Height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{

    return self.listData.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    
    AuthorListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[AuthorListDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.delegate=self;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    AuthorObject *obj=nil;

    cell.tag=indexPath.row;
    obj=[self.listData objectAtIndex:indexPath.row];
    cell.author=obj;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)authorListCancelFocus:(int)index
{
    AuthorObject *obj=[self.listData objectAtIndex:index];
    [[DBManager share] delAuthor:obj.ID];
    [self.listData removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:index inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AuthorObject *obj=[self.listData objectAtIndex:indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showAuthorHomeView:)]) {
        [self.delegate showAuthorHomeView:obj];
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //获取最新信息
    AuthorObject *obj=[self.listData objectAtIndex:indexPath.row];
    if (obj.lastedTitle.length==0) {
        NSString *url=[[APPInitObject share] APIForType:APIType_authorhome];
        url=[url stringByReplacingOccurrencesOfString:@"{PAGEINDEX}" withString:[NSString stringWithFormat:@"%d",1]];
        url=[url stringByReplacingOccurrencesOfString:@"{PAGESIZE}" withString:[NSString stringWithFormat:@"%d",1]];
        url=[url stringByReplacingOccurrencesOfString:@"{BLOGAPP}" withString:obj.ID];
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
                GDataXMLNode *headerNode=[xml firstNodeForXPath:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"logo"] error:nil];
                NSArray *commNodes=[xml nodesForXPath:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"entry"] error:nil];
                int i=1;
                for (GDataXMLNode *node in commNodes) {
                    NSString *nodePath=[NSString stringWithFormat:@"%@[%d]",[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"entry"],i];
                    GDataXMLNode *titleNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"title"]] error:nil];
                    GDataXMLNode *dateNode= [node firstNodeForXPath:[nodePath stringByAppendingString:[[[APPInitObject share] XPathForType:APIType_authorhome] objectForKey:@"published"]] error:nil];
                    obj.lastedTitle=[titleNode stringValue];
                    obj.updated=[dateNode stringValue];
                    obj.header=[headerNode stringValue];
                    i++;
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
            });
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
   
        }];
        [operation start];
    }
}
@end

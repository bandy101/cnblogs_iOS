//
//  FavPostViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-26.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "FavPostViewController.h"
#import "ListViewCell.h"
#import "DBManager.h"
@interface FavPostViewController ()
{
    UILabel *messageLable;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *listData;
@end

@implementation FavPostViewController

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
    self.title=@"收藏";
    [self changeNavBarTitleColor];
      
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width,tableViewHeith) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        tableView.allowsSelectionDuringEditing = YES;
        [self.view addSubview:tableView];
        tableView;
    });
}

-(void)selectFavPosts
{
    self.listData=[NSMutableArray arrayWithArray:[[DBManager share] selectPostFavs]];
    if (self.listData.count==0) {
        [self initMessageLable];
    }
    else
    {
        [messageLable removeFromSuperview];
    }
    [self.tableView reloadData];
}
-(void)initMessageLable;
{
    messageLable=[[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 100)];
    messageLable.center=CGPointMake(self.view.center.x, messageLable.center.y);
    [messageLable setTextAlignment:NSTextAlignmentCenter];
    [messageLable setText:@"没有收藏文章"];
    [messageLable setBackgroundColor:[UIColor clearColor]];
    [messageLable setFont:[UIFont systemFontOfSize:13]];
    [messageLable setTextColor:[UIColor darkGrayColor]];
    [self.view addSubview:messageLable];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self selectFavPosts];
    
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return k_ListViewCell_Height;
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
    ListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[ListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [Common translateHexStringToColor:@"#f0f0f0"];
        cell.backgroundView = bg;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
        
    }
    
    PostObject *postObj=[self.listData objectAtIndex:indexPath.row];
    cell.post=postObj;
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    PostObject *postObj=[self.listData objectAtIndex:indexPath.row];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(favPostView:selectedPostObject:)])
    {
        [self.delegate favPostView:self selectedPostObject:postObj];
    }

}

@end

//
//  ListViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-10-31.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "ListViewController.h"
#import "ListViewCell.h"
#import "SlideSwitchView.h"
#import "PostShowViewController.h"


@interface ListViewController ()
{
    MJRefreshHeaderView *_header;
    RefreshFooterView *_footer;
    CategoryObject *currentCategory;
    int currentPageIndex;
    int currentPageSize;
    PostListJsonHandler *listHandler;
    BOOL noMore;
    NSMutableArray *readPostIDArr;
}
@property(nonatomic) int index;
@property(nonatomic,strong) UITableView *listTableView;
@property(nonatomic,strong) NSMutableArray *listData;
@end

@implementation ListViewController
-(id)initWithCagtegory:(CategoryObject *)catObj
{
    if (self=[super init]) {
  
        _listData=[[NSMutableArray alloc] init];
        currentCategory=catObj;
        currentPageIndex=1;
        currentPageSize=20;
        listHandler=[[PostListJsonHandler alloc] init];
        readPostIDArr=[[NSMutableArray alloc] init];
        listHandler.delegate=self;
        noMore=NO;
    }
    return  self;
}
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
    [self.view setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
    CGRect rect;
    if ([Common isIOS7])
    {
        rect=self.view.bounds;
    }
    else
    {
        rect=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-k_navigationBarHeigh-kHeightOfTopScrollView);
    }
    //读取历史
    NSString *path=[k_DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/cach_%d.txt",currentCategory.categoryID]];
    NSString *history=[Common readLocalString:path];
    if (history.length>0) {
        self.listData=[NSMutableArray arrayWithArray:[PostObject initArrayWithJson:[history JSONValue]]];
    }
    
    
    self.listTableView=[[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    [self.listTableView setBackgroundColor:[UIColor clearColor]];
    self.listTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    self.listTableView.delegate=self;
    self.listTableView.dataSource=self;
    
    [self.view addSubview:self.listTableView];
    if ([Common isIOS7])
    {
        self.listTableView.contentInset=UIEdgeInsetsMake(20+k_navigationBarHeigh+kHeightOfTopScrollView, 0, 0, 0);
        self.listTableView.scrollIndicatorInsets=UIEdgeInsetsMake(20+k_navigationBarHeigh+kHeightOfTopScrollView, 0, 0, 0);
    }
    // 集成下拉刷新控件
    _header = [MJRefreshHeaderView header];
    _header.refreshID=[NSString stringWithFormat:@"list_header_%d",currentCategory.categoryID];
    _header.headerAddToBack=YES; //添加到表格后面
    if ([Common isIOS7])
    {
        _header.scrollViewInsetTop=20+k_navigationBarHeigh+kHeightOfTopScrollView;
    }
    else
    {
        _header.scrollViewInsetTop=0;
    }
    
    _header.scrollView =self.listTableView;
    _header.delegate = self;
    
    
    //集成上拉加载更多控件
    _footer=[RefreshFooterView footerWithWidth:self.listTableView.bounds.size.width];
    _footer.delegate=self;
    //第一次进入刷新
    if (self.listData.count<1) {
        //[_header beginRefreshing];
    }
    
}
-(void)needRefresh
{
    //如果超过1个小时没刷新，自动刷新
    if (_header.lastUpdateTime) {
        NSDate *date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate *currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        NSTimeInterval time=[currentDate timeIntervalSinceDate:_header.lastUpdateTime];
        if (time>60*60) {
            [_header beginRefreshing];
        }
    }
    else
    {
         [_header beginRefreshing];
    }
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma -
#pragma private method

#pragma mark - 刷新的代理方法---进入下拉刷新\上拉加载更多都有可能调用这个方法
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    
    
    
    if (refreshView == _header) {
        // 下拉刷新
        listHandler.ID=@"refresh";
        [listHandler handlerCategoryObject:currentCategory index:1];
       
    }
    
    
}
-(void)refreshFooterBegin:(RefreshFooterView *)view
{
    //加载更多
    listHandler.ID=@"more";
    [listHandler handlerCategoryObject:currentCategory index:currentPageIndex+1];
  
}

- (void)reloadTableView
{
    [self.listTableView reloadData];
    // 结束刷新状态
    [_header endRefreshing];
    _footer.status=FooterRefreshStateNormal;
    
}
#pragma 获取数据代理
-(void)PostListJsonhandler:(PostListJsonHandler *)handler withResult:(NSString *)result
{
    
    NSArray *resultArr=[result JSONValue];
    if (!resultArr) {
        return;
    }
    if ([handler.ID isEqualToString:@"refresh"]) {
        NSString *path=[k_DocumentsPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/cach_%d.txt",currentCategory.categoryID]];
        [Common writeString:result toPath:path];
        self.listData=[NSMutableArray arrayWithArray:[PostObject initArrayWithJson:resultArr]];
        currentPageIndex=1;
        [self reloadTableView];
        
    }
    if ([handler.ID isEqualToString:@"more"]) {
        NSArray *arr=[PostObject initArrayWithJson:resultArr];
        if (arr.count==0) {
            noMore=YES;
        }
        [self.listData addObjectsFromArray:arr];
        currentPageIndex++;
        [self reloadTableView];
        
    }
    
}
#pragma mark -
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
        status=self.listData.count>100?FooterRefreshStateNormal:FooterRefreshStateRefreshing;
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
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }

    PostObject *postObj=[self.listData objectAtIndex:indexPath.row];
    if(currentCategory.categoryID==-1&&postObj.header.length==0)
    {
        postObj.header=[[[NSBundle mainBundle] URLForResource:@"userheader@2x" withExtension:@"png"] absoluteString];
    }
    if ([readPostIDArr containsObject:postObj.ID]) {
        postObj.isReaded=YES;
    }
    else
    {
        postObj.isReaded=NO;
    }
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
    if (self.delegate&&[self.delegate respondsToSelector:@selector(listViewContoller:selectedPostObject:)])
    {
        [self.delegate listViewContoller:self selectedPostObject:postObj];
    }
    [readPostIDArr addObject:postObj.ID];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
}


@end

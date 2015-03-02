//
//  CagtegorySortViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-27.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "CagtegorySortViewController.h"
#import "DropSortMenuView.h"
#import "APPInitObject.h"
#import "JSON.h"
@interface CagtegorySortViewController ()
{
    
    UILabel *lable;
    NSArray *oldShowCategorys;
    BOOL showCategorysChanged;
}
@property(nonatomic,strong)DropSortMenuView *sortMenuView;
@property(nonatomic,strong)DropSortMenuView *hideMenuView;
@end

@implementation CagtegorySortViewController

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
    if([Common isIOS7])
    {
        self.automaticallyAdjustsScrollViewInsets=NO;
        [self.navigationController.navigationBar setBarTintColor:[Common translateHexStringToColor:k_NavBarBGColor]];
    }
    else
    {
     
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bg.png"] forBarMetrics:UIBarMetricsDefault];
    }
    //navbar
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setFrame:CGRectMake(0, 0, 54, 44)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"icon_back_w.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back=[[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=back;

    
    self.title=@"编辑分类";
    [self changeNavBarTitleColor];
    [self.view setBackgroundColor:[Common translateHexStringToColor:@"#f5f5f5"]];
    
    //显示分类编辑
    self.sortMenuView=[[DropSortMenuView alloc] initWithFrame:CGRectMake(0, self.viewBounds.origin.y+20, self.view.bounds.size.width, 200)];
    [self.sortMenuView setBackgroundColor:[UIColor clearColor]];
    self.sortMenuView.itemBtnBgColor=[UIColor whiteColor];
    self.sortMenuView.itemBtnDisEnableBgColor=[UIColor lightGrayColor];
    self.sortMenuView.itemBtnTitleColor=[UIColor darkGrayColor];
    NSMutableArray *menus=[[NSMutableArray alloc] init];
    for (CategoryObject *cateObj in [APPInitObject share].categorysShow) {
        DropItemObjcet *item=[[DropItemObjcet alloc] init];
        item.title=[NSString stringWithFormat:@"%@",cateObj.categoryName];
        item.index=cateObj.categoryID;
        [menus addObject:item];
    }
    self.sortMenuView.itemArray=menus;
    
    [self.sortMenuView initItemsWithCanSort:YES];
   
    [self.view addSubview:self.sortMenuView];
  
    
    //说明文字
    lable=[[UILabel alloc] initWithFrame:CGRectMake(0, self.sortMenuView.frame.origin.y+self.sortMenuView.frame.size.height+20, self.view.bounds.size.width, 40)];
    [lable setText:@"点击添加，拖动排序"];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [lable setFont:[UIFont systemFontOfSize:13]];
    [lable setTextColor:[UIColor darkGrayColor]];
    [lable setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
    [self.view addSubview:lable];
    
    
    //隐藏的分类
   
    self.hideMenuView=[[DropSortMenuView alloc] initWithFrame:CGRectMake(0, lable.frame.origin.y+lable.frame.size.height+20, self.view.bounds.size.width, 200)];
    [self.hideMenuView setBackgroundColor:[UIColor clearColor]];
    self.hideMenuView.itemBtnBgColor=[UIColor whiteColor];
    self.hideMenuView.itemBtnDisEnableBgColor=[UIColor lightGrayColor];
    self.hideMenuView.itemBtnTitleColor=[UIColor darkGrayColor];
    self.hideMenuView.allowEmpty=YES;

    NSMutableArray *menus2=[[NSMutableArray alloc] init];
    for (CategoryObject *cateObj in [APPInitObject share].categoryHide) {
        DropItemObjcet *item=[[DropItemObjcet alloc] init];
        item.title=[NSString stringWithFormat:@"%@",cateObj.categoryName];
        item.index=cateObj.categoryID;
        [menus2 addObject:item];
    }
    self.hideMenuView.itemArray=menus2;
   
    [self.hideMenuView initItemsWithCanSort:NO];
    [self.view addSubview:self.hideMenuView];
    
    __weak CagtegorySortViewController *weakself=self;

    self.sortMenuView.itemClick=^(DropItemObjcet *item){
        [weakself.hideMenuView addItem:item];
        [weakself layout];
        [weakself updateCategory];
    };
    self.sortMenuView.itemSorted=^(){
        [weakself updateCategory];
    };
    self.hideMenuView.itemClick=^(DropItemObjcet *item){
        [weakself.sortMenuView addItem:item];
        [weakself layout];
        [weakself updateCategory];
    };

}
-(void)viewDidAppear:(BOOL)animated
{
    oldShowCategorys=[NSArray arrayWithArray:[APPInitObject share].categorysShow];
    [super viewDidAppear:animated];
}
-(void)goBack
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(categorySortGoBack:)]) {
        [self.delegate categorySortGoBack:showCategorysChanged];
    }
}
//更新显示和隐藏的分类
-(void)updateCategory
{
    NSMutableArray *showCategoryTmp=[[NSMutableArray alloc] init];
    NSMutableArray *IDArr=[[NSMutableArray alloc] init];
    showCategorysChanged=NO;
    int i=0;
    int count=oldShowCategorys.count;
    for (DropItemObjcet *item in self.sortMenuView.itemArray) {
        NSPredicate *filter=[NSPredicate predicateWithFormat:@"categoryID=%d",item.index];
        [showCategoryTmp addObjectsFromArray:[[APPInitObject share].categorys filteredArrayUsingPredicate:filter]];
        [IDArr addObject:[NSNumber numberWithInt:item.index]];
        if (!showCategorysChanged) {
          
            if (count<(i+1)) {
                showCategorysChanged=YES;
            }
            else
            {
                CategoryObject *obj=[oldShowCategorys objectAtIndex:i];
                if (obj.categoryID!=item.index) {
                    showCategorysChanged=YES;
                }
            }
        }

        i++;
    }
    if (count>i) {
        showCategorysChanged=YES;
    }
    
    [APPInitObject share].categorysShow=[NSArray arrayWithArray:showCategoryTmp];
    [Common writeString:[IDArr JSONRepresentation] toPath:k_categoryShowPath];
    
}
-(void)layout
{
    lable.frame=CGRectMake(0, self.sortMenuView.frame.origin.y+self.sortMenuView.frame.size.height+20, self.view.bounds.size.width, 40);
    self.hideMenuView.frame=CGRectMake(0, lable.frame.origin.y+lable.frame.size.height+20, self.view.bounds.size.width, self.hideMenuView.frame.size.height);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  LeftMenuViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-10-31.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#define k_menuItemHeight 54.0f

#import "LeftMenuViewController.h"
#import "RESideMenu.h"
#import "Config.h"

@interface LeftMenuViewController ()
{
    int currentSelectedIndex;
}
@property(strong,nonatomic) UITableView *menuTableView;
@end

@implementation LeftMenuViewController

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
    currentSelectedIndex=0;
    self.menuTableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, self.view.bounds.size.height-30) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        
        tableView.backgroundView = nil;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.menuTableView];
    NSIndexPath *ip=[NSIndexPath indexPathForRow:0 inSection:0];
    [self.menuTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(leftMenuChangeSelected:)]) {
        [self.delegate leftMenuChangeSelected:indexPath.row];
    }
    [self.sideMenuViewController hideMenuViewController];
    currentSelectedIndex=indexPath.row;
    NSIndexPath *ip=[NSIndexPath indexPathForRow:currentSelectedIndex inSection:0];
    [self.menuTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionBottom];
}

#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return k_menuItemHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        UIView *sbg=[[UIView alloc] initWithFrame:cell.frame];
        sbg.backgroundColor=[UIColor colorWithWhite:0.5 alpha:0.3];
        cell.selectedBackgroundView = sbg;
    }
    
    NSArray *titles = @[@"博客园", @"分类", @"关注", @"收藏", @"关于",@"登陆"];
    //NSArray *titles = @[@"博客园", @"分类", @"关注", @"收藏",@"登录", @"关于"];
    NSArray *images = @[@"IconHome.png", @"IconCat.png", @"IconFocus.png", @"IconFav.png", @"IconAbout.png", @"IconAbout.png"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];

    return cell;
}


@end

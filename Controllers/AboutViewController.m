//
//  AboutViewController.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-26.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AboutViewController.h"
#import "SVProgressHUD.h"
@interface AboutViewController ()
{
    SKProductsRequest *skRequest;
}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSArray *productsARR;
@end

@implementation AboutViewController

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
    self.title=@"关于";
    [self changeNavBarTitleColor];
    [self.view setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
    
    self.tableView=({
        UITableView *tableView=[[UITableView alloc] initWithFrame:CGRectMake(10,10,self.view.bounds.size.width-20,tableViewHeith-30) style:UITableViewStylePlain];
        tableView.delegate=self;
        tableView.dataSource=self;
        if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            tableView.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0);
        }
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [tableView setTableFooterView:view];
        [self.view addSubview:tableView];
        [tableView setBackgroundColor:[Common translateHexStringToColor:@"#f0f0f0"]];
        tableView.scrollEnabled=NO;
        tableView;
    });
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"cnblogs01",
                                 nil];
   skRequest= [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    skRequest.delegate=self;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"关于";
    }
    if (section==1) {
        return @"赞助";
    }
    return @"";
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];
    [headerView setBackgroundColor:[UIColor clearColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 3, tableView.bounds.size.width - 10, 40)];
    
    if (section==0) {
        label.text = @"关于";
    }
    if (section==1) {
        label.text = @"赞助";
    }
    label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    [label setFont:[UIFont boldSystemFontOfSize:13]];
    label.backgroundColor = [UIColor clearColor];
    [headerView addSubview:label];
    return headerView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    if (sectionIndex==0) {
        return 3;
    }
    if (sectionIndex==1) {
        return 1;
    }
    return 0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        UIView *bg = [[UIView alloc] initWithFrame:cell.frame];
        bg.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = bg;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        [cell.detailTextLabel setTextColor:[UIColor lightGrayColor]];
        [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [cell.textLabel setBackgroundColor:[UIColor clearColor]];
        [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
        
    }
    if (indexPath.section==0) {
		if (indexPath.row==0) {
			cell.textLabel.text=@"睡睡博客园 V3.0";
            
		}
		if (indexPath.row==1) {
			cell.textLabel.text=@"作者:Ethan.Qiu";
			cell.detailTextLabel.text=@"ethanq@163.com";
            
		}
		if (indexPath.row==2) {
			cell.textLabel.text=@"亲,给个好评吧!";
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
		}
       

    }
    if (indexPath.section==1) {
		
        if (indexPath.row==0) {
			cell.textLabel.text=@"AppStore内购";
			[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
		}
       
        
    }
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==2) {
            NSString *iTunesLink = @"http://itunes.apple.com/cn/app/shui-shui-bo-ke-yuan/id512394144?mt=8";
            NSURL *iTunesURL = [NSURL URLWithString:iTunesLink];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }

    }
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            [SVProgressHUD showWithStatus:@""];
            [self IAP];
        }
    }
    
}
-(void)IAP
{
    NSSet *productIdentifiers = [NSSet setWithObjects:
                                 @"cnblogs01",
                                 @"cnblogs02",
                                 nil];
    SKProductsRequest *reqesut=[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    reqesut.delegate=self;
    [reqesut start];
}
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    [SVProgressHUD dismiss];
    self.productsARR=[NSArray arrayWithArray:response.products];

    if ( self.productsARR.count==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"没有内购信息" message:@"" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
   
    UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"谢谢您的支持"
                                                     delegate:self
                                            cancelButtonTitle:nil
                                       destructiveButtonTitle:nil
                                            otherButtonTitles: nil];
    for (SKProduct *pro in  self.productsARR)
    {
        [sheet addButtonWithTitle: pro.localizedTitle];
    }

    [sheet setActionSheetStyle:UIActionSheetStyleDefault];
    [sheet setCancelButtonIndex:[sheet addButtonWithTitle:@"取消"]];
    [sheet showInView:self.view];

    
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        SKProduct *pro=[self.productsARR objectAtIndex:buttonIndex];
        SKPayment *payment = [SKPayment paymentWithProduct:pro];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
        [SVProgressHUD showWithStatus:@""];
    }
}
// Sent when the transaction array has changed (additions or state changes).  Client should check state of transactions and finish as appropriate.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *tran in transactions) {
        if (tran.transactionState==SKPaymentTransactionStateFailed) {
            [SVProgressHUD showErrorWithStatus:@"支付失败"];
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
        if (tran.transactionState==SKPaymentTransactionStatePurchased) {
           [SVProgressHUD showSuccessWithStatus:@"支付成功，谢谢您的支持"];
            [[SKPaymentQueue defaultQueue] finishTransaction:tran];
        }
        
    }
}
// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}
// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
}
@end

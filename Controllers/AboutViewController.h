//
//  AboutViewController.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-26.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "BaseViewController.h"
#import <StoreKit/StoreKit.h>
@interface AboutViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,UIActionSheetDelegate,SKPaymentTransactionObserver>

@end

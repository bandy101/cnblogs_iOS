//
//  ListViewCell.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-27.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostObject.h"
#define k_ListViewCell_Height 70.0f

@interface ListViewCell : UITableViewCell
@property(nonatomic,strong) PostObject *post;
@end

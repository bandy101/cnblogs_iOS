//
//  AuthorListDetailCell.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-24.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorObject.h"
#define k_AuthorListDetailCell_Height 110.0f
@protocol AuthorListDetailCellDelegate;
@interface AuthorListDetailCell : UITableViewCell
@property(nonatomic,strong) AuthorObject *author;
@property(nonatomic,assign) id<AuthorListDetailCellDelegate> delegate;
@end

@protocol AuthorListDetailCellDelegate <NSObject>

@optional
-(void)authorListCancelFocus:(int)index;

@end
//
//  AuthorListCell.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-20.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorObject.h"
#define k_AuthorListCell_Height 70.0f

@interface AuthorListCell : UITableViewCell
@property(nonatomic,strong) AuthorObject *author;

@end


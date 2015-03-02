//
//  CommentCell.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-18.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CommentObject;
@interface CommentCell : UITableViewCell
{
    UIView *separator;
}
@property(nonatomic,strong) UILabel *IDLable;
@property(nonatomic,strong) UILabel *authorLable;
@property(nonatomic,strong) UILabel *dateLable;
@property(nonatomic,strong) UITextView *bodyText;
@property(nonatomic,strong) CommentObject *commObj;
@end

//
//  AuthorListDetailCell.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-24.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AuthorListDetailCell.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"
@interface AuthorListDetailCell()
{
    UIImageView *headerImageView;
    UITextField *authorName;
    UILabel *note;
    UILabel *dateLable;
    UILabel *lastedTitle;
    UIButton *cancelBtn;
    
}
@end
@implementation AuthorListDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView=[[UIView alloc] initWithFrame:CGRectMake(10, 10, self.bounds.size.width-20, k_AuthorListDetailCell_Height-10)];
        [bgView setBackgroundColor:[UIColor whiteColor]];
        [bgView.layer setCornerRadius:3];
        [bgView.layer setBorderWidth:1.0f];
        [bgView.layer setBorderColor:[UIColor colorWithWhite:0.0f alpha:0.1].CGColor];
        [self addSubview:bgView];
        
        headerImageView=[[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        [bgView addSubview:headerImageView];
        
        authorName=[[UITextField alloc] init];
        [authorName setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [authorName setFont:[UIFont boldSystemFontOfSize:14]];
        [authorName setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [authorName setEnabled:NO];
        [authorName setBackgroundColor:[UIColor clearColor]];
        [authorName setFrame:CGRectMake(75, 8, CGRectGetWidth(bgView.bounds)-10-75, 20)];
        [bgView addSubview:authorName];
        
        
        dateLable=[[UILabel alloc] init];
        [dateLable setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [dateLable setFont:[UIFont systemFontOfSize:13]];
        [dateLable setTextAlignment:NSTextAlignmentRight];
        [dateLable setBackgroundColor:[UIColor clearColor]];
        [dateLable setFrame:CGRectMake(75, 75, CGRectGetWidth(bgView.bounds)-75-10, 20)];
        [bgView addSubview:dateLable];
        

        
        lastedTitle=[[UILabel alloc] init];
        [lastedTitle setTextColor:[Common translateHexStringToColor:@"#666666"]];
        [lastedTitle setFont:[UIFont boldSystemFontOfSize:13]];
        [lastedTitle setBackgroundColor:[UIColor clearColor]];
        [lastedTitle setFrame:CGRectMake(75, 30, bgView.bounds.size.width-10-75, 40)];
        [lastedTitle setNumberOfLines:0];
        [bgView addSubview:lastedTitle];
        
        cancelBtn=[[UIButton alloc] init];
        [cancelBtn setTitle:@"取消关注" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:11]];
        [cancelBtn setBackgroundImage:[UIImage imageNamed:@"cellBtn.png"] forState:UIControlStateNormal];
        [cancelBtn setFrame:CGRectMake(10, 70, 54, 24)];
        [cancelBtn addTarget:self action:@selector(cancelFocus) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:cancelBtn];
        

    }
    return self;
}
-(void)cancelFocus
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(authorListCancelFocus:)]) {
        [self.delegate authorListCancelFocus:self.tag];
    }
}
-(void)setAuthor:(AuthorObject *)author_
{
    _author=author_;
    if (_author.header.length>0)
    {
        
        [headerImageView setImageWithURL:[NSURL URLWithString:_author.header]];
    }
    else
    {
        [headerImageView setImage:[UIImage imageNamed:@"userheader.png"]];
    }
    
    authorName.text=_author.name;
    lastedTitle.text=_author.lastedTitle;
    if (_author.updated.length>=10) {
        dateLable.text=[NSString stringWithFormat:@"更新:%@",[_author.updated substringToIndex:10]];
    }
    

}
- (void)layoutSubviews {
    [super layoutSubviews];

   
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

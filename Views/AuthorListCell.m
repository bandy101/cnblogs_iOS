//
//  AuthorListCell.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-20.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "AuthorListCell.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"
@interface AuthorListCell()
{
    UIImageView *headerImageView;
    UITextField *title;
    UILabel *note;
    UILabel *authorLable;
    UILabel *date;
    UILabel *comment;

}
@end
@implementation AuthorListCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
     self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        headerImageView=[[UIImageView alloc] init];
        [headerImageView setContentMode:UIViewContentModeScaleAspectFit];
        [self addSubview:headerImageView];
        
        title=[[UITextField alloc] init];
        [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
        [title setFont:[UIFont boldSystemFontOfSize:14]];
        [title setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [title setEnabled:NO];
        [title setBackgroundColor:[UIColor clearColor]];
        [self addSubview:title];
        
        
        authorLable=[[UILabel alloc] init];
        [authorLable setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [authorLable setFont:[UIFont systemFontOfSize:13]];
        [authorLable setNumberOfLines:0];
        [authorLable setBackgroundColor:[UIColor clearColor]];
        [self addSubview:authorLable];
        
        date=[[UILabel alloc] init];
        [date setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [date setFont:[UIFont systemFontOfSize:13]];
        [date setNumberOfLines:0];
        [date setBackgroundColor:[UIColor clearColor]];
        [self addSubview:date];

        
        //UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, k_ListViewCell_Height - 0.5, self.bounds.size.width, 1)];
        UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(10, k_AuthorListCell_Height - 1.0, self.bounds.size.width-20, 1)];
        //separator.backgroundColor = [UIColor darkGrayColor];
        separator2.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        //[self addSubview:separator];
        [self addSubview:separator2];
    }
    return self;
}

-(void)setAuthor:(AuthorObject *)author_
{
    _author=author_;
    if (_author.header.length>0)
    {
        
        [headerImageView setImageWithURL:[NSURL URLWithString:_author.header]];
    }
    
    title.text=_author.name;
    
    authorLable.text=[NSString stringWithFormat:@"更新:%@",[_author.updated substringToIndex:10]];
    date.text=[NSString stringWithFormat:@"文章:%@",_author.count];
    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    float titleMagin=0;
    if (self.author.header.length>0)
    {
        [headerImageView setFrame:CGRectMake(10, 8, 54, 54)];
        titleMagin=75;
    }
    else
    {
        
        [headerImageView setFrame:CGRectZero];
        titleMagin=10;
    }
    
    [title setFrame:CGRectMake(titleMagin, 8, CGRectGetWidth(self.bounds)-titleMagin-10, 20)];
    [authorLable setFrame:CGRectMake(titleMagin, 30, 200, 30)];
    [date setFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 30, 100, 30)];
}

@end

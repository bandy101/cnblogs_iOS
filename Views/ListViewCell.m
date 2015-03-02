//
//  ListViewCell.m
//  NewsBrowser
//
//  Created by Ethan on 13-11-27.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "ListViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "Common.h"
@interface ListViewCell()
{
    UIImageView *headerImageView;
    UITextField *title;
    UILabel *note;
    UILabel *author;
    UILabel *date;
    UILabel *comment;
}
@end
@implementation ListViewCell

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
        
        
        author=[[UILabel alloc] init];
        [author setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [author setFont:[UIFont systemFontOfSize:13]];
        [author setNumberOfLines:0];
        [author setBackgroundColor:[UIColor clearColor]];
        [self addSubview:author];
        
        date=[[UILabel alloc] init];
        [date setTextColor:[Common translateHexStringToColor:@"#888888"]];
        [date setFont:[UIFont systemFontOfSize:13]];
        [date setNumberOfLines:0];
        [date setBackgroundColor:[UIColor clearColor]];
        [self addSubview:date];
        
        //UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, k_ListViewCell_Height - 0.5, self.bounds.size.width, 1)];
        UIView *separator2 = [[UIView alloc] initWithFrame:CGRectMake(10, k_ListViewCell_Height - 1.0, self.bounds.size.width-20, 1)];
        //separator.backgroundColor = [UIColor darkGrayColor];
        separator2.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        //[self addSubview:separator];
        [self addSubview:separator2];
    }
    return self;
}
-(void)setPost:(PostObject *)post
{
    _post=post;
    if (_post.header.length>0)
    {
       
       [headerImageView setImageWithURL:[NSURL URLWithString:_post.header]];
    }
    
    title.text=_post.title;
    if (_post.isReaded) {
        [title setTextColor:[Common translateHexStringToColor:@"#888888"]];
    }
    else{
        [title setTextColor:[Common translateHexStringToColor:@"#121212"]];
    }
    //self.note.text=_post.summary;
    author.text=_post.author;
    date.text=[[_post.date componentsSeparatedByString:@" "] objectAtIndex:0];

    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
 
    float titleMagin=0;
    if (self.post.header.length>0)
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
    //[self.note setFrame:CGRectMake(titleMagin, 30, CGRectGetWidth(self.bounds)-titleMagin-10, 30)];
    [author setFrame:CGRectMake(titleMagin, 30, 100, 30)];
    [date setFrame:CGRectMake(CGRectGetWidth(self.bounds)-100, 30, 100, 30)];
    //[self.comment setFrame:CGRectMake(titleMagin+100+100+20, 30, 20, 30)];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

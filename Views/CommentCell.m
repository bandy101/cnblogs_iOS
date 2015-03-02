//
//  CommentCell.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-18.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "CommentCell.h"
#import "CommentViewController.h"
#import "Common.h"
#define k_CommentCellHeaderHeight 20.0f


@interface UITextView (Helper)

- (CGFloat)measureHeight;

@end


@implementation UITextView (Helper)

- (CGFloat)measureHeight
{
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)])
    {
        // This is the code for iOS 7. contentSize no longer returns the correct value, so
        // we have to calculate it.
        //
        // This is partly borrowed from HPGrowingself, but I've replaced the
        // magic fudge factors with the calculated values (having worked out where
        // they came from)
        
        CGRect frame = self.bounds;
        
        // Take account of the padding added around the text.
        
        UIEdgeInsets textContainerInsets = self.textContainerInset;
        UIEdgeInsets contentInsets = self.contentInset;
        
        CGFloat leftRightPadding = textContainerInsets.left + textContainerInsets.right + self.textContainer.lineFragmentPadding * 2 + contentInsets.left + contentInsets.right;
        CGFloat topBottomPadding = textContainerInsets.top + textContainerInsets.bottom + contentInsets.top + contentInsets.bottom;
        
        frame.size.width -= leftRightPadding;
        frame.size.height -= topBottomPadding;
        
        NSString *textToMeasure = self.text;
        if ([textToMeasure hasSuffix:@"\n"])
        {
            textToMeasure = [NSString stringWithFormat:@"%@-", self.text];
        }
        
        // NSString class method: boundingRectWithSize:options:attributes:context is
        // available only on ios7.0 sdk.
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
        
        NSDictionary *attributes = @{ NSFontAttributeName: self.font, NSParagraphStyleAttributeName : paragraphStyle };
        
        CGRect size = [textToMeasure boundingRectWithSize:CGSizeMake(CGRectGetWidth(frame), MAXFLOAT)
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:attributes
                                                  context:nil];
        
        CGFloat measuredHeight = ceilf(CGRectGetHeight(size) + topBottomPadding);
        return measuredHeight;
    }
    else
    {
        return self.contentSize.height;
    }
}

@end

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(10, 7, 17, 17)];
        [img setImage:[UIImage imageNamed:@"comment_profile_default.png"]];
        [self addSubview:img];
        
        self.IDLable=({
            UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-60, 5, 50, k_CommentCellHeaderHeight)];
            [lable setTextAlignment:NSTextAlignmentRight];
            [lable setFont:[UIFont systemFontOfSize:12]];
            [lable setTextColor:[UIColor lightGrayColor]];
            [lable setBackgroundColor:[UIColor clearColor]];
            [self addSubview:lable];
            lable;
        });
        self.authorLable=({
            UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(30, 5, 100, k_CommentCellHeaderHeight)];
            [lable setTextAlignment:NSTextAlignmentLeft];
            [lable setFont:[UIFont systemFontOfSize:13]];
            [lable setBackgroundColor:[UIColor clearColor]];
            [lable setTextColor:[Common translateHexStringToColor:@"#30A2BE"]];
            [self addSubview:lable];
            lable;
        });
        self.bodyText=({
            UITextView *txtView=[[UITextView alloc] initWithFrame:CGRectMake(10, k_CommentCellHeaderHeight+10, self.bounds.size.width-20, 0)];
            [txtView setFont:[UIFont systemFontOfSize:14]];
            [txtView setBackgroundColor:[UIColor clearColor]];
            [txtView setEditable:NO];
            [self addSubview:txtView];
            txtView;
        });
        /*
        self.dateLable=({
            UILabel *lable=[[UILabel alloc] initWithFrame:CGRectMake(150, 5, 100, k_CommentCellHeaderHeight)];
            [lable setTextAlignment:NSTextAlignmentLeft];
            [lable setFont:[UIFont systemFontOfSize:12]];
            [lable setTextColor:[UIColor darkGrayColor]];
            [self addSubview:lable];
            lable;
        });
         */
        
        separator = [[UIView alloc] initWithFrame:CGRectMake(10,  self.bounds.size.height - 1.0, self.bounds.size.width-20, 1)];
        separator.backgroundColor =[Common translateHexStringToColor:@"#e1e1e1"];
        [self addSubview:separator];
    }
    return self;
}
-(void)setCommObj:(CommentObject *)commObj
{
    _commObj=commObj;
    self.IDLable.text=[NSString stringWithFormat:@"%d#",self.commObj.row];
    self.authorLable.text=self.commObj.author;
    self.bodyText.text=self.commObj.body;
    float bodyHeight=[self.bodyText measureHeight]+15;

    self.bodyText.frame=CGRectMake(self.bodyText.frame.origin.x, self.bodyText.frame.origin.y, self.bodyText.frame.size.width, bodyHeight);
    self.frame=CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, k_CommentCellHeaderHeight+bodyHeight);
    separator.frame=CGRectMake(separator.frame.origin.x, self.bounds.size.height - 1.0, separator.frame.size.width, separator.frame.size.height);
   // self.dateLable.text=self.commObj.date ;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  RefreshFooterView.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-6.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "RefreshFooterView.h"
@interface RefreshFooterView()
{
    UIButton *btn;
    UIActivityIndicatorView *act;
}
@end
@implementation RefreshFooterView
+(RefreshFooterView *)footerWithWidth:(float)width
{
  return [[RefreshFooterView alloc] initWithFrame:CGRectMake(0, 0, width, k_RefreshFooterViewHeight)];

}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float btnW=250.0f;
        float btnH=40.0f;
        float btnX=(frame.size.width-btnW)*0.5f;
        float btnY=(frame.size.height-btnH)*0.5f;
        btn=[[UIButton alloc] initWithFrame:CGRectMake(btnX, btnY, btnW, btnH)];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        
        UIImage *btnBg=[UIImage imageNamed:@"refresh_button"];
        btnBg=[btnBg stretchableImageWithLeftCapWidth:5 topCapHeight:5];
        [btn setBackgroundImage:btnBg forState:UIControlStateNormal];
        [self addSubview:btn];
        
        act=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [act setFrame:CGRectMake(0, 0, 30, 30)];
        act.center=CGPointMake(btn.center.x-100, btn.center.y-10);
        
        
        
    }
    return self;
}
-(void)setStatus:(FooterRefreshState)status
{
    _status=status;
    [btn setEnabled:YES];
    if (self.status==FooterRefreshStateNormal)
    {
       
        [btn setTitle:k_RefreshFooterNormalStr forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [act stopAnimating];
        [act removeFromSuperview];
        
    }
    else if(self.status==FooterRefreshStateRefreshing)
    {
        [btn addSubview:act];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn removeTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:k_RefreshFooterRefreshingStr forState:UIControlStateNormal];
        [act startAnimating];
        if (self.delegate&&[self.delegate respondsToSelector:@selector(refreshFooterBegin:)]) {
            [self.delegate refreshFooterBegin:self];
        }
    }
    else if (self.status==FooterRefreshStateDiseable)
    {

        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setEnabled:NO];
        [act stopAnimating];
        [act removeFromSuperview];
        [btn setTitle:k_RefreshFooterNoMoreStr forState:UIControlStateNormal];
    }
    
}
-(void)refresh
{
    [self setStatus:FooterRefreshStateRefreshing];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

//
//  MJRefreshHeaderView.m
//  weibo
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#define kPullToRefresh @"下拉刷新"
#define kReleaseToRefresh @"松开刷新"
#define kRefreshing @"数据加载..."

#define kTimeKey  [NSString stringWithFormat:@"MJRefreshHeaderView%@",self.refreshID]

#import "MJRefreshHeaderView.h"

@interface MJRefreshHeaderView()


@end

@implementation MJRefreshHeaderView

+ (id)header
{
    return [[MJRefreshHeaderView alloc] init];
}

#pragma mark - UIScrollView相关
#pragma mark 重写设置ScrollView
- (void)setScrollView:(UIScrollView *)scrollView
{
    [super setScrollView:scrollView];
    float y=-kViewHeight;
    if (self.headerAddToBack) {
        y=self.scrollViewInsetTop;
    }
    // 设置边框
    self.frame = CGRectMake(0, y, scrollView.frame.size.width, kViewHeight);
   
    // 加载时间
    _lastUpdateTime = [[NSUserDefaults standardUserDefaults] objectForKey:kTimeKey];
    
    // 设置时间
    [self updateTimeLabel];
}

#pragma mark - 状态相关
#pragma mark 设置最后的更新时间
- (void)setLastUpdateTime:(NSDate *)lastUpdateTime
{
    _lastUpdateTime = lastUpdateTime;
    
    // 归档
    [[NSUserDefaults standardUserDefaults] setObject:_lastUpdateTime forKey:kTimeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // 更新时间
    [self updateTimeLabel];
}

#pragma mark 更新时间字符串
- (void)updateTimeLabel
{
    if (!_lastUpdateTime) return;
    
    // 1.获得年月日
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    NSDateComponents *cmp1 = [calendar components:unitFlags fromDate:_lastUpdateTime];
    NSDateComponents *cmp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    
    // 2.格式化日期
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if ([cmp1 day] == [cmp2 day]) { // 今天
        if ([cmp1 hour]==[cmp2 hour])
        {
            if ([cmp2 minute]==[cmp1 minute])
            {
                formatter.dateFormat=@"刚刚";
            }
            else
            {
                formatter.dateFormat = [NSString stringWithFormat:@"%d分钟前",[cmp2 minute]-[cmp1 minute]];
            }
        }
        else
        {
            formatter.dateFormat = [NSString stringWithFormat:@"%d小时前",[cmp2 hour]-[cmp1 hour]];
        }
    } else if ([cmp1 year] == [cmp2 year]) { // 今年
        formatter.dateFormat = @"MM-dd HH:mm";
    } else {
        formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    }
    NSString *time = [formatter stringFromDate:_lastUpdateTime];
    
    // 3.显示日期
    _lastUpdateTimeLabel.text = [NSString stringWithFormat:@"最后更新：%@", time];
}

#pragma mark 设置状态
- (void)setState:(RefreshState)state
{
    if (_state == state) return;
    
    [super setState:state];
    
    // 保存旧状态
    RefreshState oldState = _state;
    
	switch (_state = state) {
            case RefreshStateBeginPulling:
        {
            _state=oldState;
            [self updateTimeLabel];
            break;
        }
		case RefreshStatePulling:
        {
            _statusLabel.text = kReleaseToRefresh;
            [UIView animateWithDuration:0.2 animations:^{
                //_arrowImage.transform = CGAffineTransformMakeRotation(M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = self.scrollViewInsetTop;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case RefreshStateNormal:
        {
            
			_statusLabel.text = kPullToRefresh;
            
            // 刷新完毕
            if (oldState == RefreshStateRefreshing) {
                // 保存刷新时间
               
                self.lastUpdateTime = [NSDate date];
            }
            [UIView animateWithDuration:0.2 animations:^{
                [self.arcView.layer removeAnimationForKey:@"rotateAnimation"];
                self.arcView.transform = CGAffineTransformIdentity;
                self.arcView.process=0;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = self.scrollViewInsetTop;
                _scrollView.contentInset = inset;
            }];
			break;
        }
            
		case RefreshStateRefreshing:
        {
            _statusLabel.text = kRefreshing;
            
             self.arcView.process=100;
            [UIView animateWithDuration:0.2 animations:^{
                // 1.顶部多出65的滚动范围
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = kViewHeight+self.scrollViewInsetTop;
                _scrollView.contentInset = inset;
                // 2.设置滚动位置
                _scrollView.contentOffset = CGPointMake(0, -kViewHeight-self.scrollViewInsetTop);
            }];
            CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            rotationAnimation.toValue = [NSNumber numberWithFloat:(2 * M_PI) * 1];
            rotationAnimation.duration = 1.0f;
            rotationAnimation.repeatCount=MAXFLOAT;
            [self.arcView.layer addAnimation:rotationAnimation forKey:@"rotateAnimation"];

			break;
        }
	}
}

#pragma mark - 在父类中用得上
// 合理的Y值
- (CGFloat)validY
{
    return 0;
}

// view的类型
- (int)viewType
{
    return RefreshViewTypeHeader;
}
@end
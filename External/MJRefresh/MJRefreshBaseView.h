//
//  MJRefreshBaseView.h
//  weibo
//  
//  Created by mj on 13-3-4.
//  Copyright (c) 2013年 itcast. All rights reserved.


// 如果定义了NeedAudio这个宏，说明需要音频
// 依赖于AVFoundation.framework 和 AudioToolbox.framework
//#define NeedAudio

// view的高度
#define kViewHeight 65.0

//
#import <UIKit/UIKit.h>
//#import <AVFoundation/AVFoundation.h>
#import "RefreshArcView.h"

typedef enum {
	RefreshStatePulling = 1,
	RefreshStateNormal = 2,
	RefreshStateRefreshing = 3,
    RefreshStateBeginPulling=4
} RefreshState;

typedef enum {
    RefreshViewTypeHeader = -1,
    RefreshViewTypeFooter = 1
} RefreshViewType;

@class MJRefreshBaseView;

typedef void (^BeginRefreshingBlock)(MJRefreshBaseView *refreshView);

@protocol MJRefreshBaseViewDelegate <NSObject>
@optional
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView;
@end

@interface MJRefreshBaseView : UIView
{
    // 父控件
    __weak UIScrollView *_scrollView;
    // 代理
    __weak id<MJRefreshBaseViewDelegate> _delegate;
    // 回调
    BeginRefreshingBlock _beginRefreshingBlock;
    
    // 子控件
    __weak UILabel *_lastUpdateTimeLabel;
	__weak UILabel *_statusLabel;

    
    // 状态
    RefreshState _state;

}

// 构造方法
- (id)initWithScrollView:(UIScrollView *)scrollView;

// 内部的控件
@property (nonatomic, weak, readonly) UILabel *lastUpdateTimeLabel;
@property (nonatomic, weak, readonly) UILabel *statusLabel;
@property (nonatomic, strong) RefreshArcView *arcView;

// 回调
@property (nonatomic, copy) BeginRefreshingBlock beginRefreshingBlock;
// 代理
@property (nonatomic, weak) id<MJRefreshBaseViewDelegate> delegate;
// 设置要显示的父控件
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;

// 是否正在刷新
@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

//是否把header放到scrollview后面
@property(nonatomic) BOOL headerAddToBack;
@property(nonatomic) float scrollViewInsetTop;
//区分ID
@property(nonatomic,strong) NSString *refreshID;
// 开始刷新
- (void)beginRefreshing;
// 结束刷新
- (void)endRefreshing;
// 结束使用、释放资源
- (void)free;

// 交给子类去实现
- (void)setState:(RefreshState)state;
@end
//
//  MJRefreshHeaderView.h
//  weibo
//
//  Created by mj on 13-2-26.
//  Copyright (c) 2013年 itcast. All rights reserved.
//  下拉刷新

#import "MJRefreshBaseView.h"

// 类
@interface MJRefreshHeaderView : MJRefreshBaseView
+ (id)header;
// 最后的更新时间
@property (nonatomic, strong) NSDate *lastUpdateTime;
@end
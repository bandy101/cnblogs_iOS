//
//  DropSortMenuView.h
//  DropSortMenu
//
//  Created by Ethan on 13-12-27.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>

//拖动单元
@interface DropItemObjcet : NSObject
@property(nonatomic,strong) NSString *title;
@property(nonatomic,assign) int index;
@property(nonatomic,assign) BOOL disEnable;
@end

typedef void(^DropSortMenuViewSortBlock)();
typedef void(^DropSortMenuViewItemClick)(DropItemObjcet *item);

@interface DropSortMenuView : UIView
@property(nonatomic,strong) NSMutableArray *itemArray;
@property(nonatomic,strong) UIColor *itemBtnBgColor;
@property(nonatomic,strong) UIColor *itemBtnTitleColor;
@property(nonatomic,strong) UIColor *itemBtnDisEnableBgColor;
@property(nonatomic,copy) DropSortMenuViewItemClick itemClick;
@property(nonatomic,copy) DropSortMenuViewSortBlock itemSorted;
@property(nonatomic,assign) BOOL allowEmpty;
-(void)initItemsWithCanSort:(BOOL)sort;
-(void)addItem:(DropItemObjcet *)item;
@end



//位置信息
typedef enum{
    DropItemStatusType_nomarl = 1,
    DropItemStatusType_active = 2
}DropItemStatusType;
@interface DropItemPostionView : UIView
@property(nonatomic,assign) DropItemStatusType status;
@property(nonatomic,assign) int index;

@end


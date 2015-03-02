//
//  DropSortMenuView.m
//  DropSortMenu
//
//  Created by Ethan on 13-12-27.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#define k_itemWidth 71.0f
#define k_itemHeight 35.0f
#define k_itemMarginLeft 7.2f
#define k_itemMarginTop 10.0f
#define k_itemBtnTag 900
#import <objc/runtime.h>
#import "DropSortMenuView.h"
@interface UIButton (sortmenu)
@property(nonatomic,strong) NSNumber *newTag;
@end
static void *MyKey = (void *)@"MyKey";
@implementation UIButton (sortmenu)
-(void)setNewTag:(NSNumber *)newTag
{

    objc_setAssociatedObject(self, MyKey, newTag,OBJC_ASSOCIATION_COPY_NONATOMIC);
}
-(NSNumber *)newTag
{
    return objc_getAssociatedObject(self, MyKey);
}
@end

@interface DropSortMenuView()
{
    int currentEmptyIndex;
    int column;
    int rows;
    BOOL isBusy;
    BOOL isSort;
}
@property(nonatomic,strong) NSMutableArray *itemPositionArray;
@end
@implementation DropSortMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.itemPositionArray=[[NSMutableArray alloc] init];
    }
    return self;
}
-(void)initItemsWithCanSort:(BOOL)sort
{
    for (DropItemPostionView *pv in self.itemPositionArray) {
        [pv removeFromSuperview];
    }
    [self.itemPositionArray removeAllObjects];
    isSort=sort;
    //列数
    column=round((self.bounds.size.width-k_itemMarginLeft)/(k_itemWidth+k_itemMarginLeft));
    //行数
    rows=ceil(self.itemArray.count/(column*1.0));
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rows*(k_itemHeight+k_itemMarginTop))];
    
    int i=0;
    for (DropItemObjcet *item in self.itemArray)
    {
        int c=i%column;
        int r=i/column;
        float x=c*(k_itemWidth+k_itemMarginLeft)+k_itemMarginLeft;
        CGRect rect=CGRectMake(x, r*(k_itemHeight+k_itemMarginTop), k_itemWidth, k_itemHeight);
        [self addButtonForItem:item index:i frame:rect];
        i++;
    }
}
-(void)addButtonForItem:(DropItemObjcet *)item index:(int)i frame:(CGRect)rect
{
    //添加位置信息
    DropItemPostionView *poView=[[DropItemPostionView alloc] initWithFrame:rect];
    poView.index=i;
    [self addSubview:poView];
    [self.itemPositionArray addObject:poView];
    
    UIButton *itemBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [itemBtn setFrame:rect];
    [itemBtn setBackgroundColor:self.itemBtnBgColor];
    [itemBtn setTitle:item.title forState:UIControlStateNormal];
    [itemBtn setTitleColor:self.itemBtnTitleColor forState:UIControlStateNormal];
    [itemBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [itemBtn setTag:i+k_itemBtnTag];
    
    itemBtn.newTag=[NSNumber numberWithInt:i+k_itemBtnTag];
    if(item.disEnable)
    {
        [itemBtn setBackgroundColor:self.itemBtnDisEnableBgColor];
    }
    else
    {
        [itemBtn addTarget:self action:@selector(itemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (isSort)
        {
            UILongPressGestureRecognizer *longGes=[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(itemBtnlongPress:)];
            [itemBtn addGestureRecognizer:longGes];
        }
        
    }
    [self addSubview:itemBtn];
}
-(void)addItem:(DropItemObjcet *)item
{
    isBusy=YES;
    int c=0;
    int r=ceil(self.itemArray.count/column);
    if (self.itemArray.count%column==0) {
        
    }
    else
    {
        c=self.itemArray.count%column;
    }
    float x=c*(k_itemWidth+k_itemMarginLeft)+k_itemMarginLeft;
    CGRect rect=CGRectMake(x, r*(k_itemHeight+k_itemMarginTop), k_itemWidth, k_itemHeight);
    [self addButtonForItem:item index:self.itemArray.count frame:rect];
    [self.itemArray addObject:item];
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, (r+1)*(k_itemHeight+k_itemMarginTop))];

    isBusy=NO;
}
-(void)removeItem:(int)index
{
    
    for (int i=0; i<self.itemArray.count; i++) {
        UIButton *btn=(UIButton *)[self viewWithTag:i+k_itemBtnTag];
        [btn removeFromSuperview];
    }
    [self.itemArray removeObjectAtIndex:index];
    [self initItemsWithCanSort:isSort];

}
-(void)itemBtnClick:(id)sender
{
    if (isBusy) {
        return;
    }
    if (!self.allowEmpty&&self.itemArray.count==1) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"" message:@"至少保留一项" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    UIButton *btn=(UIButton *)sender;
    int tag=btn.tag-k_itemBtnTag;
    //删除item
    DropItemObjcet *item=[self.itemArray objectAtIndex:tag];
    [self removeItem:tag];
    
    if (self.itemClick) {
        self.itemClick(item);
    }

}
- (void)itemBtnlongPress:(UILongPressGestureRecognizer*)gesture {
    if (isBusy) {
        return;
    }
     UIButton *itemBtn=(UIButton *)gesture.view;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        //长按激活移动
        [UIView animateWithDuration:0.5f animations:^{
            itemBtn.transform=CGAffineTransformMakeScale(1.3, 1.3);
        }];
    }
    else if(gesture.state==UIGestureRecognizerStateChanged)
    {
        [self bringSubviewToFront:itemBtn];
        CGPoint point=[gesture locationInView:self];
        itemBtn.center=point;
        currentEmptyIndex=itemBtn.tag-k_itemBtnTag;
        [self findNewPositionForItemBtn:itemBtn];
        itemBtn.newTag=[NSNumber numberWithInt:currentEmptyIndex+k_itemBtnTag];
        [self resetItemBtnTag];
        
    }
    else if(gesture.state==UIGestureRecognizerStateEnded)
    {
     
        [UIView animateWithDuration:0.5f animations:^{
            itemBtn.transform=CGAffineTransformMakeScale(1.0, 1.0);
            itemBtn.center=[(DropItemPostionView *)[self.itemPositionArray objectAtIndex:currentEmptyIndex] center];
        }];
        if (self.itemSorted) {
            self.itemSorted();
        }
    }
}
//重新排序按钮和数组
-(void)resetItemBtnTag
{
    
    NSMutableArray *btnTempArray=[[NSMutableArray alloc] init];
    for (int i=0; i<self.itemArray.count; i++)
    {
        UIButton *btn=(UIButton *)[self viewWithTag:i+k_itemBtnTag];
        [btnTempArray addObject:btn];
    }
    NSMutableArray *itemTempArray=[[NSMutableArray alloc] init];
    for (int i=0; i<btnTempArray.count; i++) {
       
        UIButton *btn=(UIButton *)[btnTempArray objectAtIndex:i];
        //重置数组的序列
        [itemTempArray addObject:[self.itemArray objectAtIndex:([btn.newTag intValue]-k_itemBtnTag)]];
        //重置按钮的tag
        btn.tag=[btn.newTag intValue];
      
    }
    self.itemArray=[NSMutableArray arrayWithArray:itemTempArray];
    [itemTempArray removeAllObjects];
    itemTempArray=nil;
    [btnTempArray removeAllObjects];
    btnTempArray=nil;
    
}
//查找移到到合适可以放的位置信息
-(void)findNewPositionForItemBtn:(UIButton *)btn
{
    
    for (int i=0; i<self.itemPositionArray.count; i++) {
        DropItemPostionView *poView=[self.itemPositionArray objectAtIndex:i];
        if(CGRectContainsPoint(poView.frame,btn.center)&&currentEmptyIndex!=poView.index&&![(DropItemObjcet *)[self.itemArray objectAtIndex:i] disEnable])
        {
            
            poView.status=DropItemStatusType_active;
            [self emptyPositionAtIndex:poView.index];
            break;
        }
    }
}
//空出当前合适的位置
-(void)emptyPositionAtIndex:(int)index
{
    
    int tempCurrentEmpty;
    if (currentEmptyIndex>index) {
        tempCurrentEmpty=currentEmptyIndex;
        for (int i=currentEmptyIndex-1; i>=index; i--) {
            if (![(DropItemObjcet *)[self.itemArray objectAtIndex:i] disEnable]) {
                UIButton *btn=(UIButton *)[self viewWithTag:i+k_itemBtnTag];
                [UIView animateWithDuration:0.3 animations:^{
                     btn.frame=[(DropItemPostionView *)[self.itemPositionArray objectAtIndex:tempCurrentEmpty] frame];
                }];
               
                btn.newTag=[NSNumber numberWithInt:tempCurrentEmpty+k_itemBtnTag];
                tempCurrentEmpty=i;
               
            }
        }
    }
    if (currentEmptyIndex<index) {
        tempCurrentEmpty=currentEmptyIndex;
        for (int i=currentEmptyIndex+1; i<=index; i++) {
            if (![(DropItemObjcet *)[self.itemArray objectAtIndex:i] disEnable]) {
                UIButton *btn=(UIButton *)[self viewWithTag:i+k_itemBtnTag];
                [UIView animateWithDuration:0.3 animations:^{
                    btn.frame=[(DropItemPostionView *)[self.itemPositionArray objectAtIndex:tempCurrentEmpty] frame];
                }];
                btn.newTag=[NSNumber numberWithInt:tempCurrentEmpty+k_itemBtnTag];
                tempCurrentEmpty=i;
                
            }
        }
    }
    for (DropItemPostionView *ditView in self.itemPositionArray) {
        [self sendSubviewToBack:ditView];
    }
    currentEmptyIndex=index;
}

@end

@implementation DropItemObjcet
@end
@interface DropItemPostionView()
{
    UIImageView *bgView;
}
@end
@implementation DropItemPostionView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        bgView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:bgView];
        self.status=DropItemStatusType_nomarl;
    }
    return self;
}
-(void)setStatus:(DropItemStatusType)status
{
    _status=status;
    if (_status==DropItemStatusType_nomarl)
    {
        [bgView setImage:[UIImage imageNamed:@"placeholder_nomarl.png"]];
    }
    else if (_status==DropItemStatusType_active)
    {
        [bgView setImage:[UIImage imageNamed:@"placeholder_active.png"]];
    }
    [[bgView superview] sendSubviewToBack:self];
}

@end
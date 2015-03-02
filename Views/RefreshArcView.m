//
//  RefreshArcView.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-5.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "RefreshArcView.h"
#import <QuartzCore/QuartzCore.h>

@interface RefreshArcView()
{
    float x;
    float y;
    float r;
    float stroke;
}
-(void)drawBgArc;
-(void)drawProcessArc;
@end
@implementation RefreshArcView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        x=frame.size.width*0.5;
        y=frame.size.height*0.5;
        stroke=1.0;
        r=x>y?y:x;
        r-=stroke;
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

-(void)setProcess:(float)process
{
    if (process>100) {
        return;
    }
    _process=process;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect
{
    [self drawBgArc];
    [self drawProcessArc];

}
-(void)drawBgArc
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,0.8,0.8,0.8,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, stroke);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, x,y, r, 0.02*M_PI, 2*M_PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}
-(void)drawProcessArc
{
    CGFloat angle=2*M_PI*self.process*0.01;
    if (angle==0) {
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,40.0/255,135.0/255,194.0/255,1.0);//画笔线的颜色
    CGContextSetLineWidth(context, stroke);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    CGContextAddArc(context, x,y, r, 0.02*M_PI, angle, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathStroke); //绘制路径
}

@end

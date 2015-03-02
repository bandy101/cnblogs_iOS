//
//  Common.h
//  NewsBrowser
//
//  Created by Ethan on 13-10-31.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JSON.h"

// NSlog自定义
#define ISShow_NSLog 1  //发布时注释

#ifdef ISShow_NSLog
#define NSLogEx(format, ...)  \
NSLog(@"file:%s line:%d\nNSLog:"format,strrchr(__FILE__,'/'),__LINE__, ## __VA_ARGS__)
#else
#define NSLogEx(format, ...)
#endif

//沙箱路径
#define k_DocumentsPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0]

@interface Common : NSObject
/*!
 *  当前IOS版本
 *
 *  @return 5.0,7.0
 */
+(float)IOSVersion;
+(BOOL)isIOS7;
/*!
 *  16进制颜色转化为uicolor
 *
 *  @param hexColor #ffffff
 *
 *  @return uicolor
 */
+(UIColor *)translateHexStringToColor:(NSString *)hexColor;
/*!
 *  得到ios7以下的页面高度  非表格
 *
 *  @param bounds <#bounds description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
+(CGRect)resizeViewBounds:(CGRect)bounds withNavBarHeight:(float)height;
/*!
 *   得到ios7以下的页面高度  表格
 *
 *  @param bounds <#bounds description#>
 *  @param height <#height description#>
 *
 *  @return <#return value description#>
 */
+(CGRect)resizeViewBoundsforTable:(CGRect)bounds withNavBarHeight:(float)height;
/*!
 *  读取本地路径文件
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)readLocalString:(NSString *)path;
/*!
 *  字符串写到本地文件
 *
 *  @param str  <#str description#>
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)writeString:(NSString *)str toPath:(NSString *)path;
/*!
 *  文件是否存在
 *
 *  @param path <#path description#>
 *
 *  @return <#return value description#>
 */
+(BOOL)fileExists:(NSString *)path;
/*!
 *  先从path读，读不到再从paths读取
 *
 *  @param path  <#path description#>
 *  @param path2 <#path2 description#>
 *
 *  @return <#return value description#>
 */
+(NSString *)readLocalString:(NSString *)path secondPath:(NSString *)paths;
/*!
 *  根据view 查找viewcontroller
 *
 *  @return <#return value description#>
 */
+(UIViewController *)viewControllerContainView:(UIView *)view;
/*!
 *  格式化时间日期
 *
 *  @param date   <#date description#>
 *  @param format yyyyMMddHHmmssSSS
 *
 *  @return <#return value description#>
 */
+(NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format;
@end

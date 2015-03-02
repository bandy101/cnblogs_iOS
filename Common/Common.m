//
//  Common.m
//  NewsBrowser
//
//  Created by Ethan on 13-10-31.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "Common.h"

@implementation Common
+(float)IOSVersion
{
    static float _iOSVersion;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _iOSVersion=[[[UIDevice currentDevice] systemVersion] floatValue];
    });
    return _iOSVersion;
}
+(BOOL)isIOS7
{
    if ([Common IOSVersion]>=7.0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
+(UIColor *)translateHexStringToColor:(NSString *)hexColor
{
    NSString *cString = [[hexColor stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([cString length] < 6) return [UIColor blackColor];
    
    if ([cString hasPrefix:@"0X"])  cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])   cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rColorValue = [cString substringWithRange:range];
    range.location = 2;
    NSString *gColorValue = [cString substringWithRange:range];
    range.location = 4;
    NSString *bColorValue = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rColorValue] scanHexInt:&r];
    [[NSScanner scannerWithString:gColorValue] scanHexInt:&g];
    [[NSScanner scannerWithString:bColorValue] scanHexInt:&b];
    return [UIColor colorWithRed:((CGFloat) r / 255.0f) green:((CGFloat) g / 255.0f) blue:((CGFloat) b / 255.0f) alpha:1.0f];
}
+(CGRect)resizeViewBounds:(CGRect)bounds withNavBarHeight:(float)height
{
    if ([Common isIOS7]) {
        
        return CGRectMake(bounds.origin.x, bounds.origin.y+height+20, bounds.size.width,  bounds.size.height-height-20);
    }
    else
    {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height-height);
    }
}
+(CGRect)resizeViewBoundsforTable:(CGRect)bounds withNavBarHeight:(float)height
{
    if ([Common isIOS7]) {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width,  bounds.size.height);
    }
    else
    {
        return CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, bounds.size.height-height);
    }
}
+(NSString *)readLocalString:(NSString *)path
{
    if (![Common fileExists:path]) {
        return @"";
    }
    NSError *error=nil;
	NSString *content=[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        NSLogEx(@"read '%@' error",path);
    }
	return content;
}
+(BOOL)writeString:(NSString *)str toPath:(NSString *)path
{

    NSError *error=nil;
	NSString *floder=[path substringToIndex:[path rangeOfString:@"/" options:NSBackwardsSearch ].location];
	NSFileManager *fileManger=[NSFileManager defaultManager];
	if (![fileManger fileExistsAtPath:floder] ) {
		[fileManger createDirectoryAtPath:floder withIntermediateDirectories:YES attributes:nil error:&error];
	}
	return [str writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:&error];
}
+(BOOL)fileExists:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path isDirectory:nil])
        return YES;
    else
        return NO;
}
+(NSString *)readLocalString:(NSString *)path secondPath:(NSString *)paths
{
    NSString *content=[Common readLocalString:path];
    if (content.length==0) {
        content=[Common readLocalString:paths];
    }
    return content;
}
+(UIViewController *)viewControllerContainView:(UIView *)view
{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}
+(NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)format
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息 +0000。
    [dateFormatter setDateFormat:format];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
    
}
@end

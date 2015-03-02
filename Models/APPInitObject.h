//
//  APPInitObject.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-22.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//
/*!
 *  配置类，和网络的同步
 */
#import <Foundation/Foundation.h>
#import "CategoryObject.h"


@interface  VersionInfo: NSObject
@property(nonatomic,strong) NSString *version;
@property(nonatomic,strong) NSString *note;
@property(nonatomic,strong) NSString *URL;
@end
@interface LoadingInfo : NSObject
@property(nonatomic,strong) NSString *version;
@property(nonatomic,strong) NSString *link;
@property(nonatomic,strong) NSString *img;
@end

typedef enum
{
    APIType_body,
    APIType_comment,
    APIType_authors,
    APIType_searchauthor,
    APIType_authorhome
}APIType;

@interface APPInitObject : NSObject
/*!
 *  初始化加载图片信息
 */
@property(nonatomic,strong) LoadingInfo *loading;
/*!
 *  最新应用版本信息
 */
@property(nonatomic,strong) VersionInfo *version;
/*!
 *  分类信息
 */
@property(nonatomic,strong) NSArray *categorys;
/*!
 *  显示的分类
 */
@property(nonatomic,strong) NSArray *categorysShow;
@property(nonatomic,strong) NSArray *categoryHide;
/*!
 *  网络请求api
 */
@property(nonatomic,strong) NSDictionary *API;
/*!
 *  首页分类
 */
@property(nonatomic,strong) NSArray *indexsCategorys;

@property(nonatomic,strong) NSString *postListID;
@property(nonatomic,strong) NSString *postListClass;
@property(nonatomic) int postListIndex;
@property(nonatomic,strong) NSString *postListHandlerJS;
@property(nonatomic,strong) NSString *postListHandlerJSURL;

+(APPInitObject *)share;
-(void)initWithJsonString:(NSDictionary *)json;
-(NSString *)APIForType:(APIType)type;
-(NSDictionary *)XPathForType:(APIType)type;
@end

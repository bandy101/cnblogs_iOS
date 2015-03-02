//
//  Config.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-18.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "Common.h"
#import "JSON.h"
#ifndef NewsBrowser_Config_h
#define NewsBrowser_Config_h


//应用初始化启动图片
#define k_defaultLoadingImage @"Default-568h.png"
//应用初始化网址
#define k_initUrl @"http://files.cnblogs.com/bandy/initjsontxtNew.xml"
//loaing信息本地路径
#define k_LoadingPath [k_DocumentsPath stringByAppendingString:@"/loading"]
#define k_LoadingjsonPath [k_DocumentsPath stringByAppendingString:@"/loading/loading.txt"]

//分类显示排序存放
#define k_categoryShowPath [k_DocumentsPath stringByAppendingString:@"/categoryShowOrder.json"]
#define k_categoryShowPath2 [[NSBundle mainBundle] pathForResource:@"categoryShowOrder" ofType:@"txt"]

//本地数据库存放位置
#define k_sqliteDBPath [k_DocumentsPath stringByAppendingString:@"/blog.db"]

#define k_NavBarBGColor @"#2887c2"
#endif

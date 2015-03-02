//
//  CategoryObject.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-22.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryObject : NSObject
@property(nonatomic,strong) NSString *categoryName;
@property(nonatomic,assign) int categoryID;
@property(nonatomic,assign) BOOL categoryIsShow;
@property(nonatomic,strong) NSString *categoryAccept;
@property(nonatomic,strong) NSString *categoryURL;
@property(nonatomic,strong) NSDictionary *categoryPostDic;
@end

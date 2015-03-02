//
//  PostObject.h
//  NewsBrowser
//
//  Created by Ethan on 13-11-26.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostObject : NSObject
@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *digg;
@property (nonatomic,strong) NSString *author;
@property (nonatomic,strong) NSString *url;
@property (nonatomic,strong) NSNumber *comment;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *header;
@property (nonatomic,strong) NSString *summary;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSNumber *view;
@property (nonatomic,strong) NSString *authorID;
@property(nonatomic) BOOL isReaded;
-(id)initWithJson:(NSDictionary *)json;
+(NSArray *)initArrayWithJson:(NSArray *)json;
@end

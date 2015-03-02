//
//  AuthorObject.h
//  NewsBrowser
//
//  Created by Ethan on 13-12-20.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorObject : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *url;
@property(nonatomic,strong) NSString *header;
@property(nonatomic,strong) NSString *updated;
@property(nonatomic,strong) NSString *ID;
@property(nonatomic,strong) NSString *count;
@property(nonatomic,strong) NSString *lastedTitle;
@property(nonatomic,strong) NSString *lastedComment;
@end

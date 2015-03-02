//
//  PostObject.m
//  NewsBrowser
//
//  Created by Ethan on 13-11-26.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "PostObject.h"

@implementation PostObject

-(id)initWithJson:(NSDictionary *)json;
{
    self = [super init];
    if(self)
    {
        if(json != nil)
        {
            self.ID  = [json objectForKey:@"ID"];
            self.digg  = [json objectForKey:@"digg"];
            self.author  = [json objectForKey:@"author"];
            self.url  = [json objectForKey:@"url"];
            self.comment  = [json objectForKey:@"comment"];
            self.title  = [json objectForKey:@"title"];
            self.header  = [json objectForKey:@"header"];
            self.summary  = [json objectForKey:@"summary"];
            self.date  = [json objectForKey:@"date"];
            self.view  = [json objectForKey:@"view"];
            self.authorID  = [json objectForKey:@"authorID"];
            
        }
    }
    return self;
}
+(NSArray *)initArrayWithJson:(NSArray *)json
{
    NSMutableArray *objArr=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in json) {
        PostObject *postObj=[[PostObject alloc] initWithJson:dic];
        [objArr addObject:postObj];
        postObj=nil;
    }
    NSArray *result=[NSArray arrayWithArray:objArr];
    return result;
}
@end

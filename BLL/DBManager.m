//
//  DBManager.m
//  NewsBrowser
//
//  Created by Ethan on 13-12-17.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "DBManager.h"
#import "SQLiteDBOperationObject.h"
#import "Config.h"
#import "PostObject.h"
#import "AuthorObject.h"
@interface DBManager()
{
    SQLiteDBOperationObject *dbOperation;
}
@end
@implementation DBManager
-(id)init
{
    if (self=[super init]) {
        BOOL exist=NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:k_sqliteDBPath]) {
            exist=YES;
        }
        dbOperation=[[SQLiteDBOperationObject alloc] init];
        dbOperation.dataBasePath=k_sqliteDBPath;
        [dbOperation open]; //只打开一次
        if (!exist) {
            [self create];
        }
    }
    return self;
}
+(DBManager *)share
{
    static DBManager *_share=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _share=[[DBManager alloc] init];
    });
    return _share;
}
//创建表
-(void)create
{

    NSString *sqlStr=@"Create Table if not exists \
    FavoritesPost \
    (               \
        ID          nvarchar(50) PRIMARY KEY NOT NULL,\
        title       nvarchar(100), \
        digg        nvarchar(10),\
        author      nvarchar(50),\
        url         nvarchar(100),\
        comment     nvarchar(10),\
        header      nvarchar(200),\
        date        date,\
        view        nvarchar(10),\
        authorID    nvarchar(50),\
        summary     nvarchar(300)\
    );\
    Create Table if not exists \
    Authors \
    (               \
         ID          nvarchar(50) PRIMARY KEY NOT NULL,\
         name       nvarchar(50), \
         url        nvarchar(100),\
         header      nvarchar(100),\
         updated       nvarchar(50),\
         count     nvarchar(10)\
    );";
    /*
    Create Table if not exists  \
    chats \
    (\
    uid         nvarchar(100) PRIMARY KEY NOT NULL,\
    userId      nvarchar(100), \
    msg         text,\
    direction   nvarchar(10),\
    dateTime    date,\
    isReaded    INTEGER,\
    receipt     INTEGER,\
    receiptTime date\
    );\
    Create Table if not exists\
    friends( \
    userId          nvarchar(100) PRIMARY KEY NOT NULL,\
    nickName        nvarchar(100), \
    faceUrl         nvarchar(100),\
    country         nvarchar(100),\
    sex             nvarchar(10),\
    birthday        date,\
    createTime      date,\
    msgTime         date,\
    msg             text\
    );\
    Create Table if not exists\
    inviters( \
    senderId          nvarchar(100) PRIMARY KEY NOT NULL,\
    senderNickName    nvarchar(100), \
    senderFaceUrl     nvarchar(100),\
    senderCountry     nvarchar(100),\
    senderSex         nvarchar(10),\
    senderBirthday    date,\
    senderDateTime    date,\
    dateTime          date,\
    des               nvarchar(200)\
    );";
     */
    if (dbOperation) {
        [dbOperation executeWithSQLString:sqlStr];
    }
}
#pragma -
#pragma 收藏表操作
-(NSArray *)selectPostFavs
{
    NSString *sqlstr=@"select * from FavoritesPost";
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in result) {
        PostObject *obj=[[PostObject alloc] init];
        obj.ID=[NSNumber numberWithInt:[[dic objectForKey:@"ID"] intValue]];
        obj.digg=[NSNumber numberWithInt:[[dic objectForKey:@"digg"] intValue]];
        obj.author=[dic objectForKey:@"author"];
        obj.url=[dic objectForKey:@"url"];
        obj.comment=[NSNumber numberWithInt:[[dic objectForKey:@"comment"] intValue]];
        obj.title=[dic objectForKey:@"title"];
        obj.header=[dic objectForKey:@"header"];
        obj.summary=[dic objectForKey:@"summary"];
        obj.date=[dic objectForKey:@"date"];
        obj.view=[NSNumber numberWithInt:[[dic objectForKey:@"view"] intValue]];
        obj.authorID=[dic objectForKey:@"authorID"];
        [array addObject:obj];
    }
    NSArray *returnArr=[NSArray arrayWithArray:array];
    return returnArr;
}
-(BOOL)insertPostToFavorites:(PostObject *)postObj
{
  NSString  *sqlstr=[NSString stringWithFormat:@"insert into FavoritesPost\
            (ID,title,digg,author,url,comment,header,view,authorID,summary,date)\
            values('%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@');",
            postObj.ID,
            postObj.title,
            postObj.digg,
            postObj.author,
            postObj.url,
            postObj.comment,
            postObj.header,
            postObj.view,
            postObj.authorID,
            postObj.summary,
            postObj.date];
    return [dbOperation executeWithSQLString:sqlstr];
}
-(BOOL)postIsInFavorites:(NSString *)postID
{
    NSString *sqlstr=[NSString stringWithFormat:@"select ID from FavoritesPost where ID='%@'",postID];
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    if (result.count==0) {
        return NO;
    }
    return YES;
}
-(BOOL)delPostFromFavorites:(NSString *)postID
{
    NSString *sqlstr=[NSString stringWithFormat:@"delete from FavoritesPost where ID='%@'",postID];
    return [dbOperation executeWithSQLString:sqlstr];
}
#pragma 订阅作者操作
-(BOOL)authorIsInFavorites:(NSString *)authorID
{
    NSString *sqlstr=[NSString stringWithFormat:@"select ID from Authors where ID='%@'",authorID];
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    if (result.count==0) {
        return NO;
    }
    return YES;
}
-(NSArray *)selectAuthors
{
    NSString *sqlstr=@"select * from Authors";
    NSArray *result=[dbOperation selectWithSQLString:sqlstr];
    NSMutableArray *array=[[NSMutableArray alloc] init];
    for (NSDictionary *dic in result) {
        AuthorObject *obj=[[AuthorObject alloc] init];
        obj.ID=[dic objectForKey:@"ID"];
        obj.name=[dic objectForKey:@"name"];
        obj.url=[dic objectForKey:@"url"];
        obj.header=[dic objectForKey:@"header"];
        obj.updated=[dic objectForKey:@"updated"];
        obj.count=[dic objectForKey:@"count"];
        [array addObject:obj];
    }
    NSArray *returnArr=[NSArray arrayWithArray:array];
    return returnArr;
}
-(BOOL)insertAuthor:(AuthorObject *)authorObj
{
    NSString  *sqlstr=[NSString stringWithFormat:@"insert into Authors\
                       (ID,name,url,header,updated,count)\
                       values('%@','%@','%@','%@','%@','%@');",
                       authorObj.ID,
                       authorObj.name,
                       authorObj.url,
                       authorObj.header,
                       authorObj.updated,
                       authorObj.count];
    return [dbOperation executeWithSQLString:sqlstr];
}
-(BOOL)delAuthor:(NSString *)authorID
{
    NSString *sqlstr=[NSString stringWithFormat:@"delete from Authors where ID='%@'",authorID];
    return [dbOperation executeWithSQLString:sqlstr];

}
@end

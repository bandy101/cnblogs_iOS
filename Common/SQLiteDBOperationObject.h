//
//  SQLiteDBOperationObject.h
//  versionTest
//
//  Created by Ethan on 13-7-4.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
@interface SQLiteDBOperationObject : NSObject
{
    sqlite3 *hSqlite3DB;
    NSString *dataBasePath;
}
@property(nonatomic,strong) NSString *dataBasePath;
-(BOOL)open;//打开数据库
-(BOOL)close;//关闭数据库
-(BOOL)executeWithSQLString:(NSString *)sqlstr;
-(BOOL)executeWithSQLArray:(NSArray *)sqlArr;
-(NSArray *)selectWithSQLString:(NSString *)sqlstr;
@end

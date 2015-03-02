//
//  SQLiteDBOperationObject.m
//  versionTest
//
//  Created by Ethan on 13-7-4.
//  Copyright (c) 2013年 Ethan. All rights reserved.
//

#import "SQLiteDBOperationObject.h"

@implementation SQLiteDBOperationObject
@synthesize dataBasePath;

-(void)dealloc
{
    if (hSqlite3DB)
	{
		[self close];
	}

}


-(BOOL)open
{
    if (self.dataBasePath==nil) {
        //NSLog(@"database path is null");
        return NO;
    }
    sqlite3_shutdown();
    //NSLog(@"sqlite3 lib version: %s", sqlite3_libversion());
    //提供数据库串行操作，优点：多线程使用，缺点：不能使用回滚
    int err=sqlite3_config(SQLITE_CONFIG_SERIALIZED);
    if (err == SQLITE_OK) {
        //NSLog(@"Can now use sqlite on multiple threads, using the same connection");
    } else {
        //NSLog(@"setting sqlite thread safe mode to serialized failed!!! return code: %d", err);
    }
    err = sqlite3_open([self.dataBasePath UTF8String], &hSqlite3DB);
    if(err != SQLITE_OK) {
        //NSLog(@"datebase open error: %d", err);
        return NO;
    }
	return YES;
}
-(BOOL)close
{
	if (hSqlite3DB) {
		int err=sqlite3_close(hSqlite3DB);
        if (err==SQLITE_OK) {
           // NSLog(@"closedb-----%d",err);
            hSqlite3DB=nil;
            self.dataBasePath=nil;
        }
        else
        {
            return NO;
        }
        
	}
    
    return YES;
}
-(BOOL)executeWithSQLString:(NSString *)sqlstr
{
    NSArray *array=[NSArray arrayWithObjects:sqlstr, nil];
    return [self executeWithSQLArray:array];
}
-(BOOL)executeWithSQLArray:(NSArray *)sqlArr
{
    
    
    char *errMsg;
    
    for (int i=0; i<[sqlArr count]; i++) {
        NSString *sqlStr=[sqlArr objectAtIndex:i];
        if (sqlite3_exec(hSqlite3DB, [sqlStr UTF8String], NULL, NULL, &errMsg) != SQLITE_OK)
        {
            //NSLog(@"Thread---%@---sqlite3_errmsg(3): %s",[NSThread currentThread],errMsg);
            sqlite3_free(errMsg);
            return NO;
        }
        sqlite3_free(errMsg);
    }
    
    return YES;
    
}
-(NSArray *)selectWithSQLString:(NSString *)sqlstr;
{
    sqlite3_stmt *statement;
	
	int ok=0;
	ok=sqlite3_prepare_v2(hSqlite3DB, [sqlstr UTF8String], -1, &statement, nil);
	if (ok>0) {
		//NSLog(@"ok-----%d--sqlite error",ok);
	}
	
	
	
    NSMutableArray *array=[[NSMutableArray alloc] init];
    int columnCount=sqlite3_column_count(statement);
    while (sqlite3_step(statement)==SQLITE_ROW) {
        NSMutableDictionary *dic=[[NSMutableDictionary alloc] init];
        for (int i=0; i<columnCount; i++) {
			
            NSString *value=[NSString stringWithCString:(const char *)sqlite3_column_text(statement, i) encoding:NSUTF8StringEncoding];
            if ([value isEqualToString:@"(null)"]) {
                value=@"";
            }
            
            NSString *key=[NSString stringWithCString:(const char *)sqlite3_column_name(statement, i) encoding:NSUTF8StringEncoding];
            int type= sqlite3_column_type(statement, i);
            if (type==1) {
                [dic setObject:[NSNumber numberWithInt:[value intValue]] forKey:key];
            }
            else
            {
                [dic setObject:value forKey:key];
            }
            
			
        }
        [array addObject:dic];
    }
    
    sqlite3_finalize(statement);
    
    NSArray *returnArray=[NSArray arrayWithArray:array];
    return returnArray;
}

@end

//
//  DBManager.m
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import "DBManager.h"
@interface DBManager()
{
    sqlite3 *database;
    NSString *dbPath;
}
@end

@implementation DBManager

@synthesize dbName = _dbName;
@synthesize tableName = _tableName;

-(id)initWithDBName:(NSString*) dname andTableName: (NSString*) tname
{
    if (self = [super init]) {
        
        _dbName = dname;
        _tableName = tname;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
        dbPath = [[paths objectAtIndex:0]stringByAppendingPathComponent:_dbName];
        
        NSFileManager *fileManager=[NSFileManager defaultManager];
        BOOL find=[fileManager fileExistsAtPath:dbPath];
        
        if(!find){
            
//            NSLog(@"Database not found!");
            [self openDB];

            NSString *sqlCreateTable = @"CREATE TABLE earthquake (id INTEGER PRIMARY KEY AUTOINCREMENT,magnitude TEXT, datetime TEXT,latitude TEXT, longitude TEXT, depth TEXT, location TEXT)";
        
            [self execSql:sqlCreateTable];
            
//            NSLog(@"Table Created!");

            [self closeDB];
        }
        
    }
    
    return self;
}


-(void) query:(NSMutableArray *)result
{
    [result removeAllObjects];
    sqlite3_stmt *stmt;
    [self openDB];
    NSString * sqlQuery = @"SELECT * FROM earthquake";
    if(sqlite3_prepare_v2(database, [sqlQuery UTF8String], -1, &stmt, NULL)==SQLITE_OK){
        while (sqlite3_step(stmt) == SQLITE_ROW){            
            Record * rec = [[Record alloc] init];
            rec.magnitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 1)];
            rec.datetime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 2)];
            rec.latitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 3)];
            rec.longitude = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 4)];
            rec.depth = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 5)];
            rec.location = [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, 6)];            
            [result addObject:rec];
        }
    }
    sqlite3_finalize(stmt);
    [self closeDB];
}


-(void)insertRecord:(Record *)rec
{
    NSString *sqlInsert = [NSString stringWithFormat:
                      @"INSERT INTO earthquake('magnitude','datetime','latitude','longitude','depth','location')  VALUES ('%@', '%@', '%@', '%@', '%@', '%@')",
                      rec.magnitude,rec.datetime,rec.latitude,rec.longitude,rec.depth,rec.location];
    [self execSql:sqlInsert];

    
}


-(void)deleteAll
{
    [self openDB];
    NSString *sqlDelete =@"delete from earthquake";
    [self execSql:sqlDelete];
    [self closeDB];
}


-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(database, [sql UTF8String], NULL, NULL, &err) == SQLITE_OK) {
//        NSLog(@"SQL executed!");
    } else{
        NSLog(@"%s",err);
    }
}


-(void) openDB
{
    if(dbPath){
        if (sqlite3_open([dbPath UTF8String], &database)==SQLITE_OK) {
//            NSLog(@"Database Opened!");
        } else{
            NSLog(@"Please name a database!");
        }
    }
}


-(void) closeDB
{
    if(sqlite3_close(database)==SQLITE_OK){
//         NSLog(@"Database closed!");
    }
}

@end

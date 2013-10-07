//
//  DBManager.h
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Record.h"

@interface DBManager : NSObject

@property (copy, nonatomic) NSString *dbName;
@property (copy, nonatomic) NSString *tableName;

-(id)initWithDBName:(NSString*) dname andTableName: (NSString*) tname;

-(void)openDB;

-(void)closeDB;

-(void)query:(NSMutableArray*) result;

-(void)insertRecord:(Record *) rec;

-(void)deleteAll;

@end

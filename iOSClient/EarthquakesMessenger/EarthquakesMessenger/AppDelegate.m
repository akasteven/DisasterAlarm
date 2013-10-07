//
//  AppDelegate.m
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import "AppDelegate.h"
#import "Record.h"
#import "DBManager.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
//    DBManager * db = [[DBManager alloc] initWithDBName:@"disaster.db" andTableName:@"testtable"];
//    
//    [db deleteAll];
//    Record * rec = [[Record alloc] init];
//    rec.magnitude = @"10.0";
//    rec.datetime = @"2222-09-08 22:22:22";
//    rec.latitude = @"45.5";
//    rec.longitude = @"89.7";
//    rec.depth = @"24";
//    rec.location = @"Japan";
//    [db openDB];
//    [db insertRecord:rec];
//    [db closeDB];

//    NSMutableArray *result = [[NSMutableArray alloc] init];
//    [db query:result];
//    for(Record *r in result)
//    {
//        NSLog(@"%@,%@,%@,%@",r.datetime,r.location,r.magnitude,r.depth);
//    }
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

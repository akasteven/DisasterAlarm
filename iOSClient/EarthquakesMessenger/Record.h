//
//  Record.h
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject

@property (nonatomic,copy) NSString * magnitude;
@property (nonatomic,copy) NSString * datetime;
@property (nonatomic,copy) NSString * latitude;
@property (nonatomic,copy) NSString  *longitude;
@property (nonatomic,copy) NSString *location;
@property (nonatomic,copy) NSString * depth;


-(id) initWithMagnitude:(NSString *)mag datetime:(NSString*)dt latitude: (NSString *)lat longitude:(NSString *) longi depth:(NSString *) dep location:(NSString *) loc;

@end

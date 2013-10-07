//
//  Record.m
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import "Record.h"

@implementation Record
@synthesize depth = _depth;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize location = _location;
@synthesize magnitude = _magnitude;
@synthesize datetime = _datetime;



-(id) initWithMagnitude:(NSString *)mag datetime:(NSString*)dt latitude: (NSString *)lat longitude:(NSString * ) longi depth:(NSString *) dep location:(NSString *) loc
{
    if(self = [super init])
    {
        _magnitude = mag;
        _datetime = dt;
        _latitude = lat;
        _longitude = longi;
        _depth = dep;
        _location = loc;
    }
    return self;
}

@end

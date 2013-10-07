//
//  MapVC.h
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-3.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Record.h"
#import "CustomLocationAnnotation.h"

@interface MapVC : UIViewController <MKMapViewDelegate>

@property(nonatomic, copy) Record *recordToShow;
@property (nonatomic, strong) CustomLocationAnnotation* locationAnnotation;

- (id)initWithRecord:(Record *) rec;

@end

//
//  MapVC.m
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-3.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import "MapVC.h"

@interface MapVC ()
{
    MKMapView *map;
    CLLocationCoordinate2D coords;
}
@end



@implementation MapVC

@synthesize recordToShow = _recordToShow;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (id)initWithRecord:(Record *) rec
{
    if(self = [super init]){
        _recordToShow = rec;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"地震位置";

    map = [[MKMapView alloc] initWithFrame:[self.view bounds]];
    map.showsUserLocation = YES;
    map.mapType = MKMapTypeStandard;
    map.delegate = self;
    [self.view addSubview:map];

    [self locate];    
    [self showAnnotation];
}

- (void)locate
{
    
    coords = CLLocationCoordinate2DMake([[_recordToShow latitude] doubleValue],[[_recordToShow longitude] doubleValue]);
    float zoomLevel = 10.0;
    MKCoordinateRegion region = MKCoordinateRegionMake(coords, MKCoordinateSpanMake(zoomLevel, zoomLevel));
    [map setRegion:[map regionThatFits:region] animated:YES];
}


//- (void) showAnnotation
//{
//    CustomAnnotation *annotation = [[CustomAnnotation alloc] initWithCoordinates:coords title:_recordToShow.location subTitle:_recordToShow.datetime];
//    [map addAnnotation:annotation];
//    
//}

- (void) showAnnotation
{
    self.locationAnnotation = [[CustomLocationAnnotation alloc] initWithLat:coords.latitude lon:coords.longitude andRecord:[self recordToShow]];
    [map addAnnotation:self.locationAnnotation];
    self.locationAnnotation.mapView = map;
    
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)aMapView didSelectAnnotationView:(MKAnnotationView *)view {
    if([view conformsToProtocol:@protocol(CustomAnnotationViewProtocol)]) {
        [((NSObject<CustomAnnotationViewProtocol>*)view) didSelectAnnotationViewInMap:map];
    }
}

- (void)mapView:(MKMapView *)aMapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if([view conformsToProtocol:@protocol(CustomAnnotationViewProtocol)]) {
        [((NSObject<CustomAnnotationViewProtocol>*)view) didDeselectAnnotationViewInMap:map];
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)aMapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if([annotation conformsToProtocol:@protocol(CustomAnnotationProtocol)]) {
        return [((NSObject<CustomAnnotationProtocol>*)annotation) annotationViewInMap:map];
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    MKAnnotationView *aV;
    
    for (aV in views) {
        
        if (![aV isKindOfClass:[CustomCalloutView class]]) {
            CGRect endFrame = aV.frame;
            
            aV.frame = CGRectMake(aV.frame.origin.x, aV.frame.origin.y-230.0, aV.frame.size.width, aV.frame.size.height);
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.45];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [aV setFrame:endFrame];
            [UIView commitAnimations];
        }
    }
}


//
//- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
//{
//    static NSString *identifier = @"CustomAnnotation";
//    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
//        CustomAnnotation *annotationView = [map dequeueReusableAnnotationViewWithIdentifier:identifier];
//        if (annotationView == nil) {
//            annotationView = [[CustomAnnotation alloc] initWithCoordinates:coords title:_recordToShow.location subTitle:_recordToShow.datetime];
//        } else {
//            annotationView.annotation = annotation;
//        }
//        annotationView.enabled = YES;
//        annotationView.canShowCallout = YES;
//        
//        return annotationView;
//    }
//    return nil;
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end

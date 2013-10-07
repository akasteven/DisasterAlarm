//
//  CustomLocationView.m
//  CustomCallout
//
//  Created by Jacob Jennings on 9/8/11.
//
//  This is my solution to the SO question "MKAnnotationView - Lock custom annotation view to pin on location updates":
//  http://stackoverflow.com/questions/6392931/mkannotationview-lock-custom-annotation-view-to-pin-on-location-updates
//
//  CalloutAnnotationView based on the work at: 
//  http://blog.asolutions.com/2010/09/building-custom-map-annotation-callouts-part-1/
//  
//  The Custom* classes represent things you will probably change in your own project to fit your needs.  Consider CalloutAnnotationView abstract - it must be subclassed (here it's subclass is CustomCalloutView), and linked with a xib connecting the IBOutlet for contentView.  The callout should resize to fit whatever view you supply as contentView.  

#import "CustomLocationView.h"

@implementation CustomLocationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation andRecord:(Record*) rec
{
    if(!(self = [super initWithAnnotation:annotation reuseIdentifier:@"CustomLocationView"]))
        return nil;
    
    self.canShowCallout = NO;
    self.image = [UIImage imageNamed:@"map_marker.png"];
    self.centerOffset = CGPointMake(10, -16);
    self.draggable = YES;
    record = rec;
    
    return self;
}

- (void)didSelectAnnotationViewInMap:(MKMapView*) mapView;
{
    
    calloutAnnotation = [[CustomCalloutAnnotation alloc] initWithLat:self.annotation.coordinate.latitude lon:self.annotation.coordinate.longitude andRecord:record];
    
    calloutAnnotation.parentAnnotationView = self;
    [mapView addAnnotation:calloutAnnotation];
}

- (void)didDeselectAnnotationViewInMap:(MKMapView*) mapView;
{
    [mapView removeAnnotation:calloutAnnotation];
    calloutAnnotation = nil;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation
{
    if(calloutAnnotation) {
        [calloutAnnotation setCoordinate:annotation.coordinate];
    }
    
    [super setAnnotation:annotation];
}

@end

//
//  CustomCalloutAnnotation.m
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

#import "CustomCalloutAnnotation.h"
#import "CustomCalloutView.h"

@implementation CustomCalloutAnnotation
@synthesize parentAnnotationView, mapView;

- (id) initWithLat:(CGFloat)latitute lon:(CGFloat)longitude andRecord: (Record*) rec;
{
    _coordinate = CLLocationCoordinate2DMake(latitute, longitude);
    record = rec;
    return self;
}

- (MKAnnotationView*)annotationViewInMap:(MKMapView *)aMapView;
{
    if(!calloutView) {
        calloutView = (CustomCalloutView*)[aMapView dequeueReusableAnnotationViewWithIdentifier:@"CustomCalloutView"];
        if(!calloutView)
            calloutView = [[CustomCalloutView alloc] initWithAnnotation:self];
    } else {
        calloutView.annotation = self;
    }
        
    calloutView.parentAnnotationView = self.parentAnnotationView;
    calloutView.datetimeLabel.text = record.datetime;
    
    
    NSString *mag = [[record magnitude] stringByAppendingString:@" 级"];
    calloutView.magnitudeLabel.text = mag;
    
    NSString *dep = [[record depth] stringByAppendingString:@" 千米"];
    calloutView.depthLabel.text = dep;


    NSString *month = [[record datetime] substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [[record datetime] substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [[record datetime] substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [[record datetime] substringWithRange:NSMakeRange(14, 2)];

    NSString *dt = [[NSString alloc] initWithFormat:@"%@月%@日%@时%@分",month,day,hour,minute];
    calloutView.datetimeLabel.text = dt;
    
    
//    CGSize locationLabelSize = [record.location sizeWithFont:[UIFont boldSystemFontOfSize:13.0] constrainedToSize:CGSizeMake(145, 100) lineBreakMode:UILineBreakModeCharacterWrap];
//    
//    CGRect locationLabelRect = CGRectMake(53,97, 145, locationLabelSize.height);
//    NSLog(@"%f %f %f %f",locationLabelRect.origin.x,locationLabelRect.origin.y,locationLabelRect.size.width,locationLabelRect.size.height);
//    
//    calloutView.locationLabel.frame = locationLabelRect;

    calloutView.locationLabel.font = [UIFont boldSystemFontOfSize:13.0];
    calloutView.locationLabel.lineBreakMode = UILineBreakModeCharacterWrap;
    calloutView.locationLabel.numberOfLines = 0;
    calloutView.locationLabel.text = record.location;
    
    
    
    
    return calloutView;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = newCoordinate;
    if(calloutView) {
        [calloutView setAnnotation:self];
    }
}

- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}


@end

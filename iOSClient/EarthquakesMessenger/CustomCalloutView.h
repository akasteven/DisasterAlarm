//
//  CustomCallout.h
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

#import <Foundation/Foundation.h>
#import "CalloutAnnotationView.h"
#import "Record.h"

@interface CustomCalloutView : CalloutAnnotationView {
    
}

@property (nonatomic, strong) IBOutlet UILabel* datetimeLabel;
@property (nonatomic, strong) IBOutlet UILabel* locationLabel;
@property (nonatomic, strong) IBOutlet UILabel* depthLabel;
@property (nonatomic, strong) IBOutlet UILabel* magnitudeLabel;

@property (nonatomic, strong)  UILabel* locationLabel2;



@end

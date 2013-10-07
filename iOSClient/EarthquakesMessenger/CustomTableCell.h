//
//  CustomTableCell.h
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-6.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTableCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *imgView;

@property (strong, nonatomic) IBOutlet UILabel *magLabel;
@property (strong, nonatomic) IBOutlet UILabel *locLabel;
@property (strong, nonatomic) IBOutlet UILabel *datetimeLabel;

@end

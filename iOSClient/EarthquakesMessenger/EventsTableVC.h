//
//  EventsTableVC.h
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"

@interface EventsTableVC : UITableViewController
{
    EGORefreshTableHeaderView *_refreshTableView;
    BOOL _reloading;
}

- (void)reloadTableViewDataSource;

- (void)doneLoadingTableViewData;

@end

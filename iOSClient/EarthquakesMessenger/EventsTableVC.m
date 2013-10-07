//
//  EventsTableVC.m
//  EarthquakesMessenger
//
//  Created by StevenQiu on 13-10-1.
//  Copyright (c) 2013年 Gooding View. All rights reserved.
//

#import "EventsTableVC.h"
#import "DBManager.h"
#import "Record.h"
#import "MapVC.h"
#import "CustomTableCell.h"

@interface EventsTableVC ()
{
    NSMutableArray *displaylist;
    DBManager *db;
}


@end

@implementation EventsTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) getDataFromServer
{
    
    NSURL *url = [NSURL URLWithString:@"http://219.224.167.169:8080/DisasterServer/Service.jsp"];
    NSData * data = [NSData dataWithContentsOfURL:url];
    
    if(data == nil )
        NSLog(@"Unable to fetch data!");
    
    NSError * error;
    NSArray  *JSONData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    [db deleteAll];
    [db openDB];
    for(NSDictionary *json in JSONData){
        
        Record * rec  = [[Record alloc] init];
        
        rec.magnitude = [json objectForKey:@"magnitude"];
        rec.datetime  = [json objectForKey:@"datetime"];
        rec.latitude  = [json objectForKey:@"latitude"];
        rec.longitude = [json objectForKey:@"longitude"];
        rec.depth     = [json objectForKey:@"depth"];
        rec.location  = [json objectForKey:@"location"];
        
        rec.longitude = [self checkPrecisionOf: rec.longitude];
        rec.latitude  = [self checkPrecisionOf:rec.latitude];
        rec.magnitude = [self checkPrecisionOf:rec.magnitude];
        
        [db insertRecord:rec];
    }
    [db closeDB];
}


- (NSString *) checkPrecisionOf:(NSString *) doubleValueString
{
    NSString * res = [NSString stringWithFormat:@"%.1f",[doubleValueString doubleValue]];
    return res;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"最近地震消息";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"最近地震" style:UIBarButtonItemStyleDone target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    
    
    if (_refreshTableView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        refreshView.delegate = self;

        [self.tableView addSubview:refreshView];
        _refreshTableView = refreshView;
    }
    
    
    db = [[DBManager alloc] initWithDBName:@"disaster.db" andTableName:@"testtable"];
    displaylist = [[NSMutableArray alloc] init];
//    [self getDataFromServer];
    [db query:displaylist];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [displaylist count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    CustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[CustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Record *rec = [displaylist objectAtIndex:[indexPath section]];
    
    NSString *datetime = [rec datetime];
    
    NSString *month = [datetime substringWithRange:NSMakeRange(5, 2)];
    NSString *day = [datetime substringWithRange:NSMakeRange(8, 2)];
    NSString *hour = [datetime substringWithRange:NSMakeRange(11, 2)];
    NSString *minute = [datetime substringWithRange:NSMakeRange(14, 2)];
    
    cell.magLabel.text = [rec magnitude];
    cell.datetimeLabel.text = [[NSString alloc] initWithFormat:@"%@月%@日%@时%@分",month,day,hour,minute];
    cell.locLabel.text = [rec location];
    
    CGFloat mag = [[rec magnitude] doubleValue];
    NSString *imgName;
    if(mag >= 8.0)
        imgName = @"9.png";
    else if(mag >= 6.0)
        imgName = @"7.png";
    else if(mag >= 4.0)
        imgName = @"5.png";
    else if(mag >= 2.0)
        imgName = @"3.png";
    else
        imgName = @"1.png";
    
    cell.imgView.image = [UIImage imageNamed:imgName];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Record * recordToPass = [displaylist  objectAtIndex:[indexPath section]];
    MapVC *map = [[MapVC alloc] initWithRecord:recordToPass];
    
    [self.navigationController pushViewController:map animated:YES];
}


#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
    [NSThread detachNewThreadSelector:@selector(doInBackground) toTarget:self withObject:nil];
}

- (void)doneLoadingTableViewData{
    NSLog(@"doneLoadingTableViewData");
    
    _reloading = NO;
    [_refreshTableView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark Background operation

-(void)doInBackground
{
    NSLog(@"doInBackground");
    
    [self getDataFromServer];
    [db query:displaylist];
    [NSThread sleepForTimeInterval:3];
    
    [self performSelectorOnMainThread:@selector(doneLoadingTableViewData) withObject:nil waitUntilDone:YES];
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    [self reloadTableViewDataSource];
}

-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshTableView egoRefreshScrollViewDidScroll:scrollView];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_refreshTableView egoRefreshScrollViewDidEndDragging:scrollView];
}

@end

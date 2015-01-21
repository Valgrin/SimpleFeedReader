//
//  ViewController.h
//  SimpleFeedReader
//
//  Created by Thomas LEVY on 14/01/15.
//  Copyright (c) 2015 Thomas LEVY. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *feedURL = @"http://www.fandango.com/rss/newmovies.rss";
static NSString *kMovieCellIdentifier = @"kMovieCellIdentifier";

@interface ViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end


//
//  indexTableViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThreadTableViewController.h"
#import "NSString+CommunicationKF.h"
#import "MessageTableViewController.h"
#import "LoginTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface indexTableViewController : UITableViewController<EGORefreshTableHeaderDelegate>
{
    NSMutableArray *ThreadList;
    ThreadTableViewController *subController;
    MessageTableViewController *messageTable;
    int reloadCount;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

-(void)logout:(id)sender;
-(void)login:(id)sender;
-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;
-(void)loadHTMLContents;

@property(atomic,retain)NSData *index_php_html;
@property(atomic,retain)NSMutableArray *threadParts;
@property(atomic,retain)MessageTableViewController *messageTable;

@end

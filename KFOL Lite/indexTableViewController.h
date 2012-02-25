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
#import "LoginTableView.h"

@interface indexTableViewController : UITableViewController
{
    NSMutableArray *ThreadList;
    ThreadTableViewController *subController;
    MessageTableViewController *messageTable;
    
    int sections;
    int groups;
}

-(void)logout:(id)sender;
-(void)login:(id)sender;

@property(atomic,retain)NSData *index_php_html;
@property(atomic,retain)NSMutableArray *threadParts;
@property(atomic,retain)MessageTableViewController *messageTable;

@end

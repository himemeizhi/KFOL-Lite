//
//  ThreadTableViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostTableViewController.h"
#import "NSString+CommunicationKF.h"
#import "NewTopicViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "NSString+HTML.h"

@interface ThreadTableViewController : UITableViewController
{
    NSMutableDictionary *theThread;
    NSMutableDictionary *subThreadDetails;
    NSData *thread_php_html;
    NSMutableArray *postArray,*headArray,*ThreadPHP;
    PostTableViewController *subController;
    int reloadCount;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

-(id)initWithThreadDictionary:(NSDictionary *)ThreadDetail;
-(void)newTopic;
-(void)loadHTMLContents;

-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@end

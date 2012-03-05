//
//  MessageTableViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/2/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"
#import "MessageReadTableViewController.h"
#import "EGORefreshTableHeaderView.h"

@interface MessageTableViewController : UITableViewController
{
    NSData *message_php_html;
    NSMutableArray *messageArray;
    MessageReadTableViewController *subController;
    BOOL Login,isReceivebox;
    MessageTableViewController *receivebox,*sentbox;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}

-(void)boxChange;
-(void)loadHTMLContents;
-(id)initWithReceiveBox:(BOOL)isRBox;


-(void)reloadTableViewDataSource;
-(void)doneLoadingTableViewData;

@property(atomic)BOOL isReceivebox;
@property(atomic,retain)MessageTableViewController *receivebox;
@property(atomic,retain)MessageTableViewController *sentbox;

@end

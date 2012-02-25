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

@interface MessageTableViewController : UITableViewController
{
    NSData *message_php_html;
    NSMutableArray *messageArray;
    NSString *messageboxType;
    MessageReadTableViewController *subController;
    BOOL Login;
}

-(id)initWithMessagebox:(NSString *)messagebox;

@end

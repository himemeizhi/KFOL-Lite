//
//  MessageReadTableViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/2/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"
#import "ReplyViewController.h"
#import "ReadView.h"

@interface MessageReadTableViewController : UITableViewController
{
    NSDictionary *theMessage;
    NSMutableDictionary *messageDictionary;
    NSInteger messageHeight;
    ReadView *readWebView;
    BOOL isReceivebox;
}

-(id)initWithMessageDictionary:(NSDictionary *)MessageDetail;
-(void)replayMessage:(id)sender;

@property(atomic)BOOL isReceivebox;

@end

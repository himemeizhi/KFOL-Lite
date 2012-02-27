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

@interface ThreadTableViewController : UITableViewController
{
    NSMutableDictionary *theThread;
    NSMutableDictionary *subThreadDetails;
    NSData *thread_php_html;
    NSMutableArray *postArray,*headArray,*ThreadPHP;
    PostTableViewController *subController;    
    
}

-(id)initWithThreadDictionary:(NSDictionary *)ThreadDetail;
-(void)newTopic;

@end

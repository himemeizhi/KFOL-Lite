//
//  NewTopicViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/22/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"

@interface NewTopicViewController : UITableViewController
{
    NSDictionary *threadDictionary;
    UITextField *tileTextField;
    UITextView *contentTextView;
}

@property(atomic,retain)NSDictionary *threadDictionary;

@end

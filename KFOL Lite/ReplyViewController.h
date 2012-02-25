//
//  ReplyViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/10/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"

@interface ReplyViewController : UIViewController
{
    UITextView *textView;
    NSDictionary *replyDictionary;
    NSString *threadFID;
}

@property(atomic,retain)NSDictionary *replyDictionary;
@property(atomic,retain)NSString *threadFID;

@end

//
//  LoginTableView.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/24/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"
#import "MessageTableViewController.h"
#import "indexTableViewController.h"

@interface LoginTableView : UITableViewController
{
    UITextField *UsernameTextField,*passwordTextField;
    MessageTableViewController *messageTable;
    UITableViewController *indexTable;
}

-(id)cancel:(id)sender;
-(id)login:(id)sender;

@property(atomic,retain)MessageTableViewController *messageTable;
@property(atomic,retain)UITableViewController *indexTable;

@end

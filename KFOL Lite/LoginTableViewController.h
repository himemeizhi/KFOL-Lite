//
//  LoginTableViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/26/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"
#import "MessageTableViewController.h"
//#import "indexTableViewController.h"

@interface LoginTableViewController : UITableViewController
{
    UITextField *usernameTextField,*passwordTextField;
    MessageTableViewController *messageTable;
    UITableViewController *indexTable;
}

@property(atomic,retain)MessageTableViewController *messageTable;
@property(atomic,retain)UITableViewController *indexTable;

-(void)login;
-(void)cancel;

@end

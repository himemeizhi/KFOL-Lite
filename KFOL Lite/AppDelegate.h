//
//  AppDelegate.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "indexTableViewController.h"
#import "MessageTableViewController.h"

//#import "NSString+CommunicationKF.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    UITabBarController *TabBarController;
}

@property (strong, nonatomic) UIWindow *window;

@end
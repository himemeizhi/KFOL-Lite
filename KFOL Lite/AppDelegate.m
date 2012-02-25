//
//  AppDelegate.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    //[@"login.php" postWithStringContent:@"pwuser=liumingmou&pwpwd=5914010&step=2" returnResponse:nil error:nil];
    
    //restore cookies
    NSDictionary *rowCookiesToLoad=[[NSUserDefaults standardUserDefaults]objectForKey:@"XD233"];
    for(int n=0;n!=13;n++)
    {
        NSDictionary *cookieDictionaryToLoad=[rowCookiesToLoad valueForKey:[NSString stringWithFormat:@"9gal_%d",n]];
        if(cookieDictionaryToLoad!=nil)
        {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:[NSHTTPCookie cookieWithProperties:cookieDictionaryToLoad]];
        }
        else
            break;        
    }
    //load viewcontroller
    NSMutableArray *rootControllers=[[NSMutableArray alloc]init];

    indexTableViewController *controller=[[indexTableViewController alloc]init];
    controller.tableView.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:controller];
    nav.tabBarItem.title=@"Post";
    [rootControllers addObject:nav];
    
    controller=[[MessageTableViewController alloc]init];
    ((indexTableViewController*)[[nav viewControllers]objectAtIndex:0]).messageTable=controller;
    controller.tableView.backgroundColor=[UIColor colorWithRed:0xf7/255.0 green:0xf7/255.0 blue:1 alpha:1];
    nav=[[UINavigationController alloc]initWithRootViewController:controller];
    nav.tabBarItem.title=@"Message";
    [rootControllers addObject:nav];
    
    TabBarController=[[UITabBarController alloc]init];
    TabBarController.viewControllers=rootControllers;
    TabBarController.delegate=self;
    
    self.window.rootViewController=TabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    //store cookies
    NSArray *allCookies_Terminating=[[NSArray alloc]initWithArray:[[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:@"http://bbs.9gal.com"]]];
    int n=0;
    for(NSHTTPCookie *cookiesToStore_Terminating in allCookies_Terminating)
    {
        NSMutableDictionary *cookieDictionaryToStore_Terminating=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"XD233"]];
        [cookieDictionaryToStore_Terminating setValue:cookiesToStore_Terminating.properties forKey:[NSString stringWithFormat:@"9gal_%d",n]];n++;
        [[NSUserDefaults standardUserDefaults]setObject:cookieDictionaryToStore_Terminating forKey:@"XD233"];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    
    //store cookies
    NSArray *allCookies_Terminating=[[NSArray alloc]initWithArray:[[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:@"http://bbs.9gal.com"]]];
    int n=0;
    for(NSHTTPCookie *cookiesToStore_Terminating in allCookies_Terminating)
    {
        NSMutableDictionary *cookieDictionaryToStore_Terminating=[NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults]dictionaryForKey:@"XD233"]];
        [cookieDictionaryToStore_Terminating setValue:cookiesToStore_Terminating.properties forKey:[NSString stringWithFormat:@"9gal_%d",n]];n++;
        [[NSUserDefaults standardUserDefaults]setObject:cookieDictionaryToStore_Terminating forKey:@"XD233"];
    }
}

@end

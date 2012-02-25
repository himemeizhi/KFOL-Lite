//
//  PostTableViewController.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 1/31/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+CommunicationKF.h"
#import "ReplyViewController.h"
#import "PostReadView.h"

@interface PostTableViewController : UITableViewController
{
    NSMutableDictionary *thePost;
    NSData *post_php_html;
    NSMutableArray *postArray,*postHeightArray,*indexPaths;
    PostReadView *HeightwebView;
    NSInteger loadCount;
    UIWebView *webview;
    NSString *threadFID;
}

@property(atomic,retain)NSString *threadFID;
@property(atomic)NSInteger loadCount;

-(id)initWithPostDictionary:(NSDictionary *) PostDetail;
-(void)newPost;

@end

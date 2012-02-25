//
//  PostReadView.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/20/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostReadView : UIWebView <UIWebViewDelegate>
{
    NSMutableArray *posts;
    NSInteger n,max,height;
    NSInteger *loadC;
    UITableView *tableViewToReload;
    NSMutableArray *heights,*rowsToReload;
}

@property(atomic,retain)NSMutableArray *posts;
@property(atomic)NSInteger max;
@property(atomic)NSInteger n;
@property(atomic)NSInteger *loadC;
@property(atomic,retain)UITableView *tableViewToReload;
@property(atomic,retain)NSMutableArray *heights;
@property(atomic,retain)NSMutableArray *rowsToReload;

@end

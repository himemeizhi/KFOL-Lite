//
//  ReadView.h
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/10/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReadView : UIWebView<UIWebViewDelegate>
{
    NSInteger webHeight;
    UITableView *tableViewToReload;
    int n;
}

@property(atomic)NSInteger webHeight;
@property(atomic,retain)UITableView *tableViewToReload;

@end

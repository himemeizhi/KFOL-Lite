//
//  ReadView.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/10/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "ReadView.h"

@implementation ReadView

@synthesize webHeight;
@synthesize tableViewToReload;

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webHeight=[[self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").offsetHeight;"] intValue];
    self.scrollView.scrollEnabled=NO;    
    [tableViewToReload reloadData];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    // load error, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // report the error inside the webview
    NSString* errorString = [NSString stringWithFormat:
                             @"<html><center><font size=+5 color='red'>An error occurred:<br>%@</font></center></html>",
                             error.localizedDescription];
    [self loadHTMLString:errorString baseURL:nil];
}

@end

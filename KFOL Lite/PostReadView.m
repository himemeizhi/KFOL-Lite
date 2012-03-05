//
//  PostReadView.m
//  KFOL Lite
//
//  Created by 七音 姫宮 on 2/20/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "PostReadView.h"

@implementation PostReadView

@synthesize posts;
@synthesize max;
@synthesize n;
@synthesize tableViewToReload;
@synthesize heights;
@synthesize loadC;
@synthesize rowsToReload;

/*
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}*/

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (n!=max) {
        n++;
        [heights addObject:[self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").offsetHeight;"]];/*
        NSLog([self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").offsetWidth;"]);
        NSLog([self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").clientWidth;"]);
        NSLog([self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").scrollWidth;"]);
        
        NSLog([self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").offsetHeight;"]);
        NSLog([self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").clientHeight;"]);
        NSLog([self stringByEvaluatingJavaScriptFromString:@"document.getElementById(\"xxx\").scrollHeight;"]);
        
        NSLog([self stringByEvaluatingJavaScriptFromString:@"window.screen.width;"]);
        NSLog([self stringByEvaluatingJavaScriptFromString:@"window.screen.height;"]);*/
        if(n!=max){
            NSMutableString *postSizeCheckString=[[NSMutableString alloc]initWithString:[[posts objectAtIndex:n]objectForKey:@"PostContent"]];
            while([postSizeCheckString rangeOfString:@"if(this.width>'700')this.width='700';"].location!=NSNotFound) {
                [postSizeCheckString replaceCharactersInRange:[postSizeCheckString rangeOfString:@"if(this.width>'700')this.width='700';"] withString:@"if(this.width>'300')this.width='300';"];
            }
        [self loadHTMLString:[[@"<div id='xxx'>" stringByAppendingString:postSizeCheckString]stringByAppendingString:@"</div>"] baseURL:[NSURL URLWithString:@"http://bbs.9gal.com"]];
        }
    }
    if (n==max) {
        (*loadC)++;
//        [tableViewToReload reloadData];
        [tableViewToReload reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
        
    }
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

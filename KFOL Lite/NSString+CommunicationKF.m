//
//  NSString+CommunicationKF.m
//  KFOL
//
//  Created by 七音 姫宮 on 1/23/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import "NSString+CommunicationKF.h"

@implementation NSString (CommunicationKF)

-(NSData *) getWithStringContent:(NSString *)content returnResponse:(NSURLResponse *__autoreleasing *)response error:(NSError *__autoreleasing *)error
{
    //set url
    NSMutableString *url=[[NSMutableString alloc]initWithString:KFWEBSITE];
    if (content==nil) {
        [url setString:[url stringByAppendingString:self]];
    }
    else
    {
        [url setString:[url stringByAppendingString:self]];
        [url setString:[url stringByAppendingString:content]];
    }
    //set request
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"GET"];
    //send it
    NSData *result=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:response error:error];
    return result;
    
}

-(NSData *) postWithStringContent:(NSString *)content returnResponse:(NSURLResponse *__autoreleasing *)response error:(NSError *__autoreleasing *)error
{
    //set url
    NSMutableString *url=[[NSMutableString alloc]initWithString:KFWEBSITE];
    [url setString:[url stringByAppendingString:self]];
    //set request
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *body=content;
    [theRequest addValue:[NSString stringWithFormat:@"%d",body.length] forHTTPHeaderField:@"Content-Length"];
    [theRequest setHTTPBody:[body dataUsingEncoding:0x80000632]];
    //send
    NSData *result=[NSURLConnection sendSynchronousRequest:theRequest returningResponse:response error:error];
    return result;
}

-(void) switchUser
{
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:[NSHTTPCookie cookieWithProperties:[NSDictionary dictionaryWithContentsOfFile:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/Users/%@.xml",self]]]];
}

void logout()
{
    NSArray *allcookies=[[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:KFWEBSITE]];
    for(NSHTTPCookie *cookieToDelete in allcookies)
    {//NSLog(cookieToDelete.description);
        if([cookieToDelete.name compare:@"0857d_winduser"]==NSOrderedSame)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookieToDelete];
        if([cookieToDelete.name compare:@"0857d_hideid"]==NSOrderedSame)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookieToDelete];
        if([cookieToDelete.name compare:@"0857d_lastvisit"]==NSOrderedSame)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookieToDelete];
        if([cookieToDelete.name compare:@"0857d_ck_info"]==NSOrderedSame)
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookieToDelete];
    }
}

/*
void loginWithDefaultID()
{
    NSMutableDictionary *theCookieIMade=[[NSMutableDictionary alloc]init];
    [theCookieIMade setObject:@"1" forKey:@"Created"];
    [theCookieIMade setObject:@"TRUE" forKey:@"Discard"];
    [theCookieIMade setObject:@"bbs.9gal.com" forKey:@"Domain"];
    [theCookieIMade setObject:@"0857d_winduser" forKey:@"Name"];
    [theCookieIMade setObject:@"/" forKey:@"Path"];
    [theCookieIMade setObject:@"BAcCBQcBbVMADApaVwVVXQFWVANUBAxXAFBSAFIFVFVVUwdRBQRU" forKey:@"Value"];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookie:[NSHTTPCookie cookieWithProperties:theCookieIMade]];
}*/

@end

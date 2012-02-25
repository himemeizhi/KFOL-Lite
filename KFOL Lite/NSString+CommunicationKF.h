//
//  NSString+CommunicationKF.h
//  KFOL
//
//  Created by 七音 姫宮 on 1/23/12.
//  Copyright (c) 2012 CDUESTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#define KFWEBSITE @"http://bbs.9gal.com/"

@interface NSString (CommunicationKF)

-(NSData *) getWithStringContent:(NSString *) content returnResponse:(NSURLResponse **) response error:(NSError **) error;
-(NSData *) postWithStringContent:(NSString *) content returnResponse:(NSURLResponse **) response error:(NSError **) error;


-(void) switchUser;
void logout();

@end

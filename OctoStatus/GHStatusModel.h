//
//  GHStatusModel.h
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kGHStatusCodeGood @"good"
#define kGHStatusCodeMinor @"minor"
#define kGHStatusCodeMajor @"major"
typedef NSString* GHStatusCode;

@interface GHStatus : NSObject<NSCoding>

@property (nonatomic) GHStatusCode status;
@property (nonatomic) NSString *body;
@property (nonatomic) NSDate *time;
@property (nonatomic) NSDate *fetchTime;

@end

@interface GHStatusAPI : NSObject<NSCoding>

@property (nonatomic) NSString *statusURL;
@property (nonatomic) NSString *messagesURL;
@property (nonatomic) NSString *lastMessageURL;

@end

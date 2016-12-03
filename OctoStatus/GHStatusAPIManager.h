//
//  GHStatusAPIManager.h
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <AFNetworking/AFNetworking.h>
#import <ISO8601DateFormatter/ISO8601DateFormatter.h>
#import "GHStatusModel.h"
#import "Utility.h"

//#define kAPIURL @"https://status.github.com/api.json"
#define kAPIURL @"http://192.168.1.161:8000/api.json"

@interface GHStatusAPIManager : NSObject

+ (instancetype)sharedManager;

- (RACSignal *)status;
- (RACSignal *)lastMessage;
- (RACSignal *)messages;

@end

//
//  Utility.h
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHStatusModel.h"

@interface Utility : NSObject

+ (NSUserDefaults *)userDefaults;

+ (void)saveLatestStatus:(GHStatus *)status;
+ (GHStatus *)lastestStatus;
+ (void)clearStatus;

+ (void)saveAPI:(GHStatusAPI *)api;
+ (GHStatusAPI *)api;
+ (void)clearAPI;

@end

//
//  Utility.h
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GHStatusModel.h"
#import "UIColor+Addision.h"
#import "UIScreen+Addision.h"

@interface Utility : NSObject

+ (NSUserDefaults *)userDefaults;

+ (void)saveLatestStatus:(GHStatus *)status;
+ (GHStatus *)lastestStatus;
+ (void)clearStatus;

+ (void)saveAPI:(GHStatusAPI *)api;
+ (GHStatusAPI *)api;
+ (void)clearAPI;

+ (NSString *)stringFrom:(NSDate *)date;

@end

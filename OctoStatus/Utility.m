//
//  Utility.m
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "Utility.h"

@implementation Utility

+ (NSUserDefaults *)userDefaults {
	return [[NSUserDefaults alloc] initWithSuiteName:@"group.hkalexling.OctoStatus"];
}

+ (void)saveLatestStatus:(GHStatus *)status {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:status];
	[[Utility userDefaults] setObject:data forKey:@"status"];
}

+ (GHStatus *)lastestStatus {
	NSData *data = [[Utility userDefaults] objectForKey:@"status"];
	if (data){
		return [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	return nil;
}

+ (void)clearStatus {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"status"];
}

+ (void)saveAPI:(GHStatusAPI *)api {
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:api];
	[[Utility userDefaults] setObject:data forKey:@"api"];
}

+ (GHStatusAPI *)api {
	NSData *data = [[Utility userDefaults] objectForKey:@"api"];
	if (data){
		return [NSKeyedUnarchiver unarchiveObjectWithData:data];
	}
	return nil;
}

+ (void)clearAPI {
	[[Utility userDefaults] removeObjectForKey:@"api"];
}

+ (NSString *)stringFrom:(NSDate *)date {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"HH:mm"];
	return [formatter stringFromDate:date];
}

@end

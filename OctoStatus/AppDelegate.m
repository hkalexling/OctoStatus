//
//  AppDelegate.m
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "AppDelegate.h"
#import "GHStatusAPIManager.h"
#import <UserNotifications/UserNotifications.h>
#import "Utility.h"

@interface AppDelegate ()

@property (nonatomic) GHStatus *status;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	
	[application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
	
	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	[center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert)
												completionHandler:^(BOOL granted, NSError * _Nullable error) {
													if (granted){
														NSLog(@"notification granted");
													}
												}];
	
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
	
	// Save NSLog output to file in document directory. Only for testing purpose.
//	NSArray *allPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDirectory = [allPaths objectAtIndex:0];
//	NSString *pathForLog = [documentsDirectory stringByAppendingPathComponent:@"octostatus.log"];
//	freopen([pathForLog cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
	
	[Utility clearAPI];
	
	return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	[UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	
	NSLog(@"checking lastest status");
	[[[[GHStatusAPIManager sharedManager] lastMessage] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(GHStatus *status) {
		
		NSLog(@"lastest status: %@", status.body);
		GHStatus *savedStatus = [Utility lastestStatus];
		if (savedStatus && ![savedStatus.body isEqualToString:status.body]){
			NSLog(@"status changed, firing notification");
			[self notify:status.body];
		}
		else{
			NSLog(@"status not changed, dismissing");
		}
		
		_status = status;
	} error:^(NSError *error) {
		NSLog(@"status check error: %@", error);
		completionHandler(UIBackgroundFetchResultFailed);
	} completed:^{
		[Utility saveLatestStatus:_status];
		NSLog(@"status check completed");
		completionHandler(UIBackgroundFetchResultNewData);
	}];
	
}

- (void)notify:(NSString *) text {

	UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
	objNotificationContent.title = [NSString localizedUserNotificationStringForKey:@"GitHub Status" arguments:nil];
	objNotificationContent.body = [NSString localizedUserNotificationStringForKey:text arguments:nil];
	objNotificationContent.sound = [UNNotificationSound defaultSound];
	
	objNotificationContent.badge = @(1);

	UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"octostatus-notification-request"
																																				content:objNotificationContent trigger:nil];
	
	UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
	[center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
		if (error) {
			NSLog(@"notification failed with error: %@", error);
		}
		else {
			NSLog(@"notification sent");
		}
	}];
}

@end

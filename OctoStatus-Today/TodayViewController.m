//
//  TodayViewController.m
//  OctoStatus-Today
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "GHStatusAPIManager.h"
#import "Utility.h"
#import "UIColor+Addision.h"
#import "UIScreen+Addision.h"

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	GHStatus *latest = [Utility lastestStatus];
	[self updateUIWith:latest];
	
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
	
	[[[[GHStatusAPIManager sharedManager] lastMessage] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(GHStatus *status) {
		[self updateUIWith:status];
		[Utility saveLatestStatus:status];
	} error:^(NSError * _Nullable error) {
		NSLog(@"error: %@", error);
		completionHandler(NCUpdateResultFailed);
	} completed:^{
		completionHandler(NCUpdateResultNewData);
	}];
}

- (void)updateUIWith:(GHStatus *) status {
	self.view.backgroundColor = [UIColor colorWith:status];
	_body.text = @"Loading";
	if (status){
		_body.text = [NSString stringWithFormat:@"GitHub Status: %@", [status.status capitalizedString]];
	}
}

@end

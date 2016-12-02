//
//  TodayViewController.m
//  OctoStatus-Today
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	self.extensionContext.widgetLargestAvailableDisplayMode = NCWidgetDisplayModeExpanded;
	
	GHStatus *latest = [Utility lastestStatus];
	[self updateUIWith:latest];
	
	_loading.backgroundColor = [UIColor clearColor];
	_loading.size = 30;
	[_loading setType:DGActivityIndicatorAnimationTypeBallClipRotate];
	_loading.tintColor = [UIColor whiteColor];
	[self.view addSubview:_loading];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
	
	[_loading startAnimating];
	[[[[GHStatusAPIManager sharedManager] lastMessage] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(GHStatus *status) {
		[self updateUIWith:status];
		[Utility saveLatestStatus:status];
	} error:^(NSError * _Nullable error) {
		NSLog(@"error: %@", error);
		[_loading stopAnimating];
		completionHandler(NCUpdateResultFailed);
	} completed:^{
		[_loading stopAnimating];
		completionHandler(NCUpdateResultNewData);
	}];
}

- (void)widgetActiveDisplayModeDidChange:(NCWidgetDisplayMode)activeDisplayMode
												 withMaximumSize:(CGSize)maxSize {
	if (activeDisplayMode == NCWidgetDisplayModeExpanded) {
		self.preferredContentSize = CGSizeMake(maxSize.width, 150);
		_bodyCenterYConstraint.constant = -20;
		_updateTimeLabel.hidden = NO;
	} else if (activeDisplayMode == NCWidgetDisplayModeCompact) {
		self.preferredContentSize = maxSize;
		_bodyCenterYConstraint.constant = 0;
		_updateTimeLabel.hidden = YES;
	}
}

- (void)updateUIWith:(GHStatus *) status {
	self.view.backgroundColor = [UIColor colorWith:status];
	_body.text = @"Loading";
	if (status){
		_updateTimeLabel.text = [NSString stringWithFormat:@"updated at: %@", [Utility stringFrom:status.fetchTime]];
		_body.text = [NSString stringWithFormat:@"GitHub Status: %@", [status.status capitalizedString]];
	}
	else{
		_updateTimeLabel.text = @"";
	}
}

@end

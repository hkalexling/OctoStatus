//
//  ViewController.m
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "ViewController.h"
#import "GHStatusAPIManager.h"
#import "UIColor+Addision.h"
#import "UIScreen+Addision.h"

@interface ViewController ()

@property (nonatomic) SCSkypeActivityIndicatorView *loading;
@property (nonatomic) UILabel *body;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refresh;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"%@", [Utility lastestStatus]);
	
	_tableView = [UITableView new];
	_tableView.frame = self.view.frame;
	_tableView.backgroundColor = [UIColor clearColor];
	_tableView.tableFooterView = [UIView new];
	
	_refresh = [UIRefreshControl new];
	_refresh.tintColor = [UIColor whiteColor];
	[_refresh addTarget:self action:@selector(fetch) forControlEvents:UIControlEventValueChanged];
	_refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh"
																														 attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
																																					NSFontAttributeName: [UIFont fontWithName:@"Avenir-Book" size:15]}];
	[_tableView addSubview:_refresh];
	
	[self.view addSubview:_tableView];
	
	_loading = [[SCSkypeActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
	_loading.center = self.view.center;
	self.view.backgroundColor = [UIColor colorWith:[Utility lastestStatus]];
	[_loading startAnimating];
	[self.view addSubview:_loading];
	
	_body = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
	_body.numberOfLines = 0;
	_body.lineBreakMode = NSLineBreakByWordWrapping;
	_body.textColor = [UIColor whiteColor];
	_body.font = [UIFont fontWithName:@"Avenir-Medium" size:24];
	_body.hidden = YES;
	[self.view addSubview:_body];
	
	[self fetch];
}

- (void)fetch {
	_body.hidden = YES;
	[_loading startAnimating];
	[_refresh endRefreshing];
	[[[[GHStatusAPIManager sharedManager] lastMessage] subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(GHStatus *status) {
		[self updateViewWith:status];
		[Utility saveLatestStatus:status];
	} error:^(NSError *error) {
		NSLog(@"error: %@", error);
	} completed:^{
		[_loading stopAnimating];
	}];
}

- (void)updateViewWith:(GHStatus *) status {
	self.view.backgroundColor = [UIColor colorWith:status];
	
	_body.hidden = NO;
	_body.text = status.body;
	CGRect frame = _body.frame;
	frame.size = [_body sizeThatFits:CGSizeMake([UIScreen size].width * 0.9, CGFLOAT_MAX)];
	_body.frame = frame;
	_body.center = self.view.center;
}


@end

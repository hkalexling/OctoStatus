//
//  ViewController.m
//  OctoStatus
//
//  Created by Alex Ling on 1/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic) DGActivityIndicatorView *loading;
@property (nonatomic) UILabel *body;
@property (nonatomic) UILabel *updateTimeLabel;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIRefreshControl *refresh;

@property (nonatomic) UIView *moreBtn;
@property (nonatomic) MoreViewController *moreVC;
@property (nonatomic) UIView *moreVCView;

@property NSUInteger moreBtnState;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_moreBtnState = 0;
	
	_loading = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallScaleRippleMultiple tintColor:[UIColor whiteColor] size:200];
	_loading.center = self.view.center;
	[_loading startAnimating];
	[self.view addSubview:_loading];
	
	_body = [UILabel new];
	_body.numberOfLines = 0;
	_body.lineBreakMode = NSLineBreakByWordWrapping;
	_body.textColor = [UIColor whiteColor];
	_body.font = [UIFont fontWithName:@"Avenir-Medium" size:24];
	[self.view addSubview:_body];
	
	_updateTimeLabel = [UILabel new];
	_updateTimeLabel.textColor = [UIColor whiteColor];
	_updateTimeLabel.font = [UIFont fontWithName:@"Avenir-Book" size:15];
	[self.view addSubview:_updateTimeLabel];
	
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
	
	self.view.backgroundColor = [UIColor colorWith:[Utility lastestStatus]];
	
	_moreBtn = [UIView new];
	_moreBtn.frame = CGRectMake(0, 0, 40, 40);
	_moreBtn.layer.cornerRadius = 20;
	_moreBtn.clipsToBounds = YES;
	_moreBtn.backgroundColor = [UIColor whiteColor];
	_moreBtn.userInteractionEnabled = YES;
	_moreBtn.center = CGPointMake(10 + 20, [UIScreen size].height - 10 - 20);
	[_moreBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapped)]];
	[self.view addSubview:_moreBtn];
	
	[self fetch];
}

- (void)fetch {
	_body.alpha = 0;
	_updateTimeLabel.alpha = 0;
	_moreBtn.alpha = 0;
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
	_body.text = status.body;
	CGRect frame = _body.frame;
	frame.size = [_body sizeThatFits:CGSizeMake([UIScreen size].width * 0.9, CGFLOAT_MAX)];
	_body.frame = frame;
	_body.center = self.view.center;
	
	_updateTimeLabel.text = [NSString stringWithFormat:@"updated at: %@", [Utility stringFrom:status.fetchTime]];
	[_updateTimeLabel sizeToFit];
	_updateTimeLabel.frame = CGRectMake([UIScreen size].width - 10 - _updateTimeLabel.bounds.size.width, [UIScreen size].height - 10 - _updateTimeLabel.bounds.size.height, _updateTimeLabel.bounds.size.width, _updateTimeLabel.bounds.size.height);
	
	[UIView animateWithDuration:0.5 animations:^{
		self.view.backgroundColor = [UIColor colorWith:status];
		_body.alpha = 1;
		_updateTimeLabel.alpha = 1;
		_moreBtn.alpha = 1;
	}];
}

- (void)moreTapped {
	if (_moreBtnState == 0){
		_moreBtnState = 1;
		CGFloat radius = hypotf([UIScreen size].width, [UIScreen size].height);
		CGFloat scale = radius / _moreBtn.layer.cornerRadius;
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			_moreBtn.transform = CGAffineTransformMakeScale(scale, scale);
		} completion:^(BOOL finished) {
			_moreBtnState = 2;
			[self setUpMoreView];
		}];
	}
	else if (_moreBtnState == 2){
		[self destroyMoreView];
		_moreBtnState = 1;
		[UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			_moreBtn.transform = CGAffineTransformIdentity;
		} completion:^(BOOL finished) {
			_moreBtnState = 0;
		}];
	}
}

- (void)setUpMoreView {
	_moreVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"moreVC"];
	_moreVC.delegate = self;
	[self addChildViewController:_moreVC];
	_moreVCView = _moreVC.view;
	[self.view addSubview:_moreVC.view];
}

- (void)destroyMoreView {
	[_moreVC removeFromParentViewController];
	[_moreVCView removeFromSuperview];
}

- (void)moreViewShouldClose {
	[self moreTapped];
}


@end

//
//  MoreViewController.m
//  OctoStatus
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeightConstraintExpanded;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *catBottomConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *cat;
@property (weak, nonatomic) IBOutlet UIImageView *backBtn;

@property NSUInteger state;
@property (nonatomic) NSString *moreHTML;

@end

@implementation MoreViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	_state = 0;
	
	_backBtn.userInteractionEnabled = YES;
	[_backBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)]];
	
	_webView.backgroundColor = [UIColor clearColor];
	_webView.opaque = NO;
	_webView.delegate = self;
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"more" ofType:@"html"];
	_moreHTML = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
	
	[_webView loadHTMLString:_moreHTML baseURL:nil];
}

- (void)tapped {
	if (_state == 0){
		[_delegate moreViewShouldClose];
	}
	else if (_state == 2){
		[_webView loadHTMLString:_moreHTML baseURL:nil];
		[self compact];
	}
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
		
		NSURL *URL = request.URL;
		if ([URL.scheme isEqualToString:@"license"]){
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				NSString *name = URL.host;
				NSString *file = [[NSBundle mainBundle] pathForResource:name.lowercaseString ofType:@"html"];
				if (file){
					NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
					dispatch_async(dispatch_get_main_queue(), ^{
						[_webView loadHTMLString:html baseURL:nil];
					});
				}
			});
			[self expand];
		}
		
		[[UIApplication sharedApplication] openURL:[request URL] options:@{} completionHandler:nil];
		return NO;
	}
	
	return YES;
}

- (void)expand {
	_state = 1;
	_webViewHeightConstraint.priority = 250;
	_webViewHeightConstraintExpanded.priority = 750;
	_catBottomConstraint.constant =  -6 - _cat.bounds.size.height;
	[UIView animateWithDuration:0.3 animations:^{
		[self.view layoutIfNeeded];
	} completion:^(BOOL finished) {
		_state = 2;
	}];
}

- (void)compact {
	_state = 1;
	_webViewHeightConstraint.priority = 750;
	_webViewHeightConstraintExpanded.priority = 250;
	_catBottomConstraint.constant = -6;
	[UIView animateWithDuration:0.3 animations:^{
		[self.view layoutIfNeeded];
	} completion:^(BOOL finished) {
		_state = 0;
	}];
}

@end

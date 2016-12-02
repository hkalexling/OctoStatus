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

@end

@implementation MoreViewController

- (void)viewDidLoad {
	[super viewDidLoad];
		
	_webView.backgroundColor = [UIColor clearColor];
	_webView.opaque = NO;
	_webView.delegate = self;
	
	NSString *file = [[NSBundle mainBundle] pathForResource:@"more" ofType:@"html"];
	NSString *html = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil];
	
	[_webView loadHTMLString:html baseURL:nil];
	
	[self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)]];
}

- (void)tapped {
	[_delegate moreViewShouldClose];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
		[[UIApplication sharedApplication] openURL:[request URL] options:@{} completionHandler:nil];
		return NO;
	}
	
	return YES;
}

@end

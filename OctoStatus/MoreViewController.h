//
//  MoreViewController.h
//  OctoStatus
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreViewControllerDelegate <NSObject>

@optional
- (void)moreViewShouldClose;

@end

@interface MoreViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, weak) id <MoreViewControllerDelegate> delegate;

@end

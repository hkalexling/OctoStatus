//
//  TodayViewController.h
//  OctoStatus-Today
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DGActivityIndicatorView/DGActivityIndicatorView.h>

@interface TodayViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *body;
@property (weak, nonatomic) IBOutlet DGActivityIndicatorView *loading;

@end

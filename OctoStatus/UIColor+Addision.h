//
//  UIColor+Addision.h
//  OctoStatus
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHStatusModel.h"

@interface UIColor(Addision)

+ (UIColor *)colorWith:(GHStatus *)status;
+ (UIColor *)GHGreenColor;
+ (UIColor *)GHYellowColor;
+ (UIColor *)GHRedColor;

@end

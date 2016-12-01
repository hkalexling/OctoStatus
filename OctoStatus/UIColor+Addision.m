//
//  UIColor+Addision.m
//  OctoStatus
//
//  Created by Alex Ling on 2/12/2016.
//  Copyright © 2016 Alex Ling. All rights reserved.
//

#import "UIColor+Addision.h"

@implementation UIColor(Addision)

+ (UIColor *)colorWith:(GHStatus *)status {
	if ([status.status isEqualToString:kGHStatusCodeMinor]){
		return [UIColor GHYellowColor];
	}
	else if ([status.status isEqualToString:kGHStatusCodeMajor]){
		return [UIColor GHRedColor];
	}
	else {
		return [UIColor GHGreenColor];
	}
}

+ (UIColor *)GHGreenColor {
	return [UIColor colorWithRed:74.0/255 green:205.0/255 blue:47.0/255 alpha:1];
}

+ (UIColor *)GHYellowColor {
	return [UIColor colorWithRed:243.0/255 green:153.0/255 blue:5.0/255 alpha:1];
}

+ (UIColor *)GHRedColor {
	return [UIColor colorWithRed:213.0/255 green:44.0/255 blue:65.0/255 alpha:1];
}

@end

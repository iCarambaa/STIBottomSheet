//
//  STIDimmingView.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 10.08.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import "STIDimmingView.h"

@implementation STIDimmingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.blackColor;
        self.opaque = NO;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return nil;
}

@end

//
//  STIIndicatorView.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 28.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import "STIIndicatorView.h"

@implementation STIIndicatorView

- (CGSize)intrinsicContentSize {
    return CGSizeMake(40, 5);
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor lightGrayColor];
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = CGRectGetHeight(self.bounds) / 2.0;
}

@end

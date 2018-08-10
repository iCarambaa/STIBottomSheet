//
//  STISheetContainerViewController.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 28.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import "STISheetContainerViewController.h"
#import "STIIndicatorView.h"

NS_ASSUME_NONNULL_BEGIN

@interface STISheetContainerViewController ()

@property (strong, nonatomic) UIImageView *shadow;

@end

@implementation STISheetContainerViewController

- (instancetype)initWithViewController:(UIViewController *)viewController {
    NSParameterAssert(viewController);
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _embeddedViewController = viewController;
    }
    return self;
}

- (UIEdgeInsets)additionalSafeAreaInsets {
    UIEdgeInsets additionalInsets = UIEdgeInsetsMake(20, 0, 0, 0);
    return additionalInsets;
}

- (CGSize)preferredContentSize {
    return self.embeddedViewController.preferredContentSize;
}

- (void)loadView {
    if (self.isViewLoaded) {
        return;
    }
    [super loadView];
    
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.view.bounds;
    effectView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    effectView.layer.cornerRadius = 8;
    effectView.clipsToBounds = YES;
    [self.view addSubview:effectView];
    
    self.view.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    self.view.layer.cornerRadius = 8;
    
    self.embeddedViewController.view.frame = self.view.bounds;
    self.embeddedViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [effectView.contentView addSubview:self.embeddedViewController.view];
    [self addChildViewController:self.embeddedViewController];
    [self.embeddedViewController didMoveToParentViewController:self];
    
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *urlToResourceBundle = [podBundle URLForResource:@"STIBottomSheet" withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:urlToResourceBundle];
    NSURL *urlToShadow = [resourceBundle URLForResource:@"shadow" withExtension:@"tiff"];
    NSData *shadowData = [NSData dataWithContentsOfURL:urlToShadow];
    UIImage *shadowImage = [UIImage imageWithData:shadowData];
    UIImageView *shadowImageView = [[UIImageView alloc] initWithImage:shadowImage];
    [shadowImageView setContentStretch:CGRectMake(0.490991, 0.90833, 0.018018, 0.03333)];
    shadowImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:shadowImageView];
    [self.view sendSubviewToBack:shadowImageView];
    [shadowImageView.bottomAnchor constraintEqualToAnchor:self.view.topAnchor constant:16].active = YES;
    [shadowImageView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:-18].active = YES;
    [shadowImageView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:18].active = YES;
    [shadowImageView.heightAnchor constraintEqualToConstant:24].active = YES;
    
    UIView *indicator = [[STIIndicatorView alloc] initWithFrame:CGRectZero];
    indicator.translatesAutoresizingMaskIntoConstraints = NO;
    [effectView.contentView addSubview:indicator];
    [indicator.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [indicator.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:5].active = YES;
}

@end

NS_ASSUME_NONNULL_END

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

- (instancetype)initWithViewController:(UIViewController *)viewController closable:(BOOL)isClosable {
    NSParameterAssert(viewController);
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _embeddedViewController = viewController;
        _isClosable = isClosable;
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
    
    if (self.isClosable) {
        UIImage *image = [UIImage imageNamed:@"closeButton"];
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [closeButton setImage:image forState:UIControlStateNormal];
        closeButton.translatesAutoresizingMaskIntoConstraints = NO;
        [effectView.contentView addSubview:closeButton];
        [closeButton.trailingAnchor constraintEqualToAnchor:effectView.contentView.trailingAnchor constant:-16].active = YES;
        [closeButton.topAnchor constraintEqualToAnchor:effectView.contentView.topAnchor constant:8].active = YES;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventPrimaryActionTriggered];
    }
}

- (void)close {
    if ([self.delegate respondsToSelector:@selector(sheetContainerDidSelectClose:)]) {
        [self.delegate sheetContainerDidSelectClose:self];
    }
}

@end

NS_ASSUME_NONNULL_END

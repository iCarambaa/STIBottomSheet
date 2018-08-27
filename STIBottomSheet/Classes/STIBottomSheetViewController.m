//
//  STIBottomSheetViewController.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 27.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import "STIBottomSheetViewController.h"
#import "STISheetContainerViewController.h"
#import "STIBottomSheetAnimator.h"
#import "STIDimmingView.h"

NS_ASSUME_NONNULL_BEGIN

@interface STIBottomSheetViewController () <STIBottomSheetAnimatorDelegate>

@property (nonatomic, strong) NSMutableArray <STIBottomSheetAnimator *> *bottomSheetAnimators;

@property (nonatomic, strong) STIDimmingView *dimmingView;

@end

@implementation STIBottomSheetViewController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    NSParameterAssert(rootViewController);
    
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _rootViewController = rootViewController;
        _bottomSheetAnimators = @[].mutableCopy;
        _enabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
}

- (void)loadView {
    if (self.isViewLoaded) {
        return;
    }
    [super loadView];
    
    
    self.rootViewController.view.frame = self.view.bounds;
    self.rootViewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.rootViewController.view];
    [self addChildViewController:self.rootViewController];
    [self.rootViewController didMoveToParentViewController:self];
    
    STIDimmingView *dimmingView = [[STIDimmingView alloc] initWithFrame:self.view.bounds];
    dimmingView.alpha = 0;
    dimmingView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:dimmingView];
    self.dimmingView = dimmingView;
    NSLayoutConstraint *bottomConstraint = [dimmingView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor];
    bottomConstraint.priority = UILayoutPriorityDefaultLow;
    NSArray <NSLayoutConstraint *> *dimmingConstraints = @[
        [dimmingView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [dimmingView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [dimmingView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        bottomConstraint
    ];
    [NSLayoutConstraint activateConstraints:dimmingConstraints];
}

- (void)addBottomSheet:(UIViewController *)bottomSheet {
    NSParameterAssert(bottomSheet);
    
    STISheetContainerViewController *sheet = [[STISheetContainerViewController alloc] initWithViewController:bottomSheet];
    [self addChildViewController:sheet];
    sheet.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sheet.view];
    NSLayoutConstraint *constraint = [sheet.view.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-325];
    [NSLayoutConstraint activateConstraints:@[
        [sheet.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [sheet.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [sheet.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        constraint,
        
        // Dimming view above the sheet which is most maximized. 5 Constraints offset for rounded corners.
        [self.dimmingView.bottomAnchor constraintLessThanOrEqualToAnchor:sheet.view.topAnchor constant:5]
    ]];
    [sheet didMoveToParentViewController:self];
    
    STIBottomSheetAnimator *animator = [[STIBottomSheetAnimator alloc] initWithSheetViewController:sheet onViewController:self topConstraint:constraint];
    animator.delegate = self;
    [self.bottomSheetAnimators addObject:animator];
}

- (void)maximizeSheet:(UIViewController *)sheet animateAlongside:(void (^)(void))animations {
    for (STIBottomSheetAnimator *animator in self.bottomSheetAnimators) {
        if (animator.managedSheet.embeddedViewController == sheet) {
            [animator moveToPosition:STIBottomSheetPositionMaximized animateAlongside:animations];
            break;
        }
    }
}

// MARK: STIBottomSheetAnimatorDelegate

- (CGFloat)animator:(STIBottomSheetAnimator *)animator topConstraintConstantForPosition:(STIBottomSheetPosition)position {
    switch (position) {
        case STIBottomSheetPositionMinimized:
            return -325;
        case STIBottomSheetPositionMaximized:
            return (CGRectGetHeight(self.view.bounds) - self.view.safeAreaInsets.top) * -1;
        default:
            return 0;
    }
}

- (void)animator:(STIBottomSheetAnimator *)animator didMoveToPosition:(STIBottomSheetPosition)position {
    [self.view endEditing:YES];
}

- (BOOL)animatorShouldBeginGestureDrivenTransition:(STIBottomSheetAnimator *)animator {
    return self.isEnabled;
}

- (void)animator:(STIBottomSheetAnimator *)animator updateTransition:(CGFloat)fractionCompleted {
    self.dimmingView.alpha = 0.5 * fractionCompleted;
}

@end

@implementation UIViewController (STIBottomSheet)

- (STIBottomSheetViewController * _Nullable)bottomSheetController {
    if ([self isKindOfClass:[STIBottomSheetViewController class]]) {
        return (STIBottomSheetViewController *)self;
    } else {
        return self.parentViewController.bottomSheetController;
    }
}

@end

NS_ASSUME_NONNULL_END


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

@interface STIBottomSheetViewController () <STIBottomSheetAnimatorDelegate, STISheetContainerViewControllerDelegate>

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

- (void)addBottomSheet:(UIViewController *)bottomSheet closable:(BOOL)isClosable {
    NSParameterAssert(bottomSheet);
    
    STISheetContainerViewController *sheet = [[STISheetContainerViewController alloc] initWithViewController:bottomSheet closable:isClosable];
    sheet.delegate = self;
    [self addChildViewController:sheet];
    sheet.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:sheet.view];
    NSLayoutConstraint *constraint = [sheet.view.topAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:0];
    [NSLayoutConstraint activateConstraints:@[
        [sheet.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [sheet.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [sheet.view.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
        constraint,
        
        // Dimming view above the sheet which is most maximized. 5 Constraints offset for rounded corners.
        [self.dimmingView.bottomAnchor constraintLessThanOrEqualToAnchor:sheet.view.topAnchor constant:5]
    ]];
    
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        constraint.constant = -325;
        [self.view layoutIfNeeded];
    } completion:nil];
    [sheet didMoveToParentViewController:self];
    
    STIBottomSheetAnimator *animator = [[STIBottomSheetAnimator alloc] initWithSheetViewController:sheet onViewController:self topConstraint:constraint];
    animator.delegate = self;
    [self.bottomSheetAnimators addObject:animator];
}

- (void)closeBottomSheet:(UIViewController *)bottomSheet {
    STIBottomSheetAnimator *animator = nil;
    for (STIBottomSheetAnimator *search in self.bottomSheetAnimators) {
        if (search.managedSheet.embeddedViewController == bottomSheet) {
            animator = search;
            break;
        }
    }
    
    if(animator == nil) {
        return;
    }
    
    [animator closeSheetOnCompletion:^{
        [self.bottomSheetAnimators removeObject:animator];
        STISheetContainerViewController *sheet = animator.managedSheet;
        [sheet willMoveToParentViewController:nil];
        [sheet removeFromParentViewController];
        [sheet.view removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(bottomSheet:didCloseSheet:)]) {
            [self.delegate bottomSheet:self didCloseSheet:bottomSheet];
        }
    }];
}

- (void)maximizeSheet:(UIViewController *)sheet animateAlongside:(void (^ _Nullable)(void))animations completion:(void (^ _Nullable)(void))completion {
    for (STIBottomSheetAnimator *animator in self.bottomSheetAnimators) {
        if (animator.managedSheet.embeddedViewController == sheet) {
            [animator moveToPosition:STIBottomSheetPositionMaximized animateAlongside:animations completion:completion];
            break;
        }
    }
}

- (void)minimizeSheet:(UIViewController *)sheet animateAlongside:(void (^ _Nullable)(void))animations completion:(void (^ _Nullable)(void))completion{
    for (STIBottomSheetAnimator *animator in self.bottomSheetAnimators) {
        if (animator.managedSheet.embeddedViewController == sheet) {
            [animator moveToPosition:STIBottomSheetPositionMinimized animateAlongside:animations completion:completion];
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
            return (CGRectGetHeight(self.view.bounds) - self.view.safeAreaInsets.top - 12) * -1;
        default:
            return 0;
    }
}

- (void)animator:(STIBottomSheetAnimator *)animator didMoveToPosition:(STIBottomSheetPosition)position {
    if (position == STIBottomSheetPositionMinimized) {
        [self.view endEditing:YES];
        if ([self.delegate respondsToSelector:@selector(bottomSheet:didMinimizeSheet:)]) {
            [self.delegate bottomSheet:self didMinimizeSheet:animator.managedSheet.embeddedViewController];
        }
    } else if (position == STIBottomSheetPositionMaximized) {
        if ([self.delegate respondsToSelector:@selector(bottomSheet:didMaximizeSheet:)]) {
            [self.delegate bottomSheet:self didMaximizeSheet:animator.managedSheet.embeddedViewController];
        }
    }
}

- (BOOL)animatorShouldBeginGestureDrivenTransition:(STIBottomSheetAnimator *)animator {
    if (!self.isEnabled) {
        return NO;
    }
    
    return YES;
}

- (void)animator:(STIBottomSheetAnimator *)animator updateTransition:(CGFloat)fractionCompleted {
    self.dimmingView.alpha = 0.5 * fractionCompleted;
}

// MARK: - STISheetContainerViewControllerDelegate

- (void)sheetContainerDidSelectClose:(STISheetContainerViewController *)sheet {
    [self closeBottomSheet:sheet.embeddedViewController];
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


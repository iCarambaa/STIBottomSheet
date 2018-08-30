//
//  STIBottomSheetAnimator.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 03.08.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import "STIBottomSheetAnimator.h"
#import "STISheetContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat kInitialAnimationDuration = 0.5;

@interface STIBottomSheetAnimator() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) NSLayoutConstraint *topConstraint;

@property (nonatomic) STIBottomSheetPosition position;
@property (nonatomic) CGFloat sheetPosition;
@property (nonatomic) CGFloat startPosition;

@property (nonatomic, readonly) CGFloat maxConstant;
@property (nonatomic, readonly) CGFloat minConstant;
@property (weak, nonatomic) UIScrollView *embeddedScrollView;


@end

@implementation STIBottomSheetAnimator
@synthesize sheetPosition = _sheetPosition;

- (instancetype)initWithSheetViewController:(STISheetContainerViewController *)sheetViewController onViewController:(UIViewController *)viewController topConstraint:(NSLayoutConstraint *)constraint {
    self = [super init];
    if (self) {
        _managedSheet = sheetViewController;
        _presentingViewController = viewController;
        _topConstraint = constraint;
        _position = STIBottomSheetPositionMinimized;
        _sheetPosition = 0;
        [self attachGestureRecognizer];
        
    }
    return self;
}

- (void)moveToPosition:(STIBottomSheetPosition)position animateAlongside:(void (^)(void))animations {
    CGFloat moveToConstant = 0;
    switch (position) {
        case STIBottomSheetPositionMinimized:
            moveToConstant = self.minConstant;
        break;
        case STIBottomSheetPositionMaximized:
            moveToConstant = self.maxConstant;
        break;
        default:
            break;
    }
    self.position = position;
    [UIView animateWithDuration:kInitialAnimationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        [self setSheetPosition:moveToConstant];
        if (animations) {
            animations();
        }
        [self.presentingViewController.view layoutIfNeeded];
    } completion:nil];
}

- (void)attachGestureRecognizer {
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizerDidChange:)];
    recognizer.delegate = self;
    
    // Try to find a scrollview.
    UIScrollView *scrollView = nil;
    if ([self.managedSheet.embeddedViewController.view isKindOfClass:[UIScrollView class]]) {
        scrollView = (UIScrollView *) self.managedSheet.embeddedViewController.view;
    } else {
        for (UIView *subview in self.managedSheet.embeddedViewController.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                scrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    
    if (scrollView) {
        self.embeddedScrollView = scrollView;
        [scrollView.panGestureRecognizer requireGestureRecognizerToFail:recognizer];
    }
    [self.managedSheet.view addGestureRecognizer:recognizer];
}

- (void)panGestureRecognizerDidChange:(UIPanGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan:
        {
            self.startPosition = self.sheetPosition;
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGFloat position = self.startPosition + [gestureRecognizer translationInView:self.presentingViewController.view].y;
            
            // Rubberband below minimum.
            if (position > self.minConstant) {
                CGFloat difference = position - self.minConstant;
                position = self.minConstant + pow(difference, 0.7);
            }
            
            // Rubberband above maximum.
            if (position < self.maxConstant) {
                CGFloat difference = self.maxConstant - position;
                position = self.maxConstant - pow(difference, 0.7);
            }
            
            [self setSheetPosition:position];
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGFloat position = (self.startPosition + [gestureRecognizer translationInView:self.presentingViewController.view].y) * -1;
            CGFloat yVelocity = [gestureRecognizer velocityInView:self.presentingViewController.view].y;
            CGFloat target = [self targetForPosition:position withVelocity:yVelocity];
            CGFloat distanceRemaining = fabs(position - target);
            [self setStateForPosition:target];
            CGFloat velocity = (yVelocity != 0) ? distanceRemaining / yVelocity : 0;
            velocity = 1;
            [UIView animateWithDuration:kInitialAnimationDuration delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:velocity options:0 animations:^{
                [self setSheetPosition:target];
                [self.presentingViewController.view layoutIfNeeded];
            } completion:nil];

        }
            
    }
}

- (void)setStateForPosition:(CGFloat)position {
    if (position == self.maxConstant) {
        self.position = STIBottomSheetPositionMaximized;
    } else if (position == self.minConstant) {
        self.position = STIBottomSheetPositionMinimized;
    } else {
        self.position = STIBottomSheetPositionNotDetermined;
    }
}

- (CGFloat)targetForPosition:(CGFloat)position withVelocity:(CGFloat)velocity {
    CGFloat distance = self.maxConstant - self.minConstant;
    CGFloat fractionComplete = 1 - position / distance;
    
    if (velocity > 50) {
        return self.minConstant;
    } else if (velocity < -50) {
        return self.maxConstant;
    }
    
    if (fractionComplete > 0.5) {
        return self.maxConstant;
    } else {
        return self.minConstant;
    }
}

- (void)setDelegate:(id<STIBottomSheetAnimatorDelegate> _Nullable)delegate {
    _delegate = delegate;
    _sheetPosition = self.minConstant;
}

// MARK: Converting between coordinate spaces.

- (CGFloat)convertFromSheetToDelegateSpace:(CGFloat)value {
    CGFloat s_min = self.minConstant;
    CGFloat s_max = self.maxConstant;
    CGFloat d_min = [self.delegate animator:self topConstraintConstantForPosition:STIBottomSheetPositionMinimized];
    CGFloat d_max = [self.delegate animator:self topConstraintConstantForPosition:STIBottomSheetPositionMaximized];
    CGFloat m = (d_max - d_min) / (s_max - s_min);
    CGFloat n = d_max - m * s_max;
    NSAssert(fabs((s_min * m + n) - d_min) < 0.01, @"Assert that equation matches both values");
    NSAssert(fabs((s_max * m + n) - d_max) < 0.01, @"Assert that equation matches both values");

    CGFloat result = m * value + n;
    return result;
}

- (CGFloat)convertFromDelegateToSheetSpace:(CGFloat)value {
    CGFloat s_min = self.minConstant;
    CGFloat s_max = self.maxConstant;
    CGFloat d_min = [self.delegate animator:self topConstraintConstantForPosition:STIBottomSheetPositionMinimized];
    CGFloat d_max = [self.delegate animator:self topConstraintConstantForPosition:STIBottomSheetPositionMaximized];
    CGFloat m = (s_max - s_min) / (d_max - d_min);
    CGFloat n = s_max - m * d_max;
    NSAssert(fabs((d_min * m + n) - s_min) < 0.01, @"Assert that equation matches both values");
    NSAssert(fabs((d_max * m + n) - s_max) < 0.01, @"Assert that equation matches both values");
    
    CGFloat result = m * value + n;
    return result;
}

// MARK: UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    NSParameterAssert(gestureRecognizer);
    if ([self.delegate respondsToSelector:@selector(animatorShouldBeginGestureDrivenTransition:)]){
        if (![self.delegate animatorShouldBeginGestureDrivenTransition:self]) {
            return NO;
        }
    }
    
    CGPoint location = [gestureRecognizer locationInView:gestureRecognizer.view];
    if (location.y < 44 || self.position == STIBottomSheetPositionMinimized) {
        return YES;
    } else if (self.position == STIBottomSheetPositionMaximized) {
        if (self.embeddedScrollView.contentOffset.y + self.embeddedScrollView.adjustedContentInset.top > 0) {
            return NO;
        }
        CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:gestureRecognizer.view];
        if (velocity.y > 10) {
            return YES;
        }
    }
    
    return NO;
}

- (void)updateDelegateWithAnimationProgress {
    CGFloat distance = self.minConstant - self.maxConstant;
    CGFloat remainingDistance = self.sheetPosition - self.maxConstant;
    
    CGFloat progress = 1;
    if (remainingDistance != 0) {
        progress = 1 - remainingDistance / distance;
    }
    if ([self.delegate respondsToSelector:@selector(animator:updateTransition:)]) {
        [self.delegate animator:self updateTransition:progress];
    }
}

// MARK: Getting and setting

- (void)setSheetPosition:(CGFloat)sheetPosition {
    _sheetPosition = sheetPosition;
    self.topConstraint.constant = [self convertFromSheetToDelegateSpace:sheetPosition];
    [self updateDelegateWithAnimationProgress];
}

- (CGFloat)sheetPosition {
    return _sheetPosition;
}

- (void)setPosition:(STIBottomSheetPosition)position {
    _position = position;
    if ([self.delegate respondsToSelector:@selector(animator:didMoveToPosition:)]) {
        [self.delegate animator:self didMoveToPosition:position];
    }
}

// MARK: Quick Access

- (CGFloat)minConstant {
    CGFloat constraintFromBottom = [self.delegate animator:self topConstraintConstantForPosition:STIBottomSheetPositionMinimized];
    CGFloat converted = CGRectGetHeight(self.presentingViewController.view.frame) - constraintFromBottom * -1;
    return converted;
}

- (CGFloat)maxConstant {
    CGFloat constraintFromBottom = [self.delegate animator:self topConstraintConstantForPosition:STIBottomSheetPositionMaximized];
    CGFloat converted = CGRectGetHeight(self.presentingViewController.view.frame) - constraintFromBottom * -1;
    return converted;
}

@end

NS_ASSUME_NONNULL_END


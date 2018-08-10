//
//  STIBottomSheetAnimator.h
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 03.08.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

@import UIKit;

NS_ASSUME_NONNULL_BEGIN
@class STIBottomSheetAnimator;
@class STISheetContainerViewController;

typedef NS_ENUM(NSInteger, STIBottomSheetPosition) {
    STIBottomSheetPositionNotDetermined,
    STIBottomSheetPositionMinimized,
    STIBottomSheetPositionMaximized
};

@protocol STIBottomSheetAnimatorDelegate <NSObject>

- (CGFloat)animator:(STIBottomSheetAnimator *)animator topConstraintConstantForPosition:(STIBottomSheetPosition)position;

@optional
- (CGFloat)animator:(STIBottomSheetAnimator *)animator didMoveToPosition:(STIBottomSheetPosition)position;


/**
 Updates the delegate of the animation progress. 1 means sheet is maximized, 0 means minimized. May overshoot while dragging.

 @param animator 
 @param fractionCompleted
 */
- (void)animator:(STIBottomSheetAnimator *)animator updateTransition:(CGFloat)fractionCompleted;

@end

@interface STIBottomSheetAnimator : NSObject

@property (strong, nonatomic, readonly) STISheetContainerViewController *managedSheet;
@property (strong, nonatomic, readonly) UIViewController *presentingViewController;
@property (weak, nonatomic) id<STIBottomSheetAnimatorDelegate> delegate;

- (instancetype)initWithSheetViewController:(STISheetContainerViewController *)sheetViewController onViewController:(UIViewController *)viewController topConstraint:(NSLayoutConstraint *)constraint;

@end

NS_ASSUME_NONNULL_END

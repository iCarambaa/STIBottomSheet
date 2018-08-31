//
//  STIBottomSheetViewController.h
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 27.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class STIBottomSheetViewController;

@protocol STIBottomSheetViewControllerDelegate <NSObject>
@optional

- (void)bottomSheet:(STIBottomSheetViewController *)bottomSheet didCloseSheet:(UIViewController *)sheet;
@end

/**
 Container view controller used to add bottom sheets to.
 */
@interface STIBottomSheetViewController : UIViewController


/**
 Refers to the contained child on top of which the bottom sheets are presented.
 */
@property (strong, nonatomic, readonly) UIViewController *rootViewController;

@property (weak, nonatomic) id<STIBottomSheetViewControllerDelegate> delegate;

/**
 Set this to `NO` to disable moving the bottom sheets.
 */
@property (nonatomic, assign, getter=isEnabled) BOOL enabled;
/**
 Initializes a new controller which contains the specified `rootViewController`.

 @param rootViewController a UIViewController on top of which bottom sheets will be presented.
 @return A freshly initialized instance.
 */
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController NS_DESIGNATED_INITIALIZER;
    
- (instancetype)initWithCoder:(NSCoder *)aDecoder __unavailable;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil __unavailable;

    
/**
 Adds a new view controller as bottom sheet. Bottom sheets are added on top of each other in order.
 There will be a container added around the new bottom sheet which insets the safe area.

 @param bottomSheet UIViewController which will be added as bottom sheet.
 @param isClosable if YES the bottom sheet shows a close button.
 */
- (void)addBottomSheet:(UIViewController *)bottomSheet closable:(BOOL)isClosable;


/**
 Closes the bottom sheet animated. Calls the delegate after completion.

 @param bottomSheet the bottom sheet which will be closed.
 */
- (void)closeBottomSheet:(UIViewController *)bottomSheet;

- (void)maximizeSheet:(UIViewController *)sheet animateAlongside:(void (^)(void))animations;
- (void)minimizeSheet:(UIViewController *)sheet animateAlongside:(void (^)(void))animations;

@end

@interface UIViewController (STIBottomSheet)
@property (nonatomic, nullable, readonly) STIBottomSheetViewController *bottomSheetController;
@end

NS_ASSUME_NONNULL_END

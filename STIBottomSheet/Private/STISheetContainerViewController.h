//
//  STISheetContainerViewController.h
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 28.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface STISheetContainerViewController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *embeddedViewController;


- (instancetype)initWithViewController:(UIViewController *)viewController;
- (instancetype)initWithCoder:(NSCoder *)aDecoder __unavailable;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil __unavailable;

@end

NS_ASSUME_NONNULL_END

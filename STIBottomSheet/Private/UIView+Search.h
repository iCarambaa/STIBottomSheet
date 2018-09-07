//
//  UIView+Search.h
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 07.09.18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Search)

- (void)sti_enumerateViewsDepthFirst:(BOOL (^)(UIView *))block;

@end

NS_ASSUME_NONNULL_END

//
//  UIView+Search.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 07.09.18.
//

#import "UIView+Search.h"

@implementation UIView (Search)

- (void)sti_enumerateViewsDepthFirst:(BOOL (^)(UIView * _Nonnull))block {
    NSMutableArray <UIView *> *queue = [NSMutableArray new];
    [queue addObject:self];
    while (queue.count != 0) {
        for (UIView *view in queue.copy) {
            if (block(view)) {
                return;
            }
            [queue addObjectsFromArray:view.subviews];
            [queue removeObjectAtIndex:0];
        }
    }

}

@end

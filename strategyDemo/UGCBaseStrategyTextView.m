//
//  UGCBaseStrategyTextView.m
//  strategyDemo
//
//  Created by Courser on 2019/1/30.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyTextView.h"

@implementation UGCBaseStrategyTextView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) { // 防止textView的滚动与tableView冲突
        if (![gestureRecognizer.view isKindOfClass:[UITextView class]]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

@end

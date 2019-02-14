//
//  UGCBaseTableView.m
//  strategyDemo
//
//  Created by Courser on 2019/1/29.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseTableView.h"

@implementation UGCBaseTableView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.delaysContentTouches = YES;
    }
    return self;
}

- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view {
    return YES;
}

@end

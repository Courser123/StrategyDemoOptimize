//
//  UGCBaseStrategyCell.m
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyCell.h"

@interface UGCBaseStrategyCell ()

@property (nonatomic, weak) CAShapeLayer *imaginaryLine;
@property (nonatomic, weak) UIView *sortView;

@end

@implementation UGCBaseStrategyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (CAShapeLayer *)drawImaginaryLineWithRect:(CGRect)rect {
    
    CAShapeLayer *border = [CAShapeLayer layer];
    
    //虚线的颜色
    border.strokeColor = [UIColor greenColor].CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:rect].CGPath;
    
    border.frame = rect;
    //虚线的宽度
    border.lineWidth = 1.f;
    
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];

    [self.imaginaryLine removeFromSuperlayer];
    
    self.imaginaryLine = border;
    
    return border;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isEditing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                view.frame = CGRectMake(self.contentView.bounds.size.width - 30, self.contentView.bounds.size.height - 30, 20, 20);
                self.sortView = view;
                if (view.gestureRecognizers.count == 0) {
                    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
                    gesture.cancelsTouchesInView = NO;
                    gesture.minimumPressDuration = 0.5;
                    [view addGestureRecognizer:gesture];
                }
            }
            if ([NSStringFromClass([view class]) rangeOfString:@"Edit"].location != NSNotFound) {
                view.frame = CGRectZero;
            }
            if ([NSStringFromClass([view class]) rangeOfString:@"Content"].location != NSNotFound) {
                view.frame = self.bounds;
            }
        }
    }
    if (self.sortingState) {
        [self.layer addSublayer:[self drawImaginaryLineWithRect:self.bounds]];
    }else {
        [self.imaginaryLine removeFromSuperlayer];
    }
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.longPressCallBack) {
                self.longPressCallBack(self.sortView);
            }
        });
//        });
    }else if (gestureRecognizer.state == UIGestureRecognizerStateEnded || gestureRecognizer.state == UIGestureRecognizerStateFailed) {
        if (self.restore) {
            self.restore(YES);
        }
    }else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        if (self.restore) {
            self.restore(NO);
        }
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing: editing animated:YES];
    if (editing && self.viewModel.node.nodeType == CPSDNodeTypeText) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                view.hidden = YES;
            }
        }
    }else {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                view.hidden = NO;
            }
        }
    }
    
}


@end

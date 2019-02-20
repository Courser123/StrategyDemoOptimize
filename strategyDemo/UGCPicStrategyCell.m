//
//  UGCPicStrategyCell.m
//  strategyDemo
//
//  Created by Courser on 2019/1/29.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCPicStrategyCell.h"

@interface UGCPicStrategyCell ()

@property (nonatomic, strong) UIImageView *picImageView;
@property (nonatomic, strong) UIImageView *sortView; // 用来锚点的view

@end

@implementation UGCPicStrategyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.focusStyle = UITableViewCellFocusStyleCustom;
        self.picImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.picImageView];
        
        self.sortView = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.sortView.userInteractionEnabled = YES;
        self.sortView.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(_longPress:)];
        [self.sortView addGestureRecognizer:longPress];
        [self.contentView addSubview:self.sortView];
        [self.contentView sendSubviewToBack:self.sortView];
    }
    return self;
}

- (void)setViewModel:(UGCBaseStrategyViewModel *)viewModel {
    _viewModel = viewModel;
    self.picImageView.image = viewModel.model.image;
}

- (void)_longPress:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.longPressCallBack) {
            self.longPressCallBack(self.sortView);
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isEditing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                view.frame = CGRectMake(self.contentView.bounds.size.width - 30, self.contentView.bounds.size.height - 30, 20, 20);
                if (view.gestureRecognizers.count == 0) {
                    UILongPressGestureRecognizer *gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
                    gesture.cancelsTouchesInView = NO;
                    gesture.minimumPressDuration = 0.150;
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
    CGRect frame = self.contentView.bounds;
    frame.origin.x = 10;
    frame.size.width -= 20;
    self.picImageView.frame = frame;
    self.sortView.frame = CGRectMake(self.contentView.bounds.size.width - 30, self.contentView.bounds.size.height - 30, 20, 20);
}

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        if (self.longPressCallBack) {
            self.longPressCallBack(self.sortView);
        }
    }
}

//- (void)setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing: editing animated:YES];
//    if (editing) {
//        for (UIView * view in self.subviews) {
//            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
//                for (UIView * subview in view.subviews) {
//                    if ([subview isKindOfClass: [UIImageView class]]) {
//                        ((UIImageView *)subview).image = nil;
//                    }
//                }
//            }
//        }
//    }
//    
//}

@end

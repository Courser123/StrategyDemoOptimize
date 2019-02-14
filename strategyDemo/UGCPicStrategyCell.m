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

@end

@implementation UGCPicStrategyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.picImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.picImageView];
    }
    return self;
}

- (void)setViewModel:(UGCBaseStrategyViewModel *)viewModel {
    _viewModel = viewModel;
    self.picImageView.image = viewModel.model.image;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (self.isEditing) {
        for (UIView * view in self.subviews) {
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
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing: editing animated:YES];
    if (editing) {
        for (UIView * view in self.subviews) {
            if ([NSStringFromClass([view class]) rangeOfString:@"Reorder"].location != NSNotFound) {
                for (UIView * subview in view.subviews) {
                    if ([subview isKindOfClass: [UIImageView class]]) {
                        ((UIImageView *)subview).image = nil;
                    }
                }
            }
        }
    }
    
}

@end

//
//  UGCPicStrategyCell.m
//  strategyDemo
//
//  Created by Courser on 2019/1/29.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCPicStrategyCell.h"
#import "UIImageView+WebCache.h"

@interface UGCPicStrategyCell ()

@property (nonatomic, strong) UIImageView *picImageView;

@end

@implementation UGCPicStrategyCell

@synthesize viewModel = _viewModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.picImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:self.picImageView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self.picImageView sd_setImageWithURL:nil];
}

- (void)setViewModel:(UGCBaseStrategyViewModel *)viewModel {
    _viewModel = viewModel;
//    self.picImageView.image = ((CPSDImageNode *)viewModel.node).image;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:((CPSDImageNode *)viewModel.node).picURL]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect frame = self.contentView.bounds;
    frame.origin.x = 10;
    frame.size.width -= 20;
    self.picImageView.frame = frame;
}

@end

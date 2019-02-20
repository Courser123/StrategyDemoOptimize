//
//  UGCBaseStrategyCell.h
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCBaseStrategyViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyCell : UITableViewCell

@property (nonatomic, strong) UGCBaseStrategyViewModel *viewModel;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) void(^longPressCallBack)(UIView *sortView);
@property (nonatomic, copy) void(^restore)(BOOL changeDataSource);

@property (nonatomic, assign) BOOL sortingState;

- (CAShapeLayer *)drawImaginaryLineWithRect:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END

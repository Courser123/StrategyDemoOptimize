//
//  UGCPicStrategyCell.h
//  strategyDemo
//
//  Created by Courser on 2019/1/29.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyCell.h"
#import "UGCBaseStrategyViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCPicStrategyCell : UGCBaseStrategyCell

@property (nonatomic, copy) void(^longPressCallBack)(UIImageView *sortView);

@end

NS_ASSUME_NONNULL_END

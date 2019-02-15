//
//  UGCBaseStrategyTextView.h
//  strategyDemo
//
//  Created by Courser on 2019/1/30.
//  Copyright © 2019 Courser. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyTextView : UITextView

@property (nonatomic, copy) void(^deleteBackwardCallBack)(void);

@end

NS_ASSUME_NONNULL_END

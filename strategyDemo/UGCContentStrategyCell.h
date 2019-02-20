//
//  UGCContentStrategyCell.h
//  strategyDemo
//
//  Created by Courser on 2019/2/20.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyCell.h"
#import "UGCBaseStrategyViewModel.h"
#import "UGCBaseStrategyTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCContentStrategyCell : UGCBaseStrategyCell

@property (nonatomic, strong) UGCBaseStrategyTextView *textView;
@property (nonatomic, assign, readonly) BOOL isFirstResponder;
@property (nonatomic, assign) NSRange selectedRange;

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

+ (CGFloat)originHeight;

@end

NS_ASSUME_NONNULL_END

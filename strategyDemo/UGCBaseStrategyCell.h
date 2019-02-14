//
//  UGCBaseStrategyCell.h
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGCBaseStrategyViewModel.h"
#import "UGCBaseStrategyTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyCell : UITableViewCell

@property (nonatomic, strong) UGCBaseStrategyTextView *textView;
//@property (nonatomic, assign) BOOL split; // 拆分
//@property (nonatomic, assign) BOOL blend; // 融合
@property (nonatomic, assign, readonly) BOOL isFirstResponder;
@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, copy) void(^changeHeightCompleted)(CGFloat aimHeight);
//@property (nonatomic, copy) void(^changeHeight)(NSInteger index, CGFloat aimHeight, BOOL needScroll, void(^changeHeightCompleted)(CGFloat aimHeight));
//@property (nonatomic, copy) void(^textViewDidBeginEditing)(NSInteger index);
//@property (nonatomic, copy) void(^textViewDidChange)(NSString *text);
//@property (nonatomic, copy) void(^splitCell)(NSInteger index, UGCBaseStrategyViewModel *firstModel, UGCBaseStrategyViewModel *insertModel, UGCBaseStrategyViewModel *lastModel);

@property (nonatomic, strong) UGCBaseStrategyViewModel *viewModel;

@property (nonatomic, assign) NSRange selectedRange;

- (void)becomeFirstResponder;
- (void)resignFirstResponder;

+ (CGFloat)originHeight;

@end

NS_ASSUME_NONNULL_END

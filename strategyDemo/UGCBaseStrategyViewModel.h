//
//  UGCBaseStrategyViewModel.h
//  strategyDemo
//
//  Created by Courser on 2019/2/13.
//  Copyright © 2019 Courser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGCBaseStrategyModel.h"
#import <ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyViewModel : NSObject

@property (nonatomic, strong) RACDisposable *dispose;

@property (nonatomic, assign) NSRange selectedRange;

@property (nonatomic, strong) UGCBaseStrategyModel *model;

@property (nonatomic, strong) UGCBaseStrategyViewModel *lastViewModel;

@property (nonatomic, strong) UGCBaseStrategyViewModel *nextViewModel;

@property (nonatomic, copy, nullable) void(^getCursorRect)(CGRect cursorRect);

@property (nonatomic, copy) void(^textViewDidBeginEditing)(NSInteger index);

@property (nonatomic, copy) void(^blendContent)(NSInteger index, UGCBaseStrategyViewModel *lastViewModel, UGCBaseStrategyViewModel *currentViewModel);

@property (nonatomic, copy) void(^blendDataSource)(NSInteger index, NSRange selectedRange, UGCBaseStrategyViewModel *lastViewModel, UGCBaseStrategyViewModel *currentViewModel);

@property (nonatomic, copy) void(^splitContent)(NSInteger index, NSRange selectedRange); // selectedRange可以理解为光标位置,textView属性

@property (nonatomic, copy) void(^splitDataSource)(NSInteger index, NSRange selectedRange, UGCBaseStrategyViewModel *currentViewModel, UGCBaseStrategyViewModel *nextViewModel);

@property (nonatomic, copy) void(^addPic)(NSInteger index, NSRange selectedRange, UIImage *image);

@property (nonatomic, copy) void(^addPicDataSource)(NSInteger index, UGCBaseStrategyViewModel *firstModel, UGCBaseStrategyViewModel *insertModel, UGCBaseStrategyViewModel *lastModel);

- (instancetype)initWithStrategyModel:(UGCBaseStrategyModel *)model;

- (void)reset;

@end

NS_ASSUME_NONNULL_END

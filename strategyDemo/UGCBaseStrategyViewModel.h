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
#import "CPSDNode.h"
#import "CPSDTextNode.h"
#import "CPSDImageNode.h"
#import "CPSDVideoNode.h"
#import "CPSDCustomNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyViewModel : NSObject

@property (nonatomic, strong) RACDisposable *dispose;

@property (nonatomic, assign) NSRange selectedRange;

//@property (nonatomic, strong) UGCBaseStrategyModel *model;

@property (nonatomic, strong) CPSDNode *node;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat sortingHeight;

@property (nonatomic, strong) UGCBaseStrategyViewModel *lastViewModel;

@property (nonatomic, strong) UGCBaseStrategyViewModel *nextViewModel;

@property (nonatomic, copy, nullable) void(^getCursorRect)(CGRect cursorRect);

@property (nonatomic, copy) void(^textViewDidBeginEditing)(NSInteger index);

@property (nonatomic, copy) void(^addPic)(NSInteger index, NSRange selectedRange, UIImage *image);

@property (nonatomic, copy) void(^addPicDataSource)(NSInteger index, UGCBaseStrategyViewModel *firstViewModel, UGCBaseStrategyViewModel *insertViewModel, UGCBaseStrategyViewModel *lastViewModel);

- (instancetype)initWithNode:(CPSDNode *)node;

- (void)reset;

@end

NS_ASSUME_NONNULL_END

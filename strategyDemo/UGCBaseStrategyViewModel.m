//
//  UGCBaseStrategyViewModel.m
//  strategyDemo
//
//  Created by Courser on 2019/2/13.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyViewModel.h"

@implementation UGCBaseStrategyViewModel

- (instancetype)initWithStrategyModel:(UGCBaseStrategyModel *)model {
    if (self = [super init]) {
        self.model = model;
        self.selectedRange = NSMakeRange(-1, -1);
    }
    return self;
}

- (void)setModel:(UGCBaseStrategyModel *)model {
    _model = model;
    [self _blendContent];
    [self _splitContent];
    [self _addPic];
}

- (void)_blendContent {
    __weak typeof(self) weakSelf = self;
    self.blendContent = ^(NSInteger index, UGCBaseStrategyViewModel * _Nonnull lastViewModel, UGCBaseStrategyViewModel * _Nonnull currentViewModel) {
        if (!currentViewModel || !lastViewModel) {
            return;
        }
        NSRange selectedRange = NSMakeRange(lastViewModel.model.content.length, 0);
        if ((currentViewModel.model.type == UGCBaseStrategyTypeContent) && (lastViewModel.model.type == currentViewModel.model.type)) {
            lastViewModel.model.content = [lastViewModel.model.content stringByAppendingString:currentViewModel.model.content];
        }
        if (weakSelf.blendDataSource) {
            weakSelf.blendDataSource(index, selectedRange, lastViewModel, currentViewModel);
        }
    };
}

- (void)_splitContent {
    __weak typeof(self) weakSelf = self;
    self.splitContent = ^(NSInteger index, NSRange selectedRange) {
        UGCBaseStrategyViewModel *currentViewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:[UGCBaseStrategyModel new]];
        NSString *firstStr = [weakSelf.model.content substringToIndex:selectedRange.location];
        currentViewModel.model.type = UGCBaseStrategyTypeContent;
        currentViewModel.model.content = firstStr;
        
        UGCBaseStrategyViewModel *nextViewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:[UGCBaseStrategyModel new]];
        NSString *lastStr = [weakSelf.model.content substringFromIndex:selectedRange.location];
        nextViewModel.model.type = UGCBaseStrategyTypeContent;
        nextViewModel.model.content = lastStr;
        
        if (weakSelf.splitDataSource) {
            weakSelf.splitDataSource(index, NSMakeRange(0, 0), currentViewModel, nextViewModel);
        }
    };
}

- (void)_addPic {
    __weak typeof(self) weakSelf = self;
    self.addPic = ^(NSInteger index, NSRange selectedRange, UIImage * _Nonnull image) {
        UGCBaseStrategyViewModel *fistModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:[UGCBaseStrategyModel new]];
        NSString *firstStr = [weakSelf.model.content substringToIndex:selectedRange.location];
        fistModel.model.type = UGCBaseStrategyTypeContent;
        fistModel.model.content = firstStr;
        
        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:[UGCBaseStrategyModel new]];
        viewModel.model.type = UGCBaseStrategyTypePic;
        viewModel.model.image = image;
        
        UGCBaseStrategyViewModel *lastModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:[UGCBaseStrategyModel new]];
        NSString *lastStr = [weakSelf.model.content substringFromIndex:selectedRange.location];
        lastModel.model.type = UGCBaseStrategyTypeContent;
        lastModel.model.content = lastStr;
        
        if (weakSelf.addPicDataSource) {
            weakSelf.addPicDataSource(index, fistModel, viewModel, lastModel);
        }
    };
}

- (void)reset {
    [self.dispose dispose];
}

@end

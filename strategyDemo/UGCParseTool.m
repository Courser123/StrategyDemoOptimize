//
//  UGCParseTool.m
//  strategyDemo
//
//  Created by Courser on 2019/2/18.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCParseTool.h"

@interface UGCParseTool ()

@property (nonatomic, copy) NSArray *viewModelList;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray <NSString *> *contentList;

@end

@implementation UGCParseTool

- (instancetype)init {
    if (self = [super init]) {
        self.contentList = [NSMutableArray array];
    }
    return self;
}

- (NSArray<UGCBaseStrategyViewModel *> *)blendDataSource:(NSArray<UGCBaseStrategyViewModel *> *)viewModelList {
    self.viewModelList = viewModelList;
    self.index = 0;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int idx = 0; idx < self.viewModelList.count; idx++) {
        if (idx < self.index) continue;
        UGCBaseStrategyViewModel *viewModel = [self.viewModelList objectAtIndex:idx];
        if (viewModel.model.type == UGCBaseStrategyTypeContent) {
            self.index = idx + 1;
            self.content = viewModel.model.content ? : @"";
            [self recursionBlendDataSource];
            UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
            model.type = UGCBaseStrategyTypeContent;
            model.content = self.content;
            UGCBaseStrategyViewModel *tempViewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
            [tempArray addObject:tempViewModel];
            self.content = nil;
        }else {
            [tempArray addObject:viewModel];
        }
    }
    return tempArray.copy;
}

- (NSArray<UGCBaseStrategyViewModel *> *)splitDataSource:(NSArray<UGCBaseStrategyViewModel *> *)viewModelList {
    self.viewModelList = viewModelList;
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int idx = 0; idx < self.viewModelList.count; idx++) {
        UGCBaseStrategyViewModel *viewModel = [self.viewModelList objectAtIndex:idx];
        if (viewModel.model.type == UGCBaseStrategyTypeContent) {
            [self recursionSplitDataSourceWith:viewModel.model.content];
            if (self.contentList.count) {
                [self.contentList enumerateObjectsUsingBlock:^(NSString * _Nonnull content, NSUInteger idx, BOOL * _Nonnull stop) {
                    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
                    model.type = UGCBaseStrategyTypeContent;
                    model.content = content;
                    UGCBaseStrategyViewModel *tempViewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
                    [tempArray addObject:tempViewModel];
                }];
                self.contentList = [NSMutableArray array];
            }else {
                [tempArray addObject:viewModel];
            }
        }else {
            [tempArray addObject:viewModel];
        }
    }
    return tempArray.copy;
}

- (void)recursionBlendDataSource {
    if (self.index >= self.viewModelList.count) return;
    UGCBaseStrategyViewModel *viewModel = [self.viewModelList objectAtIndex:self.index];
    if (viewModel.model.type == UGCBaseStrategyTypeContent) {
        self.content = [self.content stringByAppendingString:@"\n"];
        self.content = [self.content stringByAppendingString:viewModel.model.content];
        self.index ++;
        [self recursionBlendDataSource];
    }else {
        return;
    }
    return;
}

- (void)recursionSplitDataSourceWith:(NSString *)content {
    if ([content containsString:@"\n"]) {
        NSRange range = [content rangeOfString:@"\n"];
        NSString *subContent = [content substringToIndex:range.location];
        [self.contentList addObject:subContent];
        [self recursionSplitDataSourceWith:[content substringFromIndex:range.location + 1]];
    }else {
        [self.contentList addObject:content];
        return;
    }
    return;
}

@end

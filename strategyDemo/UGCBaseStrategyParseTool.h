//
//  UGCParseTool.h
//  strategyDemo
//
//  Created by Courser on 2019/2/18.
//  Copyright © 2019 Courser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UGCBaseStrategyViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyParseTool : NSObject

// 合并相连的content(文本)数据
- (NSArray<UGCBaseStrategyViewModel *> *)blendDataSource:(NSArray <UGCBaseStrategyViewModel *> *)viewModelList;

// 拆分相连并带换行符的content(文本)数据
- (NSArray<UGCBaseStrategyViewModel *> *)splitDataSource:(NSArray <UGCBaseStrategyViewModel *> *)viewModelList;

@end

NS_ASSUME_NONNULL_END

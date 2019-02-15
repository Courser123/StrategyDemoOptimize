//
//  UGCFakeData.m
//  strategyDemo
//
//  Created by Courser on 2019/1/30.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCFakeData.h"
#import "UGCBaseStrategyModel.h"

@implementation UGCFakeData

- (instancetype)init {
    if (self = [super init]) {
        [self generateFakeData];
    }
    return self;
}

- (void)generateFakeData {
    NSMutableArray *nsArr = [NSMutableArray array];
//    for (int i = 0; i < 3; i++) {
//        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
//        model.type = UGCBaseStrategyTypeContent;
//        model.content = @"test";
//        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
//        [nsArr addObject:viewModel];
//    }
//
//    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
//    model.type = UGCBaseStrategyTypePic;
//    model.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
//    UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
//    [nsArr addObject:viewModel];
//
//    for (int i = 0; i < 6; i++) {
//        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
//        model.type = UGCBaseStrategyTypeContent;
//        model.content = @"UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];UGCBaseStrategyCell *cell = [tableView dequeueReusableCellWithIdentifier:@""];";
//        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
//        [nsArr addObject:viewModel];
//    }
    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
    model.type = UGCBaseStrategyTypeContent;
    model.content = @"";
    UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
    [nsArr addObject:viewModel];
    
    self.modelList = nsArr.copy;
}

@end

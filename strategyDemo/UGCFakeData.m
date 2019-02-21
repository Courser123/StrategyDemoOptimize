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
    for (int i = 0; i < 3; i++) {
        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
        model.type = UGCBaseStrategyTypeContent;
        model.content = @"test";
        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
        [nsArr addObject:viewModel];
    }

    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
    model.type = UGCBaseStrategyTypePic;
    model.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
    UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
    [nsArr addObject:viewModel];

    for (int i = 0; i < 3; i++) {
        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
        model.type = UGCBaseStrategyTypeContent;
        model.content = @"CGRect cursorRect = [weakCell.textView caretRectForPosition:weakCell.textView.selectedTextRange.start];";
        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
        [nsArr addObject:viewModel];
    }
    
//    UGCBaseStrategyModel *model2 = [UGCBaseStrategyModel new];
//    model2.type = UGCBaseStrategyTypePic;
//    model2.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
//    UGCBaseStrategyViewModel *viewModel2 = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model2];
//    [nsArr addObject:viewModel2];
//    
//    for (int i = 0; i < 3; i++) {
//        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
//        model.type = UGCBaseStrategyTypeContent;
//        model.content = @"test";
//        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
//        [nsArr addObject:viewModel];
//    }
//    
//    UGCBaseStrategyModel *model3 = [UGCBaseStrategyModel new];
//    model3.type = UGCBaseStrategyTypePic;
//    model3.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
//    UGCBaseStrategyViewModel *viewModel3 = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model3];
//    [nsArr addObject:viewModel3];
//    
//    for (int i = 0; i < 3; i++) {
//        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
//        model.type = UGCBaseStrategyTypeContent;
//        model.content = @"test";
//        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
//        [nsArr addObject:viewModel];
//    }
    
//    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
//    model.type = UGCBaseStrategyTypeContent;
//    model.content = @"";
//    UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
//    [nsArr addObject:viewModel];
    
    self.modelList = nsArr.copy;
}

@end

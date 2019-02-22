//
//  UGCFakeData.m
//  strategyDemo
//
//  Created by Courser on 2019/1/30.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCFakeData.h"
#import "UGCBaseStrategyModel.h"
#import "UGCCityInsightDataProcessor.h"

@implementation UGCFakeData

- (instancetype)init {
    if (self = [super init]) {
        [self generateFakeData];
    }
    return self;
}

- (void)generateFakeData {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.txt" ofType:nil];
    
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    UGCCityInsightDataProcessor *processor = [UGCCityInsightDataProcessor new];
    
    NSArray <CPSDNode *> *array = [processor parsedListWithString:string];
    
    NSMutableArray *nsArr = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(CPSDNode * _Nonnull node, NSUInteger idx, BOOL * _Nonnull stop) {
        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:node];
        [nsArr addObject:viewModel];
    }];
    
    self.modelList = nsArr.copy;

}

//- (void)generateFakeData {
//    NSMutableArray *nsArr = [NSMutableArray array];
//    for (int i = 0; i < 3; i++) {
////        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
////        model.type = UGCBaseStrategyTypeContent;
////        model.content = @"test";
//        CPSDTextNode *textNode = [CPSDTextNode new];
//        textNode.nodeType = CPSDNodeTypeText;
//        textNode.text = @"test";
//        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:textNode];
//        [nsArr addObject:viewModel];
//    }
//
////    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
////    model.type = UGCBaseStrategyTypePic;
////    model.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
//    CPSDImageNode *node = [CPSDImageNode new];
//    node.nodeType = CPSDNodeTypeImage;
//    node.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
//    UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:node];
//    [nsArr addObject:viewModel];
//
//    for (int i = 0; i < 3; i++) {
////        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
////        model.type = UGCBaseStrategyTypeContent;
////        model.content = @"CGRect cursorRect = [weakCell.textView caretRectForPosition:weakCell.textView.selectedTextRange.start];";
//        CPSDTextNode *textNode = [CPSDTextNode new];
//        textNode.nodeType = CPSDNodeTypeText;
//        textNode.text = @"CGRect cursorRect = [weakCell.textView caretRectForPosition:weakCell.textView.selectedTextRange.start];";
//        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:textNode];
//        [nsArr addObject:viewModel];
//    }
//
////    UGCBaseStrategyModel *model2 = [UGCBaseStrategyModel new];
////    model2.type = UGCBaseStrategyTypePic;
////    model2.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
////    UGCBaseStrategyViewModel *viewModel2 = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model2];
////    [nsArr addObject:viewModel2];
////
////    for (int i = 0; i < 3; i++) {
////        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
////        model.type = UGCBaseStrategyTypeContent;
////        model.content = @"test";
////        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
////        [nsArr addObject:viewModel];
////    }
////
////    UGCBaseStrategyModel *model3 = [UGCBaseStrategyModel new];
////    model3.type = UGCBaseStrategyTypePic;
////    model3.image = [UIImage imageNamed:@"3bc6780bd1b3dffa71463150f3b16bac.jpeg"];
////    UGCBaseStrategyViewModel *viewModel3 = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model3];
////    [nsArr addObject:viewModel3];
////
////    for (int i = 0; i < 3; i++) {
////        UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
////        model.type = UGCBaseStrategyTypeContent;
////        model.content = @"test";
////        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
////        [nsArr addObject:viewModel];
////    }
//
////    UGCBaseStrategyModel *model = [UGCBaseStrategyModel new];
////    model.type = UGCBaseStrategyTypeContent;
////    model.content = @"";
////    UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithStrategyModel:model];
////    [nsArr addObject:viewModel];
//
//    self.modelList = nsArr.copy;
//}

@end

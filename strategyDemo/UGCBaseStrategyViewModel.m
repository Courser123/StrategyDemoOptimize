//
//  UGCBaseStrategyViewModel.m
//  strategyDemo
//
//  Created by Courser on 2019/2/13.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyViewModel.h"

@implementation UGCBaseStrategyViewModel

- (instancetype)initWithNode:(CPSDNode *)node {
    if (self = [super init]) {
        self.sortingHeight = 150;
        self.node = node;
        self.selectedRange = NSMakeRange(-1, -1);
    }
    return self;
}

- (void)setNode:(CPSDNode *)node {
    _node = node;
    [self _addPic];
}

- (void)_addPic {
    __weak typeof(self) weakSelf = self;
    self.addPic = ^(NSInteger index, NSRange selectedRange, UIImage * _Nonnull image) {
        CPSDTextNode *firstTextNode = [CPSDTextNode new];
        firstTextNode.nodeType = CPSDNodeTypeText;
        firstTextNode.text = [((CPSDTextNode *)weakSelf.node).text substringToIndex:selectedRange.location];
        UGCBaseStrategyViewModel *firstViewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:firstTextNode];
        
        CPSDImageNode *imageNode = [CPSDImageNode new];
        imageNode.nodeType = CPSDNodeTypeImage;
        imageNode.image = image;
        UGCBaseStrategyViewModel *viewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:imageNode];
        
        CPSDTextNode *lastTextNode = [CPSDTextNode new];
        lastTextNode.nodeType = CPSDNodeTypeText;
        lastTextNode.text = [((CPSDTextNode *)weakSelf.node).text substringFromIndex:selectedRange.location];
        UGCBaseStrategyViewModel *lastViewModel = [[UGCBaseStrategyViewModel alloc] initWithNode:lastTextNode];
        
        if (weakSelf.addPicDataSource) {
            weakSelf.addPicDataSource(index, firstViewModel, viewModel, lastViewModel);
        }
        
    };
}

- (void)reset {
    [self.dispose dispose];
}

@end

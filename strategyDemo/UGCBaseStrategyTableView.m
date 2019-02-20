//
//  UGCBaseStrategyTableView.m
//  strategyDemo
//
//  Created by Courser on 2019/2/19.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "UGCBaseStrategyTableView.h"

@implementation UGCBaseStrategyTableView

- (void) didAddSubview:(UIView *)subview
{
    [super didAddSubview:subview];
    
    if([subview.class.description isEqualToString:@"UIShadowView"]) {
        subview.hidden = YES;
    }
}

@end

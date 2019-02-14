//
//  ViewController.m
//  strategyDemo
//
//  Created by Courser on 2019/1/28.
//  Copyright © 2019 Courser. All rights reserved.
//

#import "ViewController.h"
#import "UGCBaseStrategyViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UGCBaseStrategyViewController *vc = [UGCBaseStrategyViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

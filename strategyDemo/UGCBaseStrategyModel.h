//
//  UGCBaseStrategyModel.h
//  strategyDemo
//
//  Created by Courser on 2019/1/31.
//  Copyright © 2019 Courser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UGCBaseStrategyType) {
    UGCBaseStrategyTypeContent = 1, // default
    UGCBaseStrategyTypePic,
    UGCBaseStrategyTypeVideo,
    UGCBaseStrategyTypePOI,
};

NS_ASSUME_NONNULL_BEGIN

@interface UGCBaseStrategyModel : NSObject

@property (nonatomic, assign) UGCBaseStrategyType type;
@property (nonatomic, assign) CGFloat height;

//UGCBaseStrategyTypeContent
@property (nonatomic, copy) NSString *content;

//UGCBaseStrategyTypePic
@property (nonatomic, strong) UIImage *image;

@end

NS_ASSUME_NONNULL_END

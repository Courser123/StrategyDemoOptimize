//
//  CPSDNode.h
//  CropImageView
//
//  Created by welson on 2019/1/31.
//  Copyright © 2019 welson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPSDNodeType.h"

@interface CPSDNode : NSObject

@property (nonatomic, assign) CPSDNodeType nodeType;
@property (nonatomic, strong) NSDictionary *styles;
@property (nonatomic, strong) NSDictionary *ex;

@end

//
//  CPSDImageNode.h
//  CropImageView
//
//  Created by welson on 2019/1/31.
//  Copyright © 2019 welson. All rights reserved.
//

#import "CPSDNode.h"
#import <UIKit/UIKit.h>

@interface CPSDImageNode : CPSDNode

@property (nonatomic, copy) NSString *picURL;
@property (nonatomic, copy) NSString *caption;

@property (nonatomic, assign) CGFloat picWidth;
@property (nonatomic, assign) CGFloat picHeight;
@property (nonatomic, copy) NSString *extension;

@end

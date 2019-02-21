//
//  CPSDParser.h
//  CropImageView
//
//  Created by welson on 2019/1/31.
//  Copyright © 2019 welson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPSDNode.h"

@interface CPSDParser : NSObject

- (NSArray<CPSDNode *> *)parsedListWithString:(NSString *)input;

@end

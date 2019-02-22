//
//  UGCCityInsightDataProcessor.h
//  UGCComposition
//
//  Created by welson on 2019/2/21.
//

#import <Foundation/Foundation.h>
#import "CPSDNode.h"

@interface UGCCityInsightDataProcessor : NSObject

- (NSArray<CPSDNode *> *)parsedListWithString:(NSString *)input;
- (NSString *)makeUpWithParsedList:(NSArray<CPSDNode *> *)nodes;

@end

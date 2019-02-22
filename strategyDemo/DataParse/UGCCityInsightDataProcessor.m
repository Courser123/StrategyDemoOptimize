//
//  UGCCityInsightDataProcessor.m
//  UGCComposition
//
//  Created by welson on 2019/2/21.
//

#import "UGCCityInsightDataProcessor.h"
#import "CPSDParser.h"

@interface UGCCityInsightDataProcessor ()

@property (nonatomic, strong) CPSDParser *parser;

@end

@implementation UGCCityInsightDataProcessor

- (instancetype)init {
    if (self = [super init]) {
        _parser = [CPSDParser new];
    }
    return self;
}

- (NSArray<CPSDNode *> *)parsedListWithString:(NSString *)input {
    NSArray<CPSDNode *> *nodes = [self.parser parsedListWithString:input];
    
    NSMutableArray<CPSDNode *> *result = [NSMutableArray new];
    for (NSInteger i = 0; i < nodes.count; i++) {
        if ([self isValidNode:nodes[i]]) {
            [result addObject:nodes[i]];
        }
    }
    return result.copy;
}

- (BOOL)isValidNode:(CPSDNode *)node {
    BOOL isValid = NO;
    switch (node.nodeType) {
        case CPSDNodeTypeText:
        case CPSDNodeTypeImage:
        case CPSDNodeTypeVideo:
        case CPSDNodeTypeExclusive:
            isValid = YES;
            break;
            
        default:
            break;
    }
    return isValid;
}


- (NSString *)makeUpWithParsedList:(NSArray<CPSDNode *> *)nodes {
    return nil;
}
@end

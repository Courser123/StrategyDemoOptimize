//
//  CPSDParser.m
//  CropImageView
//
//  Created by welson on 2019/1/31.
//  Copyright © 2019 welson. All rights reserved.
//

#import "CPSDParser.h"
#import "CPSDDefinition.h"
#import "CPSDTextNode.h"
#import "CPSDImageNode.h"
#import "CPSDVideoNode.h"
#import "CPSDNode.h"
#import "CPSDCustomNode.h"

@implementation CPSDParser

- (NSArray<CPSDNode *> *)parsedListWithString:(NSString *)input {
    if (!input.length) {
        NSLog(@"empty input.");
        return nil;
    }
    id jsonObj = [NSJSONSerialization JSONObjectWithData:[input dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    if (![jsonObj isKindOfClass:[NSDictionary class]]) {
        NSLog(@"invalid input.");
        return nil;
    }
    
    NSMutableArray<CPSDNode *> *nodeList = [NSMutableArray new];
    
    NSDictionary *root = (NSDictionary *)jsonObj;
    CPSDNodeType rootType = [root[CPSDType] integerValue];
    NSArray *style = root[CPSDStyles];
    NSMutableArray<id> *allKeys = [[style valueForKey:CPSDStyleType] mutableCopy];
    [allKeys removeObjectIdenticalTo:[NSNull null]];
    NSMutableArray<id> *allValues = [[style valueForKey:CPSDStyleValue] mutableCopy];
    [allValues removeObjectIdenticalTo:[NSNull null]];
    
    NSDictionary *rootStyle = [NSDictionary dictionaryWithObjects:allValues forKeys:allKeys];
    CPSDNode *rootNode = [CPSDNode new];
    rootNode.nodeType = rootType;
    rootNode.styles = rootStyle;
    [nodeList addObject:rootNode];
    
    NSArray<CPSDNode *> *childNodes = [self parseChildren:root[CPSDChildren] styles:nil];
    if (childNodes.count) [nodeList addObjectsFromArray:childNodes];
    return nodeList.copy;
}

- (NSArray<CPSDNode *> *)parseChildren:(NSArray<NSDictionary *> *)childs
                                styles:(NSDictionary *)styles {
    NSMutableArray<CPSDNode *> *nodes = [NSMutableArray new];
    for (NSInteger i = 0; i < childs.count; i++) {
        NSDictionary *child = childs[i];
        CPSDNodeType type = [child[CPSDType] integerValue];
        NSArray *style = child[CPSDStyles];
        NSMutableArray<id> *allKeys = [[style valueForKey:CPSDStyleType] mutableCopy];
        [allKeys removeObjectIdenticalTo:[NSNull null]];
        NSMutableArray<id> *allValues = [[style valueForKey:CPSDStyleValue] mutableCopy];
        [allValues removeObjectIdenticalTo:[NSNull null]];
        
        NSDictionary *childStyle = [NSDictionary dictionaryWithObjects:allValues forKeys:allKeys];
        NSMutableDictionary *stylesMutableCopy = styles?styles.mutableCopy:[NSMutableDictionary new];
        [stylesMutableCopy addEntriesFromDictionary:childStyle];
        
        BOOL leaf = [self leafNode:type];
        if (!leaf) {
            CPSDNode *node = [CPSDNode new];
            node.nodeType = type;
            node.styles = childStyle;
            [nodes addObject:node];
            
            NSArray<CPSDNode *> *childNodes = [self parseChildren:child[CPSDChildren] styles:stylesMutableCopy];
            if (childNodes.count) [nodes addObjectsFromArray:childNodes];
        }else {
            CPSDNode *node = [self createLeafNodeWithType:type info:child styles:stylesMutableCopy];
            if (node) [nodes addObject:node];
        }
    }
    return nodes;
}

- (CPSDNode *)createLeafNodeWithType:(CPSDNodeType)nodeType
                                info:(NSDictionary *)info
                              styles:(NSDictionary *)styles {
    CPSDNode *node = nil;
    switch (nodeType) {
        case CPSDNodeTypeText:
            node = [CPSDTextNode new];
            node.nodeType = nodeType;
            node.styles = styles;
            node.ex = info[CPSDExtra];
            ((CPSDTextNode *)node).text = info[CPSDText];
            break;
        case CPSDNodeTypeImage:
            node = [CPSDImageNode new];
            node.nodeType = nodeType;
            node.styles = styles;
            node.ex = info[CPSDExtra];
            ((CPSDImageNode *)node).picURL = info[CPSDImageURL];
            ((CPSDImageNode *)node).extension = info[CPSDImageSuffix];
            ((CPSDImageNode *)node).caption = info[CPSDCaption];
            ((CPSDImageNode *)node).picWidth = info[CPSDWidth]?[info[CPSDWidth] doubleValue]:[styles[CPSDWidth] doubleValue];
            ((CPSDImageNode *)node).picHeight = info[CPSDHeight]?[info[CPSDHeight] doubleValue]:[styles[CPSDHeight] doubleValue];
            break;
        case CPSDNodeTypeVideo:
            node = [CPSDVideoNode new];
            node.nodeType = nodeType;
            node.styles = styles;
            node.ex = info[CPSDExtra];
            ((CPSDVideoNode *)node).videoID = info[CPSDVideoID];
            ((CPSDVideoNode *)node).videoURL = info[CPSDVideoURL];
            ((CPSDVideoNode *)node).coverURL = info[CPSDVideoCoverURL];
            break;
        case CPSDNodeTypeBlank:
            node = [CPSDNode new];
            node.nodeType = nodeType;
            node.styles = styles;
            node.ex = info[CPSDExtra];
            break;
        case CPSDNodeTypeExclusive:
            node = [CPSDCustomNode new];
            node.nodeType = nodeType;
            node.styles = styles;
            node.ex = info[CPSDExtra];
            ((CPSDCustomNode *)node).userinfo = info[CPSD_EXTRA];
            break;
        default:
            break;
    }
    return node;
}

- (BOOL)leafNode:(CPSDNodeType)nodeType {
    BOOL isLeaf = NO;
    switch (nodeType) {
        case CPSDNodeTypeRoot:
        case CPSDNodeTypeParagraph:
        case CPSDNodeTypeList:
        case CPSDNodeTypeTable:
        case CPSDNodeTypeTableRow:
        case CPSDNodeTypeTableCell:
        case CPSDNodeTypeLink:
            isLeaf = NO;
            break;
        case CPSDNodeTypeText:
        case CPSDNodeTypeImage:
        case CPSDNodeTypeVideo:
        case CPSDNodeTypeBlank:
        case CPSDNodeTypeExclusive:
            isLeaf = YES;
            break;
        default:
            break;
    }
    return isLeaf;
}

@end

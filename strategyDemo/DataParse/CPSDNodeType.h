//
//  CPSDNodeType.h
//  CropImageView
//
//  Created by welson on 2019/1/31.
//  Copyright © 2019 welson. All rights reserved.
//

#ifndef CPSDNodeType_h
#define CPSDNodeType_h

typedef NS_ENUM(NSUInteger, CPSDNodeType) {
    CPSDNodeTypeRoot = 0,
    CPSDNodeTypeParagraph = 1,
    CPSDNodeTypeList = 3,
    CPSDNodeTypeText = 4,
    CPSDNodeTypeImage = 6,
    CPSDNodeTypeVideo = 8,
    CPSDNodeTypeTable = 9,
    CPSDNodeTypeTableRow = 10,
    CPSDNodeTypeTableCell = 11,
    CPSDNodeTypeBlank = 12,
    CPSDNodeTypeLink = 14,
    CPSDNodeTypeExclusive = 255
};


#endif /* CPSDNodeType_h */

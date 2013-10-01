//
//  ZLStoneShape.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Abstract stone shape
//

#import "ZLShape.h"

typedef enum {
    zlsscGray0,
    zlsscGray1,
    zlsscGray2,
    zlsscAqua,
    zlsscYellow,
    zlsscPink,
    zlsscBlue,
    zlsscGreen,
    zlsscRed,
    zlsscCount // should not be used as a color
} ZLStoneShapeColor;

static const ZLStoneShapeColor zlsscFirstColor = zlsscGray0;
static const ZLStoneShapeColor zlsscLastColor = zlsscBlue;

@interface ZLStoneShape : ZLShape

@end

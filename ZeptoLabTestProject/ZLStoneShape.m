//
//  ZLStoneShape.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLStoneShape.h"
#import "ZLStone.h"

const static ZLColor stoneShapeColors[zlsscCount] =
{ // red   green blue  alpha
    {0x70, 0x70, 0x70, 0xFF}, // zlsscGray0,
    {0xB0, 0xB0, 0xB0, 0xFF}, // zlsscGray1,
    {0xFF, 0xFF, 0xFF, 0xFF}, // zlsscGray2,
    {0x00, 0xFF, 0xFF, 0xFF}, // zlsscAqua,
    {0xFF, 0xFF, 0x00, 0xFF}, // zlsscYellow,
    {0xFF, 0x00, 0xFF, 0xFF}, // zlsscPink,
    {0x00, 0x00, 0xFF, 0xFF}, // zlsscBlue,
    {0x00, 0xFF, 0x00, 0xFF}, // zlsscGreen,
    {0xFF, 0x00, 0x00, 0xFF}  // zlsscRed,
};

const static ZLColor backColor = {0x00, 0x00, 0x20, 0xFF};

@interface ZLStoneShape () {
    GLuint _colorsVBO[zlsscCount];
    GLuint _currentColorVBO;
}

@end

@implementation ZLStoneShape

- (void) applyStoneColor: (ZLStoneShapeColor) color {
    for (NSUInteger i = 0; i < self.shapeCount; i++) {
        if (self.shape[i].x == 0 && self.shape[i].y == 0) {
            self.colors[i] = stoneShapeColors[color];
        } else {
            self.colors[i] = backColor;
        }
    }
}

- (void) paintObject: (ZLObject *) obj {
    if (obj && [obj isKindOfClass: [ZLStone class]]) {
        ZLStone * stone = (ZLStone *) obj;
        if (!self.vboAssigned) {
            self.shapeVBO = ZLGenVBOForShape(self.shape, self.shapeCount);
            for (ZLStoneShapeColor color = 0; color < zlsscCount; color++) {
                [self applyStoneColor: color];
                _colorsVBO[color] = ZLGenVBOForColors(self.colors, self.shapeCount);
            }
            self.vboAssigned = true;
        }
        _currentColorVBO = _colorsVBO[stone.color];
        [super paintObject: stone];
    }
}

- (GLuint) colorsVBO {
    return _currentColorVBO;
}

@end

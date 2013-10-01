//
//  ZLBulletShape.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLBulletShape.h"
#import "ZLPlayer.h"
#import "ZLBulletNormal.h"
#import "ZLBulletBonus.h"
#import "ZLBulletPenalty.h"

@interface ZLBulletShape () {
    GLuint _colorsVBO[zlpsCount];
    GLuint _currentColorVBO;
}

@end

@implementation ZLBulletShape

- (void) paintObject: (ZLObject *) obj {
    if ([obj isKindOfClass: [ZLBulletBonus class]]) {
        _currentColorVBO = _colorsVBO[zlpsBonus];
    } else if ([obj isKindOfClass: [ZLBulletPenalty class]]) {
        _currentColorVBO = _colorsVBO[zlpsPenalty];
    } else {
        _currentColorVBO = _colorsVBO[zlpsNormal];
    }
    [super paintObject: obj];
}

- (GLuint) colorsVBO {
    return _currentColorVBO;
}

#pragma mark Initialization

- (id) init {
    if (self = [super initWithCount: 5 edgeCount: 4]) {
        self.shape[0] = ZLVectorMakeWithPoint( 0.5,  0);
        self.shape[1] = ZLVectorMakeWithPoint( 0, -0.25);
        self.shape[2] = ZLVectorMakeWithPoint( 0.125, 0);
        self.shape[3] = ZLVectorMakeWithPoint( 0.5, 0);
        self.shape[4] = ZLVectorMakeWithPoint( 0, 0.25);

        self.edge[0] = ZLVectorMakeWithPoint( 0.5,  0);
        self.edge[1] = ZLVectorMakeWithPoint( 0, -0.25);
        self.edge[2] = ZLVectorMakeWithPoint( 0.125, 0);
        self.edge[3] = ZLVectorMakeWithPoint( 0, 0.25);

        self.colors[0] = ZLColorMake(0x40, 0x40, 0xFF, 0xFF);
        self.colors[1] = ZLColorMake(0x40, 0x40, 0xFF, 0xFF);
        self.colors[2] = ZLColorMake(0xFF, 0xFF, 0xFF, 0xFF);
        self.colors[3] = ZLColorMake(0x40, 0x40, 0xFF, 0xFF);
        self.colors[4] = ZLColorMake(0x40, 0x40, 0xFF, 0xFF);
        _colorsVBO[zlpsNormal] = ZLGenVBOForColors(self.colors, self.shapeCount);

        self.colors[0] = ZLColorMake(0xFF, 0x40, 0x40, 0xFF);
        self.colors[1] = ZLColorMake(0xFF, 0x40, 0x40, 0xFF);
        self.colors[2] = ZLColorMake(0xFF, 0xFF, 0xFF, 0xFF);
        self.colors[3] = ZLColorMake(0xFF, 0x40, 0x40, 0xFF);
        self.colors[4] = ZLColorMake(0xFF, 0x40, 0x40, 0xFF);
        _colorsVBO[zlpsBonus] = ZLGenVBOForColors(self.colors, self.shapeCount);

        self.colors[0] = ZLColorMake(0x40, 0xFF, 0x40, 0xFF);
        self.colors[1] = ZLColorMake(0x40, 0xFF, 0x40, 0xFF);
        self.colors[2] = ZLColorMake(0xFF, 0xFF, 0xFF, 0xFF);
        self.colors[3] = ZLColorMake(0x40, 0xFF, 0x40, 0xFF);
        self.colors[4] = ZLColorMake(0x40, 0xFF, 0x40, 0xFF);
        _colorsVBO[zlpsPenalty] = ZLGenVBOForColors(self.colors, self.shapeCount);

        self.shapeVBO = ZLGenVBOForShape(self.shape, self.shapeCount);
        self.vboAssigned = true;
    }
    return self;
}

@end

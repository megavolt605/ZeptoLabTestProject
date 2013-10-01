//
//  ZLStoneNormal.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLStoneNormal.h"

@interface ZLStoneNormal ()

@end

@implementation ZLStoneNormal

#pragma mark Initialization

- (ZLVector) generatePointOnEdge: (NSUInteger) edge frame: (CGRect) frame size: (CGSize) size {
    switch (edge) {
        case 0: // left edge
            return ZLVectorMakeWithPoint(frame.origin.x - size.width * 2,
                                           FLOAT_RANDOM(frame.size.height) + frame.origin.y);
        case 1: // right edge
            return ZLVectorMakeWithPoint(frame.origin.x + frame.size.width + size.width * 2,
                                           FLOAT_RANDOM(frame.size.height) + frame.origin.y);
        case 2: // top edge
            return ZLVectorMakeWithPoint(FLOAT_RANDOM(frame.size.width) + frame.origin.x,
                                           frame.origin.y - size.height * 2);
        case 3: // bottom edge
            return ZLVectorMakeWithPoint(FLOAT_RANDOM(frame.size.width) + frame.origin.x,
                                           frame.origin.y + frame.size.height + size.height * 2);
        default: return ZLVectorMakeNull();
    }
}

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape {
    if (self = [super initWithGameViewInfo: gameViewInfo shape: shape]) {
        shape.object = self;

        // choose two random edges of game field
        NSUInteger startEdge = arc4random() % 4;
        NSUInteger finishEdge;
        do {
            finishEdge = arc4random() % 4;
        } while (startEdge == finishEdge);

        // calculating direction between random points on selected edges
        ZLVector start = [self generatePointOnEdge: startEdge frame: gameViewInfo.frame size: shape.size];
        ZLVector finish = [self generatePointOnEdge: finishEdge frame: gameViewInfo.frame size: shape.size];
        ZLVector line = ZLVectorSubVector(finish, start);
        self.position = start;

        self.velocity = (FLOAT_RANDOM(ZLconfig_stoneMaxVelocity - ZLconfig_stoneMinVelocity) + ZLconfig_stoneMinVelocity) / 100.0;
        self.angle = ZLVectorTheta(line);
        self.color = arc4random() % (zlsscLastColor - zlsscFirstColor + 1) + zlsscFirstColor;
    }
    return self;
}

@end

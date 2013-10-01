//
//  ZLBulletPenalty.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLBulletPenalty.h"

@interface ZLBulletPenalty ()

@end

@implementation ZLBulletPenalty

- (void) didCollisionWithObject: (ZLObject *) object {
    [super didCollisionWithObject: object];
    if ([object isKindOfClass: [ZLStone class]]) {
        ZLStone * stone = (ZLStone *) object;
        self.hittedStone = stone;
        //stone.wasHitByBullet = true;
    }
}

@end

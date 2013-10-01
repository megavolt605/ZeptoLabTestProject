//
//  ZLBulletBonus.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLBulletBonus.h"

@interface ZLBulletBonus ()

@end

@implementation ZLBulletBonus

- (void) didCollisionWithObject: (ZLObject *) object {
    if ([object isKindOfClass: [ZLStone class]]) {
        ZLStone * stone = (ZLStone *) object;
        self.hittedStone = stone;
        stone.wasHitByBullet = true;
    }
}

@end

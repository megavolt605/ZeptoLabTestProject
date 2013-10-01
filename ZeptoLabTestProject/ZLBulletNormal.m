//
//  ZLBulletNormal.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLBulletNormal.h"

@interface ZLBulletNormal ()

@end

@implementation ZLBulletNormal

- (void) didCollisionWithObject: (ZLObject *) object {
    if ([object isKindOfClass: [ZLStone class]]) {
        ZLStone * stone = (ZLStone *) object;
        self.hittedStone = stone;
        stone.wasHitByBullet = true;
    }
}

@end

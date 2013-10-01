//
//  ZLStone.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLStone.h"

@interface ZLStone ()

@end

@implementation ZLStone

- (Boolean) checkOutOfField {
    CGRect bigRect = self.rect;
    bigRect.origin.x -= bigRect.size.width * 3;
    bigRect.origin.y -= bigRect.size.height * 3;
    bigRect.size.width *= 6.0;
    bigRect.size.height *= 6.0;
    return !ZLRectIntersectRect(bigRect, _gameViewInfo.frame);
}

#pragma mark <NSCopying> protocol

- (id) copyWithZone: (NSZone *) zone {
    ZLStone * res = [super copyWithZone: zone];
    res.color = self.color;
    res.wasHitByBullet = self.wasHitByBullet;
    return res;
}

@end

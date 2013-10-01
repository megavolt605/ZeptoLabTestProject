//
//  ZLPlayer.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLPlayer.h"

@interface ZLPlayer ()

@end

@implementation ZLPlayer

- (void) fireBullet: (ZLBullet *) bullet {
    bullet.position = self.position;
    bullet.velocity = self.velocity + ZLconfig_bulletVelocity;
    bullet.angle = self.angle;
}

- (void) reset {
    self.position = ZLVectorMakeNull();
    self.velocity = 0.0;
    self.angle = M_PI_2;
    self.desiredAngle = self.angle;
    self.state = zlpsNormal;
}

#pragma mark <NSCopying> protocol

- (id) copyWithZone: (NSZone *) zone {
    ZLPlayer * res = [super copyWithZone: zone];
    res.desiredAngle = self.desiredAngle;
    res.state = self.state;
    return res;
}

@end

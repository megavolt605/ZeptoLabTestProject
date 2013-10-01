//
//  ZLPlayer.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Player object
//

#import "ZLDynamicObject.h"
#import "ZLBullet.h"

typedef enum {
    zlpsNormal,
    zlpsBonus,
    zlpsPenalty,
    zlpsCount
} ZLPlayerState;

@interface ZLPlayer : ZLCollisionObject

- (void) fireBullet: (ZLBullet *) bullet;

@property (nonatomic) GLfloat desiredAngle;
@property (nonatomic) ZLPlayerState state;

@end

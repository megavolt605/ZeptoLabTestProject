//
//  ZLGameShape.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLGame.h"
#import "ZLStone.h"
#import "ZLBullet.h"
#import "ZLGameShape.h"
#import "ZLPlayerShape.h"
#import "ZLStoneShapeNormal.h"
#import "ZLStoneShapeSmall.h"
#import "ZLBulletShape.h"

@interface ZLGameShape () 

@end

@implementation ZLGameShape

- (void) paintObject: (ZLObject *) object {
    // OpenGL stuff
    glLoadIdentity();
    
    // clear view
    //glClearColor(0.0, 0.0, 0.2, 1.0);
    //glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    // game objects drawing
    ZLGame * game = (ZLGame *)object;
    [_playerShape paintObject: game.player];
    for (ZLStone * stone in game.stones) {
        [stone.shape paintObject: stone];
    }
    for (ZLBullet * bullet in game.bullets) {
        [bullet.shape paintObject: bullet];
    }
}

#pragma mark Initialization

- (id) init {
    if (self = [super init]) {
        _playerShape = [[ZLPlayerShape alloc] init];
        _stoneShapeNormal = [[ZLStoneShapeNormal alloc] init];
        _stoneShapeSmall = [[ZLStoneShapeSmall alloc] init];
        _bulletShape = [[ZLBulletShape alloc] init];
    }
    return self;
}

@end

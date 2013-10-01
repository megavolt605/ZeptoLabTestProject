//
//  ZLStone.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Abstract stone
//

#import "ZLCollisionObject.h"
#import "ZLStoneShape.h"

@interface ZLStone : ZLCollisionObject

@property (nonatomic) ZLStoneShapeColor color;  // stone color
@property (nonatomic) Boolean wasHitByBullet;   // collision with bullet flag

@end

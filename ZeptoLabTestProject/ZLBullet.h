//
//  ZLBullet.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Player's abstract bullet
//

#import "ZLCollisionObject.h"
#import "ZLStone.h"

@interface ZLBullet : ZLCollisionObject

@property (nonatomic) ZLStone * hittedStone; // stone that hitted with the bullet

@end

//
//  ZLCollisionObject.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Object with collision detection

#import "ZLDynamicObject.h"

@interface ZLCollisionObject : ZLDynamicObject

@property (nonatomic) GLfloat mass;

// collision checks
- (Boolean) checkOutOfField;
- (Boolean) checkEdgeCollision;
- (Boolean) checkFrameCollisionWithObject: (ZLObject *) object;
- (Boolean) checkCollisionWithObject: (ZLObject *) object;

// collision events
- (void) didCollisionWithEdge;
- (void) didCollisionWithObject: (ZLObject *) object;

@end

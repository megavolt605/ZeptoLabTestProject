//
//  ZLCollisionObject.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLCollisionObject.h"

@interface ZLCollisionObject ()

@end

@implementation ZLCollisionObject


- (Boolean) checkOutOfField {
    return !ZLRectIntersectRect(self.rect, _gameViewInfo.frame);
}

- (Boolean) checkEdgeCollision {
    GLfloat viewLeft = _gameViewInfo.frame.origin.x;
    GLfloat viewRight = _gameViewInfo.frame.origin.x + _gameViewInfo.frame.size.width;
    GLfloat viewTop = _gameViewInfo.frame.origin.y;
    GLfloat viewBottom = _gameViewInfo.frame.origin.y + _gameViewInfo.frame.size.height;

    Boolean left = false;
    Boolean right = false;
    Boolean top = false;
    Boolean bottom = false;

    // edge collision
    for (NSUInteger i = 0; i < self.shape.edgeCount; i++) {
        ZLVector point = self.shape.edge[i];
        top |= (self.position.y + point.y) < viewTop;
        bottom |= (self.position.y + point.y) > viewBottom;
        left |= (self.position.x + point.x) < viewLeft;
        right |= (self.position.x + point.x) > viewRight;
    }

    return left || right || top || bottom;
}

- (NSUInteger) countPointIntersection: (ZLVector) point withObject: (ZLObject *) object {
    object.shape.object = object;
    NSUInteger res = 0;
    NSUInteger count = object.shape.edgeCount;
    NSUInteger j;
    ZLVector * edge = object.shape.edge;
    for (NSUInteger i = 0; i < count; i++) {
        j = (i == count - 1) ? 0 : i + 1;
        ZLVector a = ZLVectorMakeWithPoint(edge[i].x + object.position.x,
                                           edge[i].y + object.position.y);
        ZLVector b = ZLVectorMakeWithPoint(edge[j].x + object.position.x,
                                           edge[j].y + object.position.y);

        if (a.x != b.x) {
            GLfloat y = (point.x - a.x) * (b.y - a.y) / (b.x - a.x) + a.y;
            if ((point.y >= y) && (point.x > MIN(a.x, b.x)) && (point.x < MAX(a.x, b.x))) {
                res++;
            }
        }
    }
    return res;
}

- (Boolean) checkFrameCollisionWithObject: (ZLObject *) object {
    /*CGRect rect1 = self.rect;
     rect1.origin.x -= rect1.size.width / 2.0;
     rect1.origin.y -= rect1.size.height / 2.0;
     CGRect rect2 = object.rect;
     rect2.origin.x -= rect2.size.width / 2.0;
     rect2.origin.y -= rect2.size.height / 2.0;
     return ZLRectIntersectRect(rect1, rect2);*/
    ZLVector vector = ZLVectorSubVector(self.position, object.position);
    GLfloat distance = ZLVectorLength(vector);
    CGSize size1 = self.rect.size;
    CGSize size2 = object.rect.size;
    GLfloat r1 = MAX(size1.width, size1.height);
    GLfloat r2 = MAX(size2.width, size2.height);
    return ((distance - (r1 + r2) / 2) < 0.1);
}

- (Boolean) checkCollisionWithObject: (ZLObject *) object {
    if ([self checkFrameCollisionWithObject: object]) {
        /*ZLVector v;
         self.shape.object = self;
         for (NSUInteger i = 0; i < self.shape.edgeCount; i++) {
         v = ZLVectorMakeWithPoint(self.shape.edge[i].x + self.position.x,
         self.shape.edge[i].y + self.position.y);
         if (([self countPointIntersection: v withObject: object] % 2) == 1) {
         return true;
         }
         }*/
        return true;
    }
    return false;
}

- (void) didCollisionWithEdge {
    // dummy
}

- (void) didCollisionWithObject: (ZLObject *) object {
    // reflection from the other object
    if ([object isKindOfClass: [ZLCollisionObject class]]) {
        ZLCollisionObject * object2 = (ZLCollisionObject *) object;

        ZLVector velocity1 = ZLVectorMakeWithPolar(self.angle, self.velocity);
        ZLVector velocity2 = ZLVectorMakeWithPolar(object2.angle, object2.velocity);

        CGRect rect1 = self.rect;
        CGRect rect2 = object2.rect;
        ZLVector pos1 = ZLVectorMakeWithPoint(rect1.origin.x, rect1.origin.y);
        ZLVector pos2 = ZLVectorMakeWithPoint(rect2.origin.x, rect2.origin.y);

        ZLVector collision = ZLVectorSubVector(pos1, pos2);

        GLfloat distance = ZLVectorLength(collision);
        if (distance == 0.0) {
            collision = ZLVectorMakeWithPoint(0, 0);
            distance = 1.0;
        }

        collision = ZLVectorDiv(collision, distance);
        GLfloat aci = ZLVectorDot(velocity1, collision);
        GLfloat bci = ZLVectorDot(velocity2, collision);

        GLfloat acf = bci * object2.mass * object2.mass / (self.mass * object2.mass);
        GLfloat bcf = aci * self.mass * self.mass / (self.mass * object2.mass);

        ZLVector res1 = ZLVectorMul(collision, acf - aci);
        res1 = ZLVectorAddVector(velocity1, res1);

        ZLVector res2 = ZLVectorMul(collision, bcf - bci);
        res2 = ZLVectorAddVector(velocity2, res2);

        // apply changes to stones
        [self rollbackCalculation];
        self.angle = ZLVectorTheta(res1);
        self.velocity = ZLVectorLength(res1);
        [self calculate];

        [object2 rollbackCalculation];
        object2.angle = ZLVectorTheta(res2);
        object2.velocity = ZLVectorLength(res2);
        [object2 calculate];
    }
}

#pragma mark Initialization

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape {
    if (self = [super initWithGameViewInfo: gameViewInfo shape: shape]) {
        _mass = 1.0;
    }
    return self;
}

@end
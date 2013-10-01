//
//  ZLDynamicObject.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLDynamicObject.h"

@interface ZLDynamicObject ()

@end

@implementation ZLDynamicObject

- (void) calculate {
    [super calculate];
    ZLVector vector = ZLVectorMakeWithPolar(self.angle, _velocity);
    self.position = ZLVectorAddVector(self.position, vector);
}

#pragma mark <NSCopying> protocol

- (id) copyWithZone: (NSZone *) zone {
    ZLDynamicObject * res = [super copyWithZone: zone];
    res.velocity = self.velocity;
    return res;
}


@end

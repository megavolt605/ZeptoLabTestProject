//
//  ZLObject.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLObject.h"

@interface ZLObject ()

@end

@implementation ZLObject

- (CGRect) rect {
    CGRect res;
    res.origin.x = self.position.x;
    res.origin.y = self.position.y;
    self.shape.object = self;
    res.size = self.shape.size;
    return res;
}

- (void) reset {
    // dummy
}

- (void) calculate {
    _savedPosition = self.position;
}

- (void) rollbackCalculation {
    self.position = _savedPosition;
}

#pragma mark Initialization

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape {
    if (self = [super init]) {
        _gameViewInfo = gameViewInfo;
        _shape = shape;
    }
    return self;
}

#pragma mark <NSCopying> protocol

- (id) copyWithZone: (NSZone *) zone {
    ZLObject * res = [[[self class] allocWithZone: zone] initWithGameViewInfo: _gameViewInfo shape: _shape];
    res.position = self.position;
    res.angle = self.angle;
    return res;
}

@end

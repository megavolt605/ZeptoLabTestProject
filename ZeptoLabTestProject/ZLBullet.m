//
//  ZLBullet.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLBullet.h"

@interface ZLBullet ()

@end

@implementation ZLBullet

#pragma mark <NSCopying> protocol

- (id) copyWithZone: (NSZone *) zone {
    ZLBullet * res = [super copyWithZone: zone];
    res.hittedStone = self.hittedStone;
    return res;
}

@end

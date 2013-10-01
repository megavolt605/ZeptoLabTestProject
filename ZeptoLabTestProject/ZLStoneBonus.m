//
//  ZLStoneBonus.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLStoneBonus.h"

@interface ZLStoneBonus ()

@end

@implementation ZLStoneBonus

#pragma mark Initialization

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape {
    if (self = [super initWithGameViewInfo: gameViewInfo shape: shape]) {
        self.color = zlsscRed;
    }
    return self;
}

@end

//
//  ZLStonePenalty.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLStonePenalty.h"

@interface ZLStonePenalty ()

@end

@implementation ZLStonePenalty

#pragma mark Initialization

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape {
    if (self = [super initWithGameViewInfo: gameViewInfo shape: shape]) {
        self.color = zlsscGreen;
    }
    return self;
}

@end

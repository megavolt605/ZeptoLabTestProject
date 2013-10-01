//
//  ZLPlayerShape.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLPlayerShape.h"

@interface ZLPlayerShape ()

@end

@implementation ZLPlayerShape

#pragma mark Initialization

- (id) init {
    if (self = [super initWithCount: 5 edgeCount: 4]) {
        self.shape[0] = ZLVectorMakeWithPoint( 2,  0);
        self.shape[1] = ZLVectorMakeWithPoint( 0, -1);
        self.shape[2] = ZLVectorMakeWithPoint( 0.5, 0);
        self.shape[3] = ZLVectorMakeWithPoint( 2, 0);
        self.shape[4] = ZLVectorMakeWithPoint( 0, 1);
        
        self.edge[0] = ZLVectorMakeWithPoint( 2,  0);
        self.edge[1] = ZLVectorMakeWithPoint( 0, -1);
        self.edge[2] = ZLVectorMakeWithPoint( 0.5, 0);
        self.edge[3] = ZLVectorMakeWithPoint( 0, 1);
        
        self.colors[0] = ZLColorMake(0x00, 0xFF, 0x00, 0xFF);
        self.colors[1] = ZLColorMake(0x00, 0xFF, 0x00, 0xFF);
        self.colors[2] = ZLColorMake(0xFF, 0xFF, 0xFF, 0xFF);
        self.colors[3] = ZLColorMake(0x00, 0xFF, 0x00, 0xFF);
        self.colors[4] = ZLColorMake(0x00, 0xFF, 0x00, 0xFF);
    }
    return self;
}

@end

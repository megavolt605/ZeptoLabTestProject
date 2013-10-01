//
//  ZLStoneShapeNormal.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLStoneShapeNormal.h"

@interface ZLStoneShapeNormal ()

@end

@implementation ZLStoneShapeNormal

#pragma mark Initialization

- (id) init {
    if (self = [super initWithCount: 13 edgeCount: 8]) {
        self.shape[ 0] = ZLVectorMakeWithPoint(  0.0, -4.0);
        self.shape[ 1] = ZLVectorMakeWithPoint(  0.0,  0.0);
        self.shape[ 2] = ZLVectorMakeWithPoint(  2.8, -2.8);
        self.shape[ 3] = ZLVectorMakeWithPoint(  4.0,  0.0);
        self.shape[ 4] = ZLVectorMakeWithPoint(  0.0,  0.0);
        self.shape[ 5] = ZLVectorMakeWithPoint(  2.8,  2.8);
        self.shape[ 6] = ZLVectorMakeWithPoint(  0.0,  4.0);
        self.shape[ 7] = ZLVectorMakeWithPoint(  0.0,  0.0);
        self.shape[ 8] = ZLVectorMakeWithPoint( -2.8,  2.8);
        self.shape[ 9] = ZLVectorMakeWithPoint( -4.0,  0.0);
        self.shape[10] = ZLVectorMakeWithPoint(  0.0,  0.0);
        self.shape[11] = ZLVectorMakeWithPoint( -2.8, -2.8);
        self.shape[12] = ZLVectorMakeWithPoint(  0.0, -4.0);

        self.edge[0] = self.shape[ 0];
        self.edge[1] = self.shape[ 2];
        self.edge[2] = self.shape[ 3];
        self.edge[3] = self.shape[ 5];
        self.edge[4] = self.shape[ 6];
        self.edge[5] = self.shape[ 8];
        self.edge[6] = self.shape[ 9];
        self.edge[7] = self.shape[11];
    }
    return self;
}

@end

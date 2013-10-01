//
//  ZLShape.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Abstract shape
//

#import "ZLObject.h"

@class ZLObject;

@interface ZLShape : NSObject {
@protected
    Boolean _shapeSizeCalculated;
}

- (void) paintObject: (ZLObject *) obj;

@property (nonatomic, readonly) ZLVector * shape;       // mesh for triangle strip drawing
@property (nonatomic, readonly) ZLColor * colors;       // colors of shape points
@property (nonatomic, readonly) NSUInteger shapeCount;  // shape points count
@property (nonatomic, readonly) ZLVector * edge;        // edge points for objects collision checking
@property (nonatomic, readonly) NSUInteger edgeCount;   // edge points count
@property (nonatomic, readonly) CGSize size;            // rectangle size of shape (calculated)
@property (nonatomic, weak) ZLObject * object;          // current object
@property (nonatomic) GLuint shapeVBO;
@property (nonatomic) GLuint colorsVBO;
@property (nonatomic) Boolean vboAssigned;

#pragma mark Initialization

- (id) initWithCount: (NSUInteger) count edgeCount: (NSUInteger) edgeCount;

@end

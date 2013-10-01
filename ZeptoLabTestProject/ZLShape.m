//
//  ZLShape.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLShape.h"

@interface ZLShape () {
    Boolean _shapeOwner;

    ZLVector * _shape;
    NSUInteger _shapeCount;

    ZLColor * _colors;

    ZLVector * _edge;
    NSUInteger _edgeCount;

    CGSize _shapeSize;

    GLuint _shapeVBO;
    GLuint _colorsVBO;
}

@end

@implementation ZLShape

// universal shape painter

- (void) paintObject: (ZLObject *) obj {
    self.object = obj;
    if (obj) {
        if (!_vboAssigned && !_shapeOwner) {
            _shapeVBO = ZLGenVBOForShape(self.shape, self.shapeCount);
            _colorsVBO = ZLGenVBOForColors(self.colors, self.shapeCount);
            _vboAssigned = true;
        }
        ZLDrawShapeVBO( self.shapeVBO, self.colorsVBO, self.shapeCount, obj.position, obj.angle);
    }
}

// getters can be overriden by descendants

- (ZLVector *) shape {
    return _shape;
}

- (ZLColor *) colors {
    return _colors;
}

- (NSUInteger) shapeCount {
    return _shapeCount;
}

- (ZLVector *) edge {
    return _edge;
}

- (NSUInteger) edgeCount {
    return _edgeCount;
}

- (GLuint) shapeVBO {
    return _shapeVBO;
}

- (GLuint) colorsVBO {
    return _colorsVBO;
}

- (CGSize) size {
    if (!_shapeSizeCalculated) {
        if (self.shapeCount == 0) {
            _shapeSize = CGSizeMake(0, 0);
        } else {
            _shapeSize = ZLShapeSize( self.shape, self.shapeCount);
        }
        _shapeSizeCalculated = true;
    }
    return _shapeSize;
}

#pragma mark Initialization

- (id) initWithCount: (NSUInteger) count edgeCount: (NSUInteger) edgeCount {
    if (self = [super init]) {
        _vboAssigned = false;
        _shapeCount = count;
        _shapeSizeCalculated = false;
        // allocate default arrays
        _shapeOwner = count == 0;
        if (!_shapeOwner) {
            _shape = malloc(sizeof(ZLVector) * count);
            _colors = malloc(sizeof(ZLColor) * count);
        }
        _edgeCount = edgeCount;
        if (!_shapeOwner) {
            _edge = malloc(sizeof(ZLVector) * edgeCount);
        }
    }
    return self;
}

// cleanup

- (void) dealloc {
    if (_shape) {
        free(_shape);
    }
    if (_edge) {
        free(_edge);
    }
    if (_colors) {
        free(_colors);
    }
}

@end

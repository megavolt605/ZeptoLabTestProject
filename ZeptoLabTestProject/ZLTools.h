//
//  ZLTools.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Global project-wide functions and macros
//

#import <ImageIO/ImageIO.h>

#ifndef ZeptoLabTestProject_ZLTools_h
#define ZeptoLabTestProject_ZLTools_h

#pragma mark Macros

#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
#define RADIANS_TO_DEGREES(__ANGLE__) ((__ANGLE__) * 180.0 / M_PI)
#define FLOAT_RANDOM(__MAX__) (arc4random() % 100 * (__MAX__) / 100)

#pragma mark ZLVector

typedef struct {
    GLfloat x, y;
} ZLVector;

static inline ZLVector ZLVectorMakeWithPoint(GLfloat x, GLfloat y) {
    ZLVector res;
    res.x = x;
    res.y = y;
    return res;
}

static inline ZLVector ZLVectorMakeWithPolar(GLfloat theta, GLfloat length) {
    return ZLVectorMakeWithPoint(length * cosf(theta), length * sinf(theta));
}

static inline ZLVector ZLVectorAddVector(ZLVector a, ZLVector b) {
    return ZLVectorMakeWithPoint(a.x + b.x, a.y + b.y);
}

static inline ZLVector ZLVectorSubVector(ZLVector a, ZLVector b) {
    return ZLVectorMakeWithPoint(a.x - b.x, a.y - b.y);
}

static inline ZLVector ZLVectorDiv(ZLVector vector, GLfloat value) {
    return ZLVectorMakeWithPoint(vector.x / value, vector.y / value);
}

static inline ZLVector ZLVectorMul(ZLVector vector, GLfloat value) {
    return ZLVectorMakeWithPoint(vector.x * value, vector.y * value);
}

static inline GLfloat ZLVectorLength(ZLVector vector) {
    return sqrtf(vector.x * vector.x + vector.y * vector.y);
}

static inline GLfloat ZLVectorDot(ZLVector a, ZLVector b) {
    return (a.x * b.x + a.y * b.y);
}

static inline GLfloat ZLVectorTheta(ZLVector vector) {
    GLfloat k = 1;
    if (vector.x == 0.0) {
        return (vector.y >= 0) ? M_PI_2 : M_PI_2 * 3.0;
    } else
    if (vector.x > 0.0) {
        k = vector.y >= 0.0 ? 0.0 : 2.0;
    }
    return atanf( vector.y / vector.x ) + M_PI * k;
}

static inline ZLVector ZLVectorSetLength(ZLVector vector, GLfloat length) {
    GLfloat theta = ZLVectorTheta(vector);
    return ZLVectorMakeWithPolar(theta, length);
}

static inline ZLVector ZLVectorSetTheta(ZLVector vector, GLfloat theta) {
    GLfloat length = ZLVectorLength(vector);
    return ZLVectorMakeWithPoint(length * cosf(theta), length * sinf(theta));
}

static inline ZLVector ZLVectorMakeNull () {
    return ZLVectorMakeWithPoint(0.0, 0.0);
}

static inline ZLVector ZLVectorMakeRandom (GLfloat rangeX1, GLfloat rangeX2, GLfloat rangeY1, GLfloat rangeY2) {
    return ZLVectorMakeWithPoint(FLOAT_RANDOM(rangeX2 - rangeX1) + rangeX1, FLOAT_RANDOM(rangeY2 - rangeY1) + rangeY1);
}

static inline ZLVector ZLVectorMakeRandomInRect(CGRect viewRect, CGSize shapeSize) {
    return ZLVectorMakeRandom(viewRect.origin.x + shapeSize.width / 2,
                              viewRect.origin.x + viewRect.size.width - shapeSize.width / 2,
                              viewRect.origin.y + shapeSize.height / 2,
                              viewRect.origin.y + viewRect.size.height - shapeSize.height / 2);
}

static inline GLfloat ZLVectorCrossProduct(ZLVector vector1, ZLVector vector2, ZLVector vector) {
    return (vector.x - vector2.x) * (vector2.y - vector1.y) - (vector.y - vector2.y) * (vector2.x - vector1.x);
}

#pragma mark ZLTriangle

typedef struct {
    ZLVector points[3];
} ZLTriangle;

static inline ZLTriangle ZLTriangleMake(ZLVector a, ZLVector b, ZLVector c) {
    ZLTriangle res;
    res.points[0] = a;
    res.points[1] = b;
    res.points[2] = c;
    return res;
}

#pragma mark ZLColor

typedef struct {
    GLubyte r, g, b, a;
} ZLColor;

static inline ZLColor ZLColorMake(GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha) {
    ZLColor res;
    res.r = red;
    res.g = green;
    res.b = blue;
    res.a = alpha;
    return res;
}

static inline ZLColor ZLColorRandomColor () {
    return ZLColorMake(arc4random() % 128 + 128,
                       arc4random() % 128 + 128,
                       arc4random() % 128 + 128,
                       255);
}

#pragma mark Tools

static inline Boolean ZLRectIntersectRect(CGRect rect1, CGRect rect2) {
    return !(
      ((rect1.origin.x + rect1.size.width) < rect2.origin.x || (rect1.origin.y + rect1.size.height) < rect2.origin.y) ||
      ((rect2.origin.x + rect2.size.width) < rect1.origin.x || (rect2.origin.y + rect2.size.height) < rect1.origin.y)
      );
}

static inline CGSize ZLShapeSize(ZLVector * shape, NSUInteger count) {
    GLfloat minX = shape[0].x;
    GLfloat maxX = minX;
    GLfloat minY = shape[0].y;
    GLfloat maxY = minY;
    for (NSUInteger i = 1; i < count; i++) {
        if (minX > shape[i].x) minX = shape[i].x;
        if (maxX < shape[i].x) maxX = shape[i].x;
        if (minY > shape[i].y) minY = shape[i].y;
        if (maxY < shape[i].y) maxY = shape[i].y;
    }
    return CGSizeMake(maxX - minX, maxY - minY);
}

#pragma mark Drawing shape

static inline void ZLDrawShapeVBO(GLuint shapeVBO, GLuint colorsVBO, NSUInteger count, ZLVector position, GLfloat angle) {
    glLoadIdentity();
    glTranslatef(position.x, position.y, -1.0);
    glRotatef(RADIANS_TO_DEGREES(angle), 0.0, 0.0, 1.0);

    //glEnableClientState(GL_VERTEX_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, shapeVBO);
    glVertexPointer(2, GL_FLOAT, 0, NULL);

    //glEnableClientState(GL_COLOR_ARRAY);
    glBindBuffer(GL_ARRAY_BUFFER, colorsVBO);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, NULL);

    glDrawArrays(GL_TRIANGLE_STRIP, 0, count);

    //glDisableClientState(GL_VERTEX_ARRAY);
    //glDisableClientState(GL_COLOR_ARRAY);
}

static GLuint ZLGenVBOForShape(ZLVector shape[], NSUInteger count) {
    GLuint res;
    glGenBuffers(1, &res);
    glBindBuffer(GL_ARRAY_BUFFER, res);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ZLVector) * count, shape, GL_STATIC_DRAW);
    return res;
}

static GLuint ZLGenVBOForColors(ZLColor colors[], NSUInteger count) {
    GLuint res;
    glGenBuffers(1, &res);
    glBindBuffer(GL_ARRAY_BUFFER, res);
    glBufferData(GL_ARRAY_BUFFER, sizeof(ZLColor) * count, colors, GL_STATIC_DRAW);
    return res;
}

#endif

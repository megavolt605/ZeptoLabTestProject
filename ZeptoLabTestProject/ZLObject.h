//
//  ZLObject.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLGameViewInfo.h"
#import "ZLShape.h"

// Abstract game object with basic properties (position, angle, shape, etc.)

@class ZLGameViewInfo, ZLShape;

@interface ZLObject : NSObject <NSCopying> {
@protected
    ZLGameViewInfo * _gameViewInfo;
    ZLVector _savedPosition;
}

// resets object position and state
- (void) reset;

// game step calculation
- (void) calculate;
- (void) rollbackCalculation;

@property (nonatomic) ZLVector position;      // current position
@property (nonatomic) GLfloat angle;          // direction
@property (nonatomic, weak) ZLShape * shape;  // object shape
@property (nonatomic, readonly) CGRect rect;  // object bounds rectangle (calculated)

#pragma mark Initialization

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape;

@end

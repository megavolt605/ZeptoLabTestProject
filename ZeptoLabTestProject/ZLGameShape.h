//
//  ZLGameShape.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Set of game shapes (player, stones, etc.)
//

#import "ZLShape.h"

@interface ZLGameShape : ZLShape

@property (nonatomic, strong) ZLShape * playerShape;
@property (nonatomic, strong) ZLShape * stoneShapeNormal;
@property (nonatomic, strong) ZLShape * stoneShapeSmall;
@property (nonatomic, strong) ZLShape * bulletShape;

@end

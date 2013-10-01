//
//  ZLGame.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Game logic
//ß

#import "ZLPlayer.h"

@class ZLGame;

// Game delegate protocol to receive game events

@protocol ZLGameDelegate <NSObject>
@required
- (void) game: (ZLGame *) game didFinishWithScore: (NSUInteger) score;
- (void) game: (ZLGame *) game didChangeScore: (NSUInteger) score;
- (void) game: (ZLGame *) game didChangePlayer: (ZLPlayer *) player bullets: (NSArray *) bullets;
- (void) game: (ZLGame *) game didChangePlayer: (ZLPlayer *) player state: (ZLPlayerState) state forTime: (CGFloat) time;
@end

// Game object. Contains player, stones and bullets objects

@interface ZLGame : ZLObject

// self-commented...
- (void) startGame;
- (void) stopGame;
- (void) pauseGame;
- (void) resumeGame;
- (void) paintGame;
- (void) fireBullet;
- (void) startMove;
- (void) stopMove;
- (void) switchSound;

@property (nonatomic, weak) id <ZLGameDelegate> delegate;

@property (nonatomic, strong) ZLPlayer * player;
@property (nonatomic, strong) NSMutableArray * stones;
@property (nonatomic, strong) NSMutableArray * bullets;
@property (nonatomic) NSUInteger score;
@property (nonatomic) NSUInteger bestScore;

// game state
@property (nonatomic) Boolean isRunning;
@property (nonatomic) Boolean isPaused;

// "god" mode
@property (nonatomic) Boolean IDDQD;

@end

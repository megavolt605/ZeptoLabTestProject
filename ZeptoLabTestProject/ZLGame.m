//
//  ZLGame.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>

#import "ZLGame.h"
#import "ZLGameShape.h"
#import "ZLCollisionObject.h"
#import "ZLStoneNormal.h"
#import "ZLStoneSmall.h"
#import "ZLStoneBonus.h"
#import "ZLStonePenalty.h"
#import "ZLBulletNormal.h"
#import "ZLBulletBonus.h"
#import "ZLBulletPenalty.h"
#import "ZLGameViewInfo.h"
#import "ZLGameShape.h"
#import "ZLGameAudio.h"

@interface ZLGame () {
    NSTimer * _gameTimer;
    NSTimer * _summonStoneTimer;
    NSTimer * _summonStonePeriodTimer;
    NSTimeInterval _summonStonePeriod;
    NSUInteger _score;
    ZLGameShape * _gameShape;
    CMMotionManager * _motionManager;
    NSTimer * _bonusAndPenaltyTimer;
    NSDate * _bonusAndPenaltyTimerPauseStart, * _bonusAndPenaltyTimerPreviousFireDate;
    ZLGameAudio * _audio;
}

@end

@implementation ZLGame

- (void) startGame {
    self.score = 0;
    [_stones removeAllObjects];
    [_bullets removeAllObjects];
    [_player reset];
    _summonStonePeriod = ZLconfig_stoneSummonPeriod;

    [self recreateTimers];
    
    _isRunning = (_gameTimer != nil);

    [self summonStone];

    // initialize accelerometer
    _motionManager = [CMMotionManager new];
    _motionManager.accelerometerUpdateInterval = 1.0 / ZLconfig_accelerometerPeriod;
    [_motionManager startAccelerometerUpdatesToQueue: [NSOperationQueue mainQueue] withHandler: ^(CMAccelerometerData * accelerometerData, NSError *error) {
        GLfloat x = accelerometerData.acceleration.x;
        GLfloat y = accelerometerData.acceleration.y;
        if (ABS(x) >= ZLconfig_acceleratorSensetivity || ABS(y) >= ZLconfig_acceleratorSensetivity) {
            _player.desiredAngle = ZLVectorTheta(ZLVectorMakeWithPoint(-y, x + 0.4));
        }
    }];
    if (_delegate) {
        [_delegate game: self didChangePlayer: _player state: zlpsNormal forTime: 0.0];
    }
    [self bulletsChanged];
    [_audio startBackground];
    
}

- (void) recreateTimers {
    if (!_gameTimer) {
        _gameTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 / ZLconfig_gameSpeed
                                                      target: self
                                                    selector: @selector(gameTick:)
                                                    userInfo: nil
                                                     repeats: true];
    }

    if (_isRunning) {
        _summonStoneTimer = [NSTimer scheduledTimerWithTimeInterval: _summonStonePeriod
                                                             target: self
                                                           selector: @selector(summonStone)
                                                           userInfo: nil
                                                            repeats: NO];
        _summonStonePeriodTimer = [NSTimer scheduledTimerWithTimeInterval: ZLconfig_stoneSummonAccelerationPeriod
                                                                   target: self
                                                                 selector: @selector(summonStonePeriodDecrease)
                                                                 userInfo: nil
                                                                  repeats: true];
    }

}

- (void) invalidateTimers {
    if (_gameTimer) {
        [_gameTimer invalidate];
        _gameTimer = nil;
    }
    if (_summonStoneTimer) {
        [_summonStoneTimer invalidate];
        _summonStoneTimer = nil;
    }
    if (_summonStonePeriodTimer) {
        [_summonStonePeriodTimer invalidate];
        _summonStonePeriodTimer = nil;
    }
}

- (void) stopGame {

    [self invalidateTimers];
    if (_bonusAndPenaltyTimer) {
        [_bonusAndPenaltyTimer invalidate];
        _bonusAndPenaltyTimer = nil;
    }
    _isRunning = false;
    _isPaused = false;

    if (_score > _bestScore) {
        // we got new champion
        _bestScore = _score;
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setInteger: _bestScore forKey: ZLconfig_bestScoreKey];
        [userDefaults synchronize];
    }

    [self bulletsChanged];

    if (_delegate) {
        [_delegate game: self didFinishWithScore: self.score];
    }
    _motionManager = nil;
    [_audio stopBackground];
    //_player = nil;
}

- (void) pauseGame {
    if (_isRunning && !_isPaused) {
        _isPaused = true;
        [self invalidateTimers];
        if (_bonusAndPenaltyTimer) {
            _bonusAndPenaltyTimerPauseStart = [NSDate dateWithTimeIntervalSinceNow: 0];
            _bonusAndPenaltyTimerPreviousFireDate = [_bonusAndPenaltyTimer fireDate];
            [_bonusAndPenaltyTimer setFireDate: [NSDate distantFuture]];
            
        }
        [_audio pauseBackground];
    }
}

- (void) resumeGame {
    if (_isRunning && _isPaused) {
        _isPaused = false;
        [self recreateTimers];
        if (_bonusAndPenaltyTimer) {
            float pauseTime = -1 * [_bonusAndPenaltyTimerPauseStart timeIntervalSinceNow];
            NSDate * newTime = [_bonusAndPenaltyTimerPreviousFireDate initWithTimeInterval: pauseTime
                                                                                 sinceDate: _bonusAndPenaltyTimerPreviousFireDate];
            [_bonusAndPenaltyTimer setFireDate: newTime];
        }
        [_audio resumeBackground];
    }
}

- (void) summonStone {
    ZLStone * stone;

    // selecting new stone class
    Class stoneClass;
    if (arc4random() % 3 == arc4random() % 3) {
        if (arc4random() %2 == 0) {
            stoneClass = [ZLStoneBonus class];
        } else {
            stoneClass = [ZLStonePenalty class];
        }
    } else {
        stoneClass = [ZLStoneNormal class];
    }

    Boolean hasIntersection;
    do {
        stone = [[stoneClass alloc] initWithGameViewInfo: _gameViewInfo shape: _gameShape.stoneShapeNormal];
        hasIntersection = false;
        for (ZLCollisionObject * object2 in _stones) {
            hasIntersection = [stone checkCollisionWithObject: object2];
            if (hasIntersection) {
                break;
            }
        }
    } while (hasIntersection);

    [_stones addObject: stone];
    [self recreateTimers];
}

- (void) summonSmallStonesFromStone: (ZLStone *) stone {
    ZLStoneSmall * smallStone = [[ZLStoneSmall alloc] initWithGameViewInfo: _gameViewInfo shape: _gameShape.stoneShapeSmall];
    smallStone.color = stone.color;
    /*
    CGRect smallStoneRect = stone.rect;
    GLfloat sideLength = MAX(smallStoneRect.size.width, smallStoneRect.size.height);
    GLfloat angleBetweenSides = (ZLconfig_smallStonesCount - 2) * 180.0 / ZLconfig_smallStonesCount;

    ZLVector side = ZLVectorMakeWithPoint(sideLength * cosf(DEGREES_TO_RADIANS(angleBetweenSides)), sinf(DEGREES_TO_RADIANS(angleBetweenSides)));
    ZLVector sideCenter = ZLVectorMakeWithPoint(side.x / 2.0, side.y / 2.0);
    ZLVector circleCenter = ZLVectorMakeWithPoint(sideLength / 2.0, sideCenter.y + sideLength * sideLength / side.y / 8.0);
    GLfloat circleRadius = sqrt( sideLength * sideLength / 4.0 + circleCenter.y * circleCenter.y);
    */
    GLfloat incth = 360.0 / ZLconfig_smallStonesCount;
    GLfloat th = FLOAT_RANDOM(360);
    for (NSUInteger i = 0; i < ZLconfig_smallStonesCount; i++) {
        smallStone.angle = DEGREES_TO_RADIANS(th);
        smallStone.position = ZLVectorMakeWithPolar(smallStone.angle, smallStone.rect.size.width);
        smallStone.position = ZLVectorAddVector(smallStone.position, stone.position);
        smallStone.velocity = ZLconfig_smallStoneVelocity + FLOAT_RANDOM(ZLconfig_smallStoneVelocityRange);
        th += incth;
        [_stones addObject: [smallStone copy]];
    }

}

- (void) summonStonePeriodDecrease {
    if (_summonStonePeriod > 1.0) {
        _summonStonePeriod -= ZLconfig_stoneSummonAccelerationValue;
    }
}

- (NSUInteger) score {
    return _score;
}

- (void) setScore: (NSUInteger) score {
    _score = score;
    if (_delegate) {
        [_delegate game: self didChangeScore: _score];
    }
}

- (void) bulletsChanged {
    if (_delegate) {
        [_delegate game: self didChangePlayer: _player bullets: _bullets];
    }
}

- (void) fireBullet {
    if (_bullets.count < ZLconfig_bulletsCount) {
        Class bulletClass;
        switch (_player.state) {
            case zlpsBonus:
                bulletClass = [ZLBulletBonus class];
                break;
            case zlpsPenalty:
                bulletClass = [ZLBulletPenalty class];
                break;
            default:
                bulletClass = [ZLBulletNormal class];
                break;
        }
        ZLBulletNormal * bullet = [[bulletClass alloc] initWithGameViewInfo: _gameViewInfo shape: _gameShape.bulletShape];
        [_player fireBullet : bullet];
        [_bullets addObject: bullet];
        [_audio fireBullet];
        [self bulletsChanged];
    }
}

- (void) activateBonus {
    _player.state = zlpsBonus;
    if (_delegate) {
        [_delegate game: self didChangePlayer: _player state: _player.state forTime: ZLconfig_bonusDuration];
    }
    if (_bonusAndPenaltyTimer) {
        [_bonusAndPenaltyTimer invalidate];
    }
    _bonusAndPenaltyTimer = [NSTimer scheduledTimerWithTimeInterval: ZLconfig_bonusDuration
                                                             target: self
                                                           selector: @selector(deactivateBonusAndPenalty)
                                                           userInfo: nil
                                                            repeats: false];
}

- (void) activatePenalty {
    _player.state = zlpsPenalty;
    if (_delegate) {
        [_delegate game: self didChangePlayer: _player state: _player.state forTime: ZLconfig_penaltyDuration];
    }
    if (_bonusAndPenaltyTimer) {
        [_bonusAndPenaltyTimer invalidate];
    }
    _bonusAndPenaltyTimer = [NSTimer scheduledTimerWithTimeInterval: ZLconfig_penaltyDuration
                                                             target: self
                                                           selector: @selector(deactivateBonusAndPenalty)
                                                           userInfo: nil
                                                            repeats: false];
}

- (void) deactivateBonusAndPenalty {
    _player.state = zlpsNormal;
    if (_delegate) {
        [_delegate game: self didChangePlayer: _player state: _player.state forTime: 0.0];
    }
    _bonusAndPenaltyTimer = nil;
}

- (void) gameTick: (id) sender {

    // calculate new game state
    if (_gameTimer) {
        [_player calculate];
        for (ZLStone * stone in _stones) {
            [stone calculate];
        }
        for (ZLBullet * bullet in _bullets) {
            [bullet calculate];
        }

        // smooth player rotation
        GLfloat angle = _player.angle - _player.desiredAngle;
        GLfloat absAngle = ABS(angle);
        GLfloat coeff;
        if (absAngle > ZLconfig_playerRotationAngle * 2.0) {
            coeff = (absAngle < M_PI) ? 1.0 : -1.0;
            if (angle < 0.0) {
                _player.angle += ZLconfig_playerRotationAngle * coeff;
            } else {
                _player.angle -= ZLconfig_playerRotationAngle * coeff;
            }
            if (_player.angle > M_PI * 2) {
                _player.angle -= M_PI * 2;
            }
            if (_player.angle < 0) {
                _player.angle += M_PI * 2;
            }
        }

        // check for objects collisions

        if (!_IDDQD) {
            // player vs stones
            for (ZLStone * stone in _stones) {
                if ([_player checkCollisionWithObject: stone]) {
                    [_audio death];
                    [self stopGame];
                    return;
                }
            }
        }

        // stones vs stones
        for (ZLStone * stone1 in _stones) {
            for (ZLStone * stone2 in _stones) {
                if (stone1 != stone2) {
                    if ([stone1 checkCollisionWithObject: stone2]) {
                        [stone1 didCollisionWithObject: stone2];
                    }
                }
            }
        }

        // bullets vs stones
        for (ZLBullet * bullet in _bullets) {
            for (ZLStone * stone in _stones) {
                if ([bullet checkCollisionWithObject: stone]) {
                    [bullet didCollisionWithObject: stone];
                    //[stone didCollisionWithObject: bullet];
                }
            }
        }

        // dont let the player fly away from field
        if ([_player checkOutOfField]) {
            [_player rollbackCalculation];
        };

        Boolean bulletsChanged = false;
        // remove bullets when them hit a stone or out of field
        for (NSUInteger i = 0; i < _bullets.count; ) {
            ZLBullet * bullet = _bullets[i];

            if ([bullet checkOutOfField]) {
                [_bullets removeObjectAtIndex: i];
                bulletsChanged = true;
            } else

            if (bullet.hittedStone) {
                
                // player reward for shooting the stone
                if (![bullet isKindOfClass: [ZLBulletPenalty class]]) {
                    self.score += [bullet.hittedStone isKindOfClass: [ZLStoneNormal class]] ? ZLConfig_rewardNormalStone : ZLConfig_rewardSmallStone;
                }

                if ([bullet isKindOfClass: [ZLBulletNormal class]]) {
                    [_bullets removeObjectAtIndex: i];
                    bulletsChanged = true;
                } else {
                    bullet.hittedStone = nil;
                    i++;
                }
            } else {
                i++;
            }
        }
        if (bulletsChanged) {
            [self bulletsChanged];
        }

        // remove stones out of field
        for (NSUInteger i = 0; i < _stones.count; ) {
            ZLStone * stone = _stones[i];
            if ([stone checkOutOfField]) {
                [_stones removeObjectAtIndex: i];
            } else {
                if (stone.wasHitByBullet) {
                    if ([stone isKindOfClass: [ZLStoneBonus class]]) {
                        [self activateBonus];
                    } else if ([stone isKindOfClass: [ZLStonePenalty class]]) {
                        [self activatePenalty];
                    } else if ([stone isKindOfClass: [ZLStoneNormal class]]) {
                        [self summonSmallStonesFromStone: stone];
                    }
                    [_stones removeObjectAtIndex: i];
                    [_audio collision];
                } else {
                    i++;
                }
            }

        }
    }
}

- (void) paintGame {
    if (_isRunning) {
        [_gameShape paintObject: self];
    }
}

- (void) startMove {
    if (_isRunning) {
        _player.velocity = ZLconfig_playerSpeed;
    }
}

- (void) stopMove {
    if (_isRunning) {
        _player.velocity = 0.0;
    }
}

- (void) switchSound {
    [_audio switchSound];
}

#pragma mark Initialization

- (id) initWithGameViewInfo: (ZLGameViewInfo *) gameViewInfo shape: (ZLShape *) shape {
    if (self = [super initWithGameViewInfo: gameViewInfo shape: shape]) {
        _stones = [NSMutableArray new];
        _bullets = [NSMutableArray new];
        _gameShape = (ZLGameShape *) [[ZLGameShape alloc] init];
        _player = (ZLPlayer *)[[ZLPlayer alloc] initWithGameViewInfo: gameViewInfo shape: _gameShape.playerShape];
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        _bestScore = [userDefaults integerForKey: ZLconfig_bestScoreKey];
        _audio = [ZLGameAudio new];
    }
    return self;
}

@end

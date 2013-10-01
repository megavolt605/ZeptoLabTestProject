//
//  ZLConsts.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Global constants
//

#ifndef ZeptoLabTestProject_ZLConsts_h
#define ZeptoLabTestProject_ZLConsts_h

#pragma mark Global Constants


extern NSString * const ZLRootNIBName;

// NSUserDefaults Best Score key
extern NSString * const ZLconfig_bestScoreKey;

// image names
extern NSString * const ZLconfig_imageNameForMissile;
extern NSString * const ZLconfig_imageNameForMissileRed;
extern NSString * const ZLconfig_imageNameForMissileGreen;
extern NSString * const ZLconfig_imageNameForMissileGray;

extern NSString * const ZLconfig_imageNameForButtonRestart;
extern NSString * const ZLconfig_imageNameForButtonPause;
extern NSString * const ZLconfig_imageNameForButtonPlay;

extern NSString * const ZLconfig_imageNameForButtonMute;
extern NSString * const ZLconfig_imageNameForButtonUnmute;

// info label texts
extern NSString * const ZLconfig_gamePausedText;
extern NSString * const ZLconfig_gameOverText;

// player score label text format
extern NSString * const ZLconfig_scoreLabelFormat;

// best score label text format
extern NSString * const ZLconfig_bestScoreLabelFormat;

// bonus and penalty label text formats
extern NSString * const ZLconfig_bonusLabelFormat;
extern NSString * const ZLconfig_penaltyLabelFormat;

// global scale factor
const static GLfloat ZLconfig_gameFieldScale = 25.0;

// view redraw frequency (1/x sec)
const static GLfloat ZLconfig_animationFrameRate = 100.0;

// game tick frequency (1/x sec)
const static GLfloat ZLconfig_gameSpeed = 100.0;

// stone mass for collusion calculation
const static GLfloat ZLconfig_stoneMass = 3.0;

// small stone mass
const static GLfloat ZLconfig_smallStoneMass = 1.0;

// small stone velocity range
const static GLfloat ZLconfig_smallStoneVelocity = 0.01;
const static GLfloat ZLconfig_smallStoneVelocityRange = 0.05;

// min and max velocity for new stone
const static GLfloat ZLconfig_stoneMinVelocity = 5.0;
const static GLfloat ZLconfig_stoneMaxVelocity = 10.0;

// how often we will receive information from accelerometer (1/x sec)
const static GLfloat ZLconfig_accelerometerPeriod = 20.0;

// stone summon frequency (sec)
const static GLfloat ZLconfig_stoneSummonPeriod = 5.0;

// how often summon frequency increased (sec)
const static GLfloat ZLconfig_stoneSummonAccelerationPeriod = 10.0;
const static GLfloat ZLconfig_stoneSummonAccelerationValue = 0.2;

// maximum number of simultaneously fired bullets
const static NSUInteger ZLconfig_bulletsCount = 5;

// minimal deviation of the accelerometer to start player rotation
const static GLfloat ZLconfig_acceleratorSensetivity = 0.1;

// speed of the player rotation
const static GLfloat ZLconfig_playerRotationAngle = 0.1;

// speed of the player
const static GLfloat ZLconfig_playerSpeed = 0.2;

// velocity incrementor of bullets
const static GLfloat ZLconfig_bulletVelocity = 0.1;

// small stones count, that will be summoned from hitted normal stone
const static NSUInteger ZLconfig_smallStonesCount = 3;

// shooting stones rewards
const static NSUInteger ZLConfig_rewardNormalStone = 1;
const static NSUInteger ZLConfig_rewardSmallStone = 3;

// duration of bonus and penalty
const static CGFloat ZLconfig_bonusDuration = 20.0;
const static CGFloat ZLconfig_penaltyDuration = 20.0;


#endif

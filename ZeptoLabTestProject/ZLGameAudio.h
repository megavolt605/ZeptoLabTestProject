//
//  ZLGameAudio.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//
//  Music & sound support
//

@interface ZLGameAudio : NSObject

// background music
- (void) startBackground;
- (void) stopBackground;
- (void) pauseBackground;
- (void) resumeBackground;

// game sounds
- (void) fireBullet;
- (void) collision;
- (void) death;

// mute / unmute all sounds & music
- (void) switchSound;

@end

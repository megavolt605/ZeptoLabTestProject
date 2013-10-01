//
//  ZLGameAudio.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLGameAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ZLGameAudio () {
    AVAudioPlayer * _player;
    Boolean _muteSounds;
    Boolean _playing;

    NSURL * _backgroundURL;

    NSURL * _missleSoundURL;
    SystemSoundID _missleSound;

    NSURL * _collisionSoundURL;
    SystemSoundID _collisionSound;

    NSURL * _deathSoundURL;
    SystemSoundID _deathSound;
}
@end

@implementation ZLGameAudio

- (void) startBackground {
    _player.currentTime = 0.0;
    [_player play];
    _playing = true;
}

- (void) stopBackground {
    [_player stop];
    _playing = false;
}

- (void) pauseBackground {
    [_player pause];
}

- (void) resumeBackground {
    [_player play];
}

- (void) playSoundURL: (NSURL *) url soundID: (SystemSoundID *) soundID {
    if (!_muteSounds) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef) url, soundID);
        AudioServicesPlaySystemSound(*soundID);
        // we can dispose the system sound id after 30 second period (maximum sound long)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 30 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            AudioServicesDisposeSystemSoundID(*soundID);
        });
    }
}

- (void) fireBullet {
    [self playSoundURL: _missleSoundURL soundID: &_missleSound];
}

- (void) collision {
    [self playSoundURL: _collisionSoundURL soundID: &_deathSound];
}

- (void) death {
    [self playSoundURL: _deathSoundURL soundID: &_deathSound];
}

- (void) switchSound {
    _muteSounds = !_muteSounds;
    if (_muteSounds) {
        [_player pause];
    } else {
        if (_playing) {
            [_player play];
        }
    }
}

#pragma mark Initialization

- (id) init {
    if (self = [super init]) {

        _missleSoundURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"missle" ofType: @"m4a"]];
        _collisionSoundURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"collision" ofType: @"m4a"]];
        _deathSoundURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"death" ofType: @"m4a"]];

        _backgroundURL = [NSURL fileURLWithPath: [[NSBundle mainBundle] pathForResource: @"background" ofType: @"mp3"]];
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL: _backgroundURL error: nil];
        _player.volume = 0.5;
        _player.numberOfLoops = -1;
    }
    return self;
}


@end

//
//  ZLViewController.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLViewController.h"

@interface ZLViewController () {
    ZLGame * _game;
    ZLGameViewInfo * _gameViewInfo;

    // cached images
    UIImage * _blueMissile;
    UIImage * _redMissile;
    UIImage * _greenMissile;
    UIImage * _grayMissile;

    UIImage * _restartImage;
    UIImage * _pauseImage;
    UIImage * _playImage;

    // timer for bonus and penalty countdown
    NSTimer * _bonusAndPenaltyDurationTimer;
    NSDate * _pauseStart, * _previousFireDate;
    NSTimeInterval _bonusAndPenaltyTime;
    Boolean _bonusAndPenaltyLabelUpdated;
    ZLPlayerState _playerState;

    Boolean _soundsMuted;

    NSUInteger _iddqdCount;
}

@end

@implementation ZLViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _blueMissile = [UIImage imageNamed: ZLconfig_imageNameForMissile];
    _redMissile = [UIImage imageNamed: ZLconfig_imageNameForMissileRed];
    _greenMissile = [UIImage imageNamed: ZLconfig_imageNameForMissileGreen];
    _grayMissile = [UIImage imageNamed: ZLconfig_imageNameForMissileGray];

    _restartImage = [UIImage imageNamed: ZLconfig_imageNameForButtonRestart];
    _pauseImage = [UIImage imageNamed: ZLconfig_imageNameForButtonPause];
    _playImage = [UIImage imageNamed: ZLconfig_imageNameForButtonPlay];

    _gameViewInfo = [ZLGameViewInfo new];
    _game = [[ZLGame alloc] initWithGameViewInfo: _gameViewInfo shape: nil];
    _game.delegate = self;
    ((ZLView *) self.view).delegate = self;
    [_bestScoreLabel setTextColor: [UIColor yellowColor]];
    [_scoreLabel setTextColor: [UIColor whiteColor]];
    [self hideInfo];
    [self updateButtons];
    [self updateLabels];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) pauseGame {
    if (_game.isRunning) {
        [self pauseResumeClick: _pauseResumeButton];
    }
}

- (void) resumeGame {
    if (_game.isRunning) {
        [self pauseResumeClick: _pauseResumeButton];
    }
}

- (void) updateButtons {
    [_startRestartButton setEnabled: true];
    [_pauseResumeButton setEnabled: _game.isRunning];
    [_stopButton setEnabled: _game.isRunning];
    [_fireButton setEnabled: _game.isRunning];
    [_moveButton setEnabled: _game.isRunning];
}

- (void) updateLabels {
    _bestScoreLabel.text = [NSString stringWithFormat: ZLconfig_bestScoreLabelFormat, _game.bestScore];
    _scoreLabel.text = [NSString stringWithFormat: ZLconfig_scoreLabelFormat, _game.score];
}

- (void) showInfo: (NSString *) text color: (UIColor *) color {
    _infoLabel.text = text;
    _infoLabel.textColor = color;
    _infoLabel.hidden = false;
}

- (void) hideInfo {
    _infoLabel.hidden = true;
}

- (IBAction)startRestartClick: (UIButton *) sender {
    if (_game.isRunning) {
        [(ZLView *) self.view stopAnimation];
        [_game stopGame];
        if (_bonusAndPenaltyDurationTimer) {
            [_bonusAndPenaltyDurationTimer invalidate];
            _bonusAndPenaltyDurationTimer = nil;
        }
    } else {
        [_startRestartButton setImage: _restartImage forState: UIControlStateNormal];
    }
    [self hideInfo];
    _bonusAndPenaltyTimeLabel.hidden = true;
    [(ZLView *) self.view startAnimation];
    [_game startGame];
    [self updateButtons];
}

- (IBAction)pauseResumeClick: (UIButton *) sender {
    if (_game.isPaused) {
        [(ZLView *) self.view startAnimation];
        [_game resumeGame];
        [_pauseResumeButton setImage: _pauseImage forState: UIControlStateNormal];
        if (_bonusAndPenaltyDurationTimer) {
            // restore bonus and penalty timer
            float pauseTime = -1 * [_pauseStart timeIntervalSinceNow];
            _bonusAndPenaltyTime += pauseTime;
            [_bonusAndPenaltyDurationTimer setFireDate: [_previousFireDate initWithTimeInterval: pauseTime sinceDate: _previousFireDate]];
        }
        [self hideInfo];
    } else {
        [(ZLView *) self.view stopAnimation];
        [_game pauseGame];
        [_pauseResumeButton setImage: _playImage forState: UIControlStateNormal];
        [self showInfo: ZLconfig_gamePausedText color: [UIColor whiteColor]];
        if (_bonusAndPenaltyDurationTimer) {
            // save bonus and penalty timer
            _pauseStart = [NSDate dateWithTimeIntervalSinceNow: 0];
            _previousFireDate = [_bonusAndPenaltyDurationTimer fireDate];
            [_bonusAndPenaltyDurationTimer setFireDate: [NSDate distantFuture]];
        }
    }
}

- (IBAction)stopClick: (UIButton *) sender {
    if (_game.isRunning) {
        [_game stopGame];
    }
}

- (IBAction)soundSwitchClick:(UIButton *)sender {
    _soundsMuted = !_soundsMuted;
    [_game switchSound];
    NSString * imageName = _soundsMuted ? ZLconfig_imageNameForButtonMute : ZLconfig_imageNameForButtonUnmute;
    [_soundSwitchButton setImage: [UIImage imageNamed: imageName] forState: UIControlStateNormal];
    
}

- (IBAction)fireClick:(UIButton *)sender {
    [_game fireBullet];
}


- (IBAction)moveClick:(UIButton *)sender {
    [_game startMove];
}


- (IBAction)moveUnclick:(UIButton *)sender {
    [_game stopMove];
}

- (IBAction)IDDQDClick:(UIButton *)sender {
    _iddqdCount++;
    if (_iddqdCount % 5 == 0) {
        if (_iddqdCount % 10 == 0) {
            _game.IDDQD = false;
            _scoreLabel.textColor = [UIColor whiteColor];
        } else {
            _game.IDDQD = true;
            _scoreLabel.textColor = [UIColor greenColor];
        }
    }
}

- (void) stopGame {
    [(ZLView *) self.view stopAnimation];
    [_startRestartButton setImage: _playImage forState: UIControlStateNormal];
    [_pauseResumeButton setImage: _pauseImage forState: UIControlStateNormal];
    if (_bonusAndPenaltyDurationTimer) {
        [_bonusAndPenaltyDurationTimer invalidate];
        _bonusAndPenaltyDurationTimer = nil;
    }
    _bonusAndPenaltyTimeLabel.hidden = true;
    [self updateButtons];
    [self showInfo: ZLconfig_gameOverText color: [UIColor redColor]];
}


#pragma mark <ZLViewProtocol> protocol

- (void) didCreateFrameBuffer: (ZLView *) view {
	glMatrixMode(GL_PROJECTION);
	CGRect rect = view.bounds;
    GLfloat ratio = rect.size.width / rect.size.height;
	glFrustumf(-ZLconfig_gameFieldScale,
               ZLconfig_gameFieldScale,
               -ZLconfig_gameFieldScale / ratio,
               ZLconfig_gameFieldScale / ratio, 1, 100000);
    glViewport(0, 0, rect.size.width, rect.size.height);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
    glClearColorx(0x00, 0x00, 0x2F00, 0xFF00);
    
    glColor4ub(0x00, 0x00, 0x00, 0xFF);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);

    //glClearColor(0.0, 0.0, 0.5, 1.0);
    
    _gameViewInfo.frame = CGRectMake( -ZLconfig_gameFieldScale,
                                     -ZLconfig_gameFieldScale / ratio,
                                     2 * ZLconfig_gameFieldScale,
                                     2 * ZLconfig_gameFieldScale / ratio);
}

- (void) drawContentInView: (ZLView *) view {
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [_game paintGame];
}

- (UIImage *) imageForPlayerState: (ZLPlayerState) state {
    switch (state) {
        case zlpsBonus: return _redMissile;
        case zlpsPenalty: return _greenMissile;
        default: return _blueMissile;
    }
}

- (void) updateBonusAndPenaltyDurationLabel {
    if (!_bonusAndPenaltyLabelUpdated) {
        _bonusAndPenaltyTimeLabel.textColor = (_playerState == zlpsBonus) ? [UIColor redColor] : [UIColor greenColor];
        _bonusAndPenaltyTimeLabel.hidden = false;
        _bonusAndPenaltyLabelUpdated = true;
    }
    NSTimeInterval time = (_bonusAndPenaltyTime - [NSDate timeIntervalSinceReferenceDate]);
    if (time > 0.0) {
        NSString * text =
            [NSString stringWithFormat: (_playerState == zlpsBonus) ? ZLconfig_bonusLabelFormat : ZLconfig_penaltyLabelFormat, time];
        _bonusAndPenaltyTimeLabel.text = text;
    } else {
        [_bonusAndPenaltyDurationTimer invalidate];
        _bonusAndPenaltyDurationTimer = nil;
        _bonusAndPenaltyTimeLabel.hidden = true;
    }
}

#pragma mark <ZLGameDelegate> protocol

- (void) game: (ZLGame *) game didFinishWithScore: (NSUInteger) score {
    [self stopGame];
}

- (void) game: (ZLGame *) game didChangeScore: (NSUInteger) score {
    [self updateLabels];
}

- (void) game: (ZLGame *) game didChangePlayer: (ZLPlayer *) player state: (ZLPlayerState) state forTime: (CGFloat) time {
    _playerState = state;
    UIImage * image = [self imageForPlayerState: _playerState];
    [_fireButton setImage: image forState: UIControlStateNormal];
    for (NSUInteger i = 0; i < ZLconfig_bulletsCount; i++) {
        [_availableMissiles[i] setImage: image];
    }
    if (_playerState == zlpsBonus || _playerState == zlpsPenalty) {
        _bonusAndPenaltyTime = [NSDate timeIntervalSinceReferenceDate] + time;
        _bonusAndPenaltyLabelUpdated = false;
        _bonusAndPenaltyDurationTimer = [NSTimer scheduledTimerWithTimeInterval: 0.2
                                                                         target: self
                                                                       selector: @selector(updateBonusAndPenaltyDurationLabel)
                                                                       userInfo: nil
                                                                        repeats: true];
    }
}

- (void) game: (ZLGame *) game didChangePlayer: (ZLPlayer *) player bullets: (NSArray *) bullets {
    for (NSUInteger i = 0; i < _availableMissiles.count; i++) {
        UIImageView * imageView = _availableMissiles[i];
        if (i < ZLconfig_bulletsCount) {
            if (i < (ZLconfig_bulletsCount - bullets.count)) {
                [imageView setImage: [self imageForPlayerState: player.state]];
            } else {
                [imageView setImage: _grayMissile];
            }
            imageView.hidden = false;
        } else {
            imageView.hidden = true;
        }
    }
}

@end

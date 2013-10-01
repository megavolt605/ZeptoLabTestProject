//
//  ZLViewController.h
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLView.h"
#import "ZLGame.h"

@interface ZLViewController : UIViewController <ZLViewProtocol, ZLGameDelegate>

- (void) pauseGame;
- (void) resumeGame;

// buttons actions

- (IBAction)startRestartClick: (UIButton *) sender;
- (IBAction)pauseResumeClick: (UIButton *) sender;
- (IBAction)stopClick: (UIButton *) sender;
- (IBAction)soundSwitchClick:(UIButton *)sender;

- (IBAction)fireClick: (UIButton *) sender;
- (IBAction)moveClick: (UIButton *) sender;

// god mode button (you can find it in the right bottom corner of the view)
// needs to click 5 times for activation
- (IBAction)IDDQDClick:(UIButton *)sender;

// outlets

// text labels
@property (weak, nonatomic) IBOutlet UILabel * scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel * bestScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel * bonusAndPenaltyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel * infoLabel;

// game buttons
@property (weak, nonatomic) IBOutlet UIButton * startRestartButton;
@property (weak, nonatomic) IBOutlet UIButton * pauseResumeButton;
@property (weak, nonatomic) IBOutlet UIButton * stopButton;
@property (weak, nonatomic) IBOutlet UIButton *soundSwitchButton;

// player activity buttons
@property (weak, nonatomic) IBOutlet UIButton * fireButton;
@property (weak, nonatomic) IBOutlet UIButton * moveButton;

// huge label with game state text
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *availableMissiles;

@end

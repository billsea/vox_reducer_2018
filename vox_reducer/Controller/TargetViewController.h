//
//  TargetViewController.h
//  vrMobile
//
//  Created by bill on 9/3/11.
//  Copyright 2011 __Loudsoftware__. All rights reserved.
//

#import "InfoViewController.h"

@class audioPlayback;
@class loudRotaryKnob;

@interface TargetViewController
    : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property(nonatomic, retain) NSString *SenderName;
@property(nonatomic, retain) audioPlayback *player;
@property(nonatomic, retain) IBOutlet UILabel *label;
@property(nonatomic, retain) IBOutlet UILabel *labelHeading;
@property(nonatomic, retain) IBOutlet UILabel *lowerFreqBound;
@property(nonatomic, retain) IBOutlet UILabel *upperFreqBound;
@property(nonatomic, retain) IBOutlet loudRotaryKnob *rotaryKnob;
@property(nonatomic, retain) NSTimer *scanTimer;

- (IBAction)rotaryKnobDidChange;
- (IBAction)incrementNudge;
- (IBAction)decrementNudge;
- (IBAction)incrementStartAction:(id)sender;
- (IBAction)incrementStopAction:(id)sender;
- (IBAction)decrementStartAction:(id)sender;
- (IBAction)decrementStopAction:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)showInfo:(id)sender;

- (void)incrementRepeat:(NSTimer *)timer;
- (void)incrementKnobValue;
- (void)decrementRepeat:(NSTimer *)timer;
- (void)decrementKnobValue;

@end


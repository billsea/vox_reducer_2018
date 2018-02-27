//
//  playbackViewController.h
//  vrMobile
//
//  Created by bill on 9/2/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
//#import "audioPlayback.h"
#import "TargetViewController.h"
#import "PresetsViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface playbackViewController : UIViewController <MPMediaPickerControllerDelegate, GADBannerViewDelegate> 
@property (weak, nonatomic) IBOutlet UIView *headerWrapper;
@property(weak, nonatomic) IBOutlet UILabel *lblArtist;
@property(weak, nonatomic) IBOutlet UIButton *onOff;
@property(nonatomic, retain) MPMediaItemCollection *userMediaItemCollection;
@property(nonatomic, weak) IBOutlet UIButton *playButton;
@property(nonatomic) audioPlayback *player;
@property(nonatomic) NSTimer *loadTimer;
@property(weak, nonatomic) IBOutlet UIButton *playbackStop;
@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *fileLoadingBusy;
@property(weak, nonatomic) IBOutlet UIButton *playbackPause;
@property(weak, nonatomic) IBOutlet UIButton *songLabelButton;
@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(weak, nonatomic) IBOutlet UIView *playbackBarView;
@property(weak, nonatomic) IBOutlet UIButton *filterButton;

- (IBAction)showMusic:(id)sender;
- (IBAction)playAudio:(id)sender;
- (IBAction)stopAudio:(id)sender;
- (IBAction)pauseAudio:(id)sender;
- (IBAction)setTarget:(UISlider *)sender;
- (IBAction)setWidth:(UISlider *)sender;
- (IBAction)setIntensity:(UISlider *)sender;
- (IBAction)setPhase:(UISlider *)sender;
- (IBAction)showTarget:(id)sender;
- (IBAction)showWidth:(id)sender;
- (IBAction)showIntensity:(id)sender;
- (IBAction)showPresets:(id)sender;
- (IBAction)setOnOff:(UIButton *)sender;
- (IBAction)filterToggle:(id)sender;

- (void)loadAudioData:(NSTimer *)timer;
- (void)activatePlayback:(NSNotification *)note;
- (void)playbackCompleted:(NSNotification *)note;
- (void)playerReset:(NSNotification *)note;
@end

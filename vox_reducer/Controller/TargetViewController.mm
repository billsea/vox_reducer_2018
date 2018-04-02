//
//  TargetViewController.m
//  vrMobile
//
//  Created by bill on 9/3/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "TargetViewController.h"
#include "audioPlayback.h"
#import "loudRotaryKnob.h"

@implementation TargetViewController {
  float maxKnobValue;
  float minKnobValue;
  float scanTimeInterval;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {

  }
  return self;
}

- (void)setPlayer:(audioPlayback *)player {
	_player = player;
}
- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

	_spectrumView.showFrequencyLabels = YES;

	//Callback for spectrum view display refresh
	TargetViewController __weak *weakSelf = self;
	
	_player.frequencyCallback = ^(Float32* freqData,UInt32 size){
		int length = (int)size;
		NSMutableArray *freqValues = [NSMutableArray new];
		
		for (UInt32 i = 0; i < length; i++) {
			[freqValues addObject:@(freqData[i])];
		}
		
		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
		dispatch_async(queue, ^{
			// Perform async operation
			float freq = weakSelf.player.targetFrequency;
			dispatch_sync(dispatch_get_main_queue(), ^{
				// Update UI
				weakSelf.spectrumView.selectedFrequency = freq;
			});
		});
		
		//TODO: UI main thread bogged down, Put something on background thread?
		//ALSO: App is crashing after a few minutes...check for memory leak
		
		//Validate 256 length
		if (freqValues.count == 256) {
			weakSelf.spectrumView.frequencyValues = freqValues;
		}
	};
	
  // add background image
  UIImage *backgroundimg = [UIImage imageNamed:@"vrMobileBg.png"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundimg];
  [self.view addSubview:imageView];
  [self.view sendSubviewToBack:imageView];

  // Set the title of the navigation item
	[[self navigationItem] setTitle:_senderName];

  // load default values here
  float currentValue = 0;

	if ([_senderName isEqual:@"Target"]) {
    currentValue = [_player targetFrequency];
    [_labelHeading setText:@"Target Frequency (Hz)"];
    [_lowerFreqBound setText:@"100"];
    [_upperFreqBound setText:@"3K"];
    minKnobValue = 100;
    maxKnobValue = 3000;
    scanTimeInterval = 0.005;
    _label.text = [NSString stringWithFormat:@"%.0f", currentValue];
    if (![_player getFilterState]) {
      [self showFilterAlert];
    }
	} else if ([_senderName isEqual:@"Width"]) {
    currentValue = [_player targetBandwidth];
    [_labelHeading setText:@"Target Bandwidth (Hz)"];
    [_lowerFreqBound setText:@"50"];
    [_upperFreqBound setText:@"5K"];
    minKnobValue = 50;
    maxKnobValue = 5000;
    scanTimeInterval = 0.005;
    _label.text = [NSString stringWithFormat:@"%.0f", currentValue];
    if (![_player getFilterState]) {
      [self showFilterAlert];
    }
	} else if ([_senderName isEqual:@"Intensity"]) {
    currentValue = [_player reductionIntensity];
    currentValue = currentValue * 10;
    [_labelHeading setText:@"Reduction Intensity"];
    [_lowerFreqBound setText:@"0"];
    [_upperFreqBound setText:@"10"];
    minKnobValue = 0;
    maxKnobValue = 10;
    scanTimeInterval = 0.1;
    _label.text = [NSString stringWithFormat:@"%.1f", currentValue];
  }

  _rotaryKnob.maximumValue = maxKnobValue;
  _rotaryKnob.minimumValue = minKnobValue;
  _rotaryKnob.value = currentValue;
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  // Clear first responder
  [[self view] endEditing:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	
  _rotaryKnob.defaultValue = _rotaryKnob.value;
  _rotaryKnob.resetsToDefault = YES;
  _rotaryKnob.backgroundColor = [UIColor clearColor];
  _rotaryKnob.backgroundImage = [UIImage imageNamed:@"KnobBackground.png"];

  // this image has issues with not Retina displays
  //[rotaryKnob setKnobImage:[UIImage imageNamed:@"Knob.png"]
  //forState:UIControlStateNormal];

  // this works in simulator but not on device
  [_rotaryKnob setKnobImage:[UIImage imageNamed:@"knobAlt.png"]
                   forState:UIControlStateNormal];

  [_rotaryKnob setKnobImage:[UIImage imageNamed:@"KnobHighlighted.png"]
                   forState:UIControlStateHighlighted];

  [_rotaryKnob setKnobImage:[UIImage imageNamed:@"KnobDisabled.png"]
                   forState:UIControlStateDisabled];

  _rotaryKnob.knobImageCenter = CGPointMake(80.0f, 76.0f);
  [_rotaryKnob addTarget:self
                  action:@selector(rotaryKnobDidChange)
        forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload {
  [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
    (UIInterfaceOrientation)interfaceOrientation {
  // Return YES for supported orientations
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)showFilterAlert {
  NSString *message_title = @"Filters Disabled";
  NSString *message = @"Target and width filtering is currently disabled. To "
                      @"enable filters, go back to the main playback screen, "
                      @"and toggle the Filters button in the playback control "
                      @"display";

  [utility showAlertWithTitle:message_title andMessage:message andVC:self];
}
- (IBAction)backgroundTapped:(id)sender {
  // NSLog(@"backgroundTapped");
  [[self view] endEditing:YES];
}

- (IBAction)showInfo:(id)sender {

  InfoViewController *infoViewController = [[InfoViewController alloc] init];

  // passes and sets type
	[infoViewController setSenderName:_senderName];

  // Push it onto the top of the navigation controller's stack
  [[self navigationController] pushViewController:infoViewController
                                         animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  // NSLog(@"textFieldShouldReturn");
  [textField resignFirstResponder];
  return YES;
}

#pragma rotary knob stuff
- (IBAction)rotaryKnobDidChange {
  // NSLog(@"rotaryKnobDidChange called ...%@",SenderName);

	if ([_senderName isEqual:@"Target"]) {
    _label.text = [NSString stringWithFormat:@"%.0f", _rotaryKnob.value];
    [_player setTarget:_rotaryKnob.value];
	} else if ([_senderName isEqual:@"Width"]) {
    _label.text = [NSString stringWithFormat:@"%.0f", _rotaryKnob.value];
    [_player setTargetWidth:_rotaryKnob.value];
	} else if ([_senderName isEqual:@"Intensity"]) {
    _label.text = [NSString stringWithFormat:@"%.1f", _rotaryKnob.value];
    [_player setIntensity:(_rotaryKnob.value / _rotaryKnob.maximumValue)];
  }
}

- (void)decrementRepeat:(NSTimer *)timer {
  [self decrementKnobValue];
}

- (void)decrementKnobValue {
  if (_rotaryKnob.value > _rotaryKnob.minimumValue) {

		if ([_senderName isEqual:@"Target"]) {
      [_rotaryKnob setValue:_rotaryKnob.value - 1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.0f", _rotaryKnob.value];
      [_player setTarget:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Width"]) {
      [_rotaryKnob setValue:_rotaryKnob.value - 1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.0f", _rotaryKnob.value];
      [_player setTargetWidth:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Intensity"]) {
      [_rotaryKnob setValue:_rotaryKnob.value - 0.1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.1f", _rotaryKnob.value];
      [_player setIntensity:(_rotaryKnob.value / _rotaryKnob.maximumValue)];
    }
  }
}

- (IBAction)decrementNudge {
  [self decrementKnobValue];
}

- (void)incrementKnobValue {
  if (_rotaryKnob.value < _rotaryKnob.maximumValue) {

		if ([_senderName isEqual:@"Target"]) {
      _label.text = [NSString stringWithFormat:@"%.0f", _rotaryKnob.value];
      [_rotaryKnob setValue:_rotaryKnob.value + 1 animated:YES];
      [_player setTarget:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Width"]) {
      _label.text = [NSString stringWithFormat:@"%.0f", _rotaryKnob.value];
      [_rotaryKnob setValue:_rotaryKnob.value + 1 animated:YES];
      [_player setTargetWidth:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Intensity"]) {
      [_rotaryKnob setValue:_rotaryKnob.value + 0.1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.1f", _rotaryKnob.value];
      [_player setIntensity:(_rotaryKnob.value / _rotaryKnob.maximumValue)];
    }
  }
}

- (IBAction)incrementNudge {
  [self incrementKnobValue];
}

- (void)incrementRepeat:(NSTimer *)timer {
  [self incrementKnobValue];
}

- (IBAction)incrementStartAction:(id)sender {
  _scanTimer =
      [NSTimer scheduledTimerWithTimeInterval:scanTimeInterval
                                       target:self
                                     selector:@selector(incrementRepeat:)
                                     userInfo:nil
                                      repeats:YES];
}

- (IBAction)incrementStopAction:(id)sender {
  [_scanTimer invalidate];
}

- (IBAction)decrementStartAction:(id)sender {
  _scanTimer =
      [NSTimer scheduledTimerWithTimeInterval:scanTimeInterval
                                       target:self
                                     selector:@selector(decrementRepeat:)
                                     userInfo:nil
                                      repeats:YES];
}
- (IBAction)decrementStopAction:(id)sender {
  [_scanTimer invalidate];
}

@end

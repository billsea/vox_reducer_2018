//
//  TargetViewController.m
//  vrMobile
//
//  Created by bill on 9/3/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "TargetViewController.h"
#import "loudRotaryKnob.h"
#import "AudioManager.h"

@implementation TargetViewController {
  float maxKnobValue;
  float minKnobValue;
  float scanTimeInterval;
	AudioManager * _sharedManager;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
			_sharedManager = [AudioManager sharedManager];
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
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

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

	_spectrumView.showFrequencyLabels = YES;
	_spectrumView.showSelectedBandwidth = YES;

	//Callback for spectrum view display refresh
	TargetViewController __weak *weakSelf = self;
	AudioManager __weak *weakSharedManager = _sharedManager;
	
	_sharedManager.player.frequencyCallback = ^(Float32* freqData,UInt32 size){
		int length = (int)size;
		NSMutableArray *freqValues = [NSMutableArray new];

		for (UInt32 i = 0; i < length; i++) {
			[freqValues addObject:@(freqData[i])];
		}

		dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
		dispatch_async(queue, ^{
			// Perform async operation
			float freq = weakSharedManager.player.targetFrequency;
			float effectiveBandwidth = weakSharedManager.player.targetBandwidth;
			dispatch_sync(dispatch_get_main_queue(), ^{
				// Update UI
				weakSelf.spectrumView.selectedFrequency = freq;
				weakSelf.spectrumView.selectedBandwidth = effectiveBandwidth;
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
	bool filterOn = [_sharedManager.player getFilterState];
	
	if ([_senderName isEqual:@"Target"]) {
    currentValue = [_sharedManager.player targetFrequency];
		[_labelHeading setText:@"Target Frequency:"];
    [_lowerFreqBound setText:@"100"];
    [_upperFreqBound setText:@"3K"];
    minKnobValue = 100;
    maxKnobValue = 3000;
    scanTimeInterval = 0.005;
		_label.text = [NSString stringWithFormat:@"%.0f Hz", currentValue];
		_filterMessage.hidden = filterOn;
	} else if ([_senderName isEqual:@"Width"]) {
    currentValue = [_sharedManager.player targetBandwidth];
		[_labelHeading setText:@"Target Bandwidth:"];
    [_lowerFreqBound setText:@"50"];
    [_upperFreqBound setText:@"5K"];
    minKnobValue = 50;
    maxKnobValue = 5000;
    scanTimeInterval = 0.005;
    _label.text = [NSString stringWithFormat:@"%.0f Hz", currentValue];
		_filterMessage.hidden = filterOn;
	} else if ([_senderName isEqual:@"Intensity"]) {
    currentValue = [_sharedManager.player reductionIntensity];
    currentValue = currentValue * 10;
		[_labelHeading setText:@"Reduction Intensity:"];
    [_lowerFreqBound setText:@"0"];
    [_upperFreqBound setText:@"10"];
    minKnobValue = 0;
    maxKnobValue = 10;
    scanTimeInterval = 0.1;
    _label.text = [NSString stringWithFormat:@"%.1f", currentValue];
		_filterMessage.hidden = YES;
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



- (void)viewDidUnload {
  [super viewDidUnload];
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
    _label.text = [NSString stringWithFormat:@"%.0f Hz", _rotaryKnob.value];
    [_sharedManager.player setTarget:_rotaryKnob.value];
	} else if ([_senderName isEqual:@"Width"]) {
    _label.text = [NSString stringWithFormat:@"%.0f Hz", _rotaryKnob.value];
    [_sharedManager.player setTargetWidth:_rotaryKnob.value];
	} else if ([_senderName isEqual:@"Intensity"]) {
    _label.text = [NSString stringWithFormat:@"%.1f", _rotaryKnob.value];
    [_sharedManager.player setIntensity:(_rotaryKnob.value / _rotaryKnob.maximumValue)];
  }
}

- (void)decrementRepeat:(NSTimer *)timer {
  [self decrementKnobValue];
}

- (void)decrementKnobValue {
  if (_rotaryKnob.value > _rotaryKnob.minimumValue) {

		if ([_senderName isEqual:@"Target"]) {
      [_rotaryKnob setValue:_rotaryKnob.value - 1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.0f Hz", _rotaryKnob.value];
      [_sharedManager.player setTarget:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Width"]) {
      [_rotaryKnob setValue:_rotaryKnob.value - 1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.0f Hz", _rotaryKnob.value];
      [_sharedManager.player setTargetWidth:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Intensity"]) {
      [_rotaryKnob setValue:_rotaryKnob.value - 0.1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.1f", _rotaryKnob.value];
      [_sharedManager.player setIntensity:(_rotaryKnob.value / _rotaryKnob.maximumValue)];
    }
  }
}


- (void)incrementKnobValue {
  if (_rotaryKnob.value < _rotaryKnob.maximumValue) {

		if ([_senderName isEqual:@"Target"]) {
      _label.text = [NSString stringWithFormat:@"%.0f Hz", _rotaryKnob.value];
      [_rotaryKnob setValue:_rotaryKnob.value + 1 animated:YES];
      [_sharedManager.player setTarget:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Width"]) {
      _label.text = [NSString stringWithFormat:@"%.0f Hz", _rotaryKnob.value];
      [_rotaryKnob setValue:_rotaryKnob.value + 1 animated:YES];
      [_sharedManager.player setTargetWidth:_rotaryKnob.value];
		} else if ([_senderName isEqual:@"Intensity"]) {
      [_rotaryKnob setValue:_rotaryKnob.value + 0.1 animated:YES];
      _label.text = [NSString stringWithFormat:@"%.1f", _rotaryKnob.value];
      [_sharedManager.player setIntensity:(_rotaryKnob.value / _rotaryKnob.maximumValue)];
    }
  }
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

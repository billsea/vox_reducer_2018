//
//  PresetsViewController.m
//  vrMobile
//
//  Created by bill on 9/6/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "PresetsViewController.h"
#import "Preset.h"
#import "PresetStore.h"

@implementation PresetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad {
  [super viewDidLoad];
	
	_sharedManager = [AudioManager sharedManager];
	
  // Set the title of the navigation item
  [[self navigationItem] setTitle:@"Presets"];

  _factoryDefaultCount = 1; // upper bound
  _presetOptions = [[NSMutableArray alloc] init];
  [self loadUserPresets];
	
}

- (void)loadUserPresets {
  PresetStore *ps = [PresetStore defaultStore];
  [ps fetchPresets];

  // load user presets
  [_presetOptions removeAllObjects];
  long presetCount = [[ps allPresets] count];
  for (long i = 0; i < presetCount; i++) {
    [_presetOptions addObject:[[[ps allPresets] objectAtIndex:i] presetName]];
  }
  [_presetSelect reloadAllComponents];
  [_presetSelect selectRow:0 inComponent:0 animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated {
  [[PresetStore defaultStore] saveChanges];
}

#pragma mark Picker DataSource/Delegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
    numberOfRowsInComponent:(NSInteger)component {
  return [_presetOptions count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component {
  return [_presetOptions objectAtIndex:row];
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
  NSString *title = [_presetOptions objectAtIndex:row];
  NSAttributedString *attString = [[NSAttributedString alloc]
      initWithString:title
          attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

  return attString;
}

- (IBAction)showInfo:(id)sender {

  InfoViewController *infoViewController = [[InfoViewController alloc] init];

  // passes and sets type
  [infoViewController setSenderName:@"Presets"];
  [[self navigationController] pushViewController:infoViewController
                                         animated:YES];
}

- (IBAction)loadPreset:(id)sender {
  PresetStore *ps = [PresetStore defaultStore];
  NSArray *presets = [ps allPresets];
  Preset *pre =
      [presets objectAtIndex:[_presetSelect selectedRowInComponent:0]];

  // set properies of player
  [_sharedManager.player setTarget:[pre presetTarget]];
  [_sharedManager.player setTargetWidth:[pre presetWidth]];
  [_sharedManager.player setIntensity:[pre presetIntensity]];
  [_sharedManager.player setPresetName:[pre presetName]];
}

- (IBAction)removePreset:(id)sender {
  if ([_presetSelect selectedRowInComponent:0] >= _factoryDefaultCount) {
    PresetStore *ps = [PresetStore defaultStore];
    NSArray *presets = [ps allPresets];
    Preset *pre =
        [presets objectAtIndex:[_presetSelect selectedRowInComponent:0]];
    [ps removePreset:pre];
    [ps saveChanges];
    [self loadUserPresets];
  }
}

- (IBAction)addPreset:(id)sender {
	UIAlertController *alert = [UIAlertController
															alertControllerWithTitle:@"Preset name"
															message:@"Enter Preset name:"
															preferredStyle:UIAlertControllerStyleAlert];

	[alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
		textField.placeholder = @"Enter Preset Name";
		textField.secureTextEntry = NO;
	}];
	
	UIAlertAction *okAction =
	[UIAlertAction actionWithTitle:@"OK"
													 style:UIAlertActionStyleDefault
												 handler:^(UIAlertAction *action){
													 NSString *entered = [[alert textFields][0] text];
													 PresetStore *ps = [PresetStore defaultStore];
													 [ps createPresetWithName:entered
																					andTarget:_sharedManager.player.targetFrequency
																					 andWidth:_sharedManager.player.targetBandwidth
																			 andIntensity:_sharedManager.player.reductionIntensity];
													 [ps saveChanges];
													 [self loadUserPresets];
												 }];
	[alert addAction:okAction];
	UIAlertAction *cancelAction =
	[UIAlertAction actionWithTitle:@"Cancel"
													 style:UIAlertActionStyleDefault
												 handler:^(UIAlertAction *action){
												 }];
	[alert addAction:cancelAction];
	[self presentViewController:alert animated:YES completion:nil];
}
@end

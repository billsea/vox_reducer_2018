//
//  InfoViewController.m
//  vrMobile
//
//  Created by bill on 9/5/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "InfoViewController.h"

@implementation InfoViewController

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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
  // add background image
  UIImage *backgroundimg = [UIImage imageNamed:@"vrMobileBg.png"];
  UIImageView *imageView = [[UIImageView alloc] initWithImage:backgroundimg];
  [self.view addSubview:imageView];
  [self.view sendSubviewToBack:imageView];

  [_infoText setBackgroundColor:[UIColor clearColor]];

  // Set the title of the navigation item
  [[self navigationItem] setTitle:@"Info"];

  [_titleLabel setText:_SenderName];

  if ([_SenderName isEqual:@"Target"]) {
    [_infoText setText:@"Adjusting the Target sets the target frequency of the "
                       @"music track to be processed. For singers with lower "
                       @"voices the setting will be lower end frequencies, "
                       @"for singers with higher voices the setting will be "
                       @"higher frequencies. Use the touch dial to get a "
                       @"rough setting, and fine tune with the scan (<< , >>) "
                       @"and increment (+ , -) buttons."];
  }

  if ([_SenderName isEqual:@"Width"]) {
    [_infoText
        setText:@"Adjusting the Width expands or contracts the 'bandwidth' or "
                @"size of the processed portion of the audio spectrum around "
                @"the target. So, if the vocalist has a narrow range, then "
                @"set the Width to a lower value. If the singer has a wide "
                @"range, then set the Width higher. You generally want to "
                @"keep the width setting to a minimum in order to limit the "
                @"amount of the audio spectrum affected by processing. Use "
                @"the touch dial to get a rough setting, and fine tune with "
                @"the scan (<< , >>) and increment (+ , -) buttons."];
  }

  if ([_SenderName isEqual:@"Intensity"]) {
    [_infoText setText:@"Intensity is the level of vocal reduction, where 0 is "
                       @"no reduction and 10 being full reduction. (To avoid "
                       @"audio artifacts in processing, please try not to add "
                       @"more vocal reduction than needed.) Use the touch "
                       @"dial to get a rough setting, and fine tune with the "
                       @"scan (<< , >>) and increment (+ , -) buttons."];
  }

  if ([_SenderName isEqual:@"Presets"]) {
    [_infoText setText:@"Select a preset with the picker control, and select "
                       @"'Load Preset'. You may use a factory preset or "
                       @"create one of your own. 'Save Current as Preset' "
                       @"saves your current Target, Width, and Intensity "
                       @"settings to a new preset."];
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload {
  [self setTitleLabel:nil];
  [self setInfoText:nil];
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
}

@end


//
//  playbackViewController.m
//  vrMobile
//
//  Created by bill on 9/2/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "playbackViewController.h"
#import <CoreMedia/CoreMedia.h>
//#import "AdViewController.h"
#import "audioPlayback.h"

#define softwareMinimum 7.0

@interface playbackViewController ()
@property UIBarButtonItem *selectButton;
@end

@implementation playbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil {
  self =
      [super initWithNibName:@"playbackViewController" bundle:nibBundleOrNil];
  if (self) {
		
    // allocate the audio player
    _player = [[audioPlayback alloc] init];
    [_player initializeAudio];

    // notification for when audio data is finished loading
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(activatePlayback:)
               name:@"playbackReady"
             object:nil];

    // notification for when playback is completed
    NSNotificationCenter *stp = [NSNotificationCenter defaultCenter];
    [stp addObserver:self
            selector:@selector(playbackCompleted:)
                name:@"playbackCompleted"
              object:nil];

    // notification for bad file
    NSNotificationCenter *pReset = [NSNotificationCenter defaultCenter];
    [pReset addObserver:self
               selector:@selector(playerReset:)
                   name:@"badFileReset"
                 object:nil];

    // don't let device go to background(sleep mode)
    [UIApplication sharedApplication].idleTimerDisabled = YES;
  }
  return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Check the system version
	NSString *version = [[UIDevice currentDevice] systemVersion];
	
	if ([version floatValue] < softwareMinimum)
		[utility showAlertWithTitle:@"Error" andMessage:@"VoxReducer requires iOS 7.0 or higher" andVC:self];
	
	_playbackBarView.layer.cornerRadius = 5;
	
	#if defined(TARGET_ADS)
		[self displayAdBanner];
		NSLog(@"Ads version");
	#else
		NSLog(@"Pay version");
	#endif
	
}

- (void)viewWillAppear:(BOOL)animated {
	_spectrumView.showFrequencyLabels = NO;
	
	//Callback for spectrum view display refresh
	playbackViewController __weak *weakSelf = self;
	
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
	
	// navigation bar
	UIBarButtonItem *selectButton =
	[[UIBarButtonItem alloc] initWithTitle:@"Select"
																	 style:UIBarButtonItemStylePlain
																	target:self
																	action:@selector(showMusic:)];
	
	self.selectButton.tintColor = [UIColor brownColor];
	
	// Set this bar button item as the right item in the navigationItem
	[[self navigationItem] setRightBarButtonItem:selectButton];
	
	[self.navigationController.navigationBar
	 setBackgroundImage:[UIImage imageNamed:@"brushedMetal.png"]
	 forBarMetrics:UIBarMetricsDefault];
	
	// set navigation bar color(for select, back buttons)
	[self.navigationController.navigationBar
	 setTintColor:[UIColor colorWithRed:0.627 green:0.212 blue:0.039 alpha:1]];
	
	UIColor *background = [[UIColor alloc]
												 initWithPatternImage:[UIImage imageNamed:@"brushedMetal.png"]];
	_playbackBarView.backgroundColor = background;
	
	// Set the title of the navigation item
	[[self navigationItem] setTitle:@"Playback"];
	
	[_tableView reloadData];
}

- (void)viewDidUnload {
	_fileLoadingBusy = nil;
	_player = nil;
	[UIApplication sharedApplication].idleTimerDisabled = NO;
}

#pragma mark Ads
- (void)displayAdBanner {
	//Display Google Ad banner
	float bannerHeight = 50.0f;
	
	GADBannerView *adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
	adView.backgroundColor = [UIColor clearColor];
	adView.rootViewController = self;
	adView.delegate = self;
	adView.adUnitID = @"ca-app-pub-4669665110468399/5527082443";//Active id
	//test id: @"ca-app-pub-3940256099942544/2934735716";
	[self.view addSubview:adView]; // Request an ad without any additional targeting information.
	//adds test ads
	[adView loadRequest:self.request];
	
	//adjust subviews
	CGRect r = _headerWrapper.frame;
	r.origin.y = bannerHeight;
	_headerWrapper.frame = r;
	
	r = _playbackBarView.frame;
	r.origin.y =_headerWrapper.frame.origin.y + _headerWrapper.frame.size.height;
	_playbackBarView.frame = r;
	
	r = _tableView.frame;
	r.origin.y = _playbackBarView.frame.origin.y + _playbackBarView.frame.size.height;
	_tableView.frame = r;
}

- (GADRequest *)request {
	GADRequest *request = [GADRequest request];
	//device and simulator test ids
	request.testDevices = @[@"device_id_here", kGADSimulatorID];
	return request;
}
- (void)showAdView {
	//Interstitial ad view
	//[self.navigationController pushViewController:adViewController animated:YES];
}

#pragma mark filters
- (IBAction)showTarget:(id)sender {
  TargetViewController *targetViewController =
      [[TargetViewController alloc] init];

  // passes and sets the audioPlayer object in the targetViewController
  [targetViewController setPlayer:_player];

  // passes and sets type
  [targetViewController setSenderName:@"Target"];

  // Push it onto the top of the navigation controller's stack
  [[self navigationController] pushViewController:targetViewController
                                         animated:YES];
}

- (IBAction)showWidth:(id)sender {

  TargetViewController *targetViewController =
      [[TargetViewController alloc] init];

  // passes and sets the audioPlayer object in the targetViewController
  [targetViewController setPlayer:_player];

  // passes and sets type
  [targetViewController setSenderName:@"Width"];

  // Push it onto the top of the navigation controller's stack
  [[self navigationController] pushViewController:targetViewController
                                         animated:YES];
}

- (IBAction)showIntensity:(id)sender {
  TargetViewController *targetViewController =
      [[TargetViewController alloc] init];

  // passes and sets the audioPlayer object in the targetViewController
  [targetViewController setPlayer:_player];

  // passes and sets type
  [targetViewController setSenderName:@"Intensity"];

  // Push it onto the top of the navigation controller's stack
  [[self navigationController] pushViewController:targetViewController
                                         animated:YES];
}

- (IBAction)showPresets:(id)sender {
  PresetsViewController *presetsViewController =
      [[PresetsViewController alloc] init];

  // passes and sets the audioPlayer object in the targetViewController
  [presetsViewController setPlayer:_player];

  // Push it onto the top of the navigation controller's stack
  [[self navigationController] pushViewController:presetsViewController
                                         animated:YES];
}

- (IBAction)setOnOff:(UIButton *)sender {
  if ([[sender currentTitle] isEqualToString:@"OFF"]) {
    [_player setBypass:YES];
    [sender setTitle:@"ON" forState:0];
    //[sender setBackgroundColor:[UIColor greenColor]];
  } else if ([[sender currentTitle] isEqualToString:@"ON"]) {
    [_player setBypass:NO];
    [sender setTitle:@"OFF" forState:0];
    //[sender setBackgroundColor:[UIColor redColor]];
  }
}

- (IBAction)filterToggle:(id)sender {
  if ([[sender currentTitle] isEqualToString:@"OFF"]) {
    [_player setFilterState:true];
    [sender setTitle:@"ON" forState:0];
  } else if ([[sender currentTitle] isEqualToString:@"ON"]) {
    [_player setFilterState:false];
    [sender setTitle:@"OFF" forState:0];
  }
}

- (IBAction)showMusic:(id)sender {
  MPMediaPickerController *picker =
      [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
  picker.delegate = self;
  picker.showsCloudItems = NO;
  picker.allowsPickingMultipleItems = NO;
  picker.prompt =
      NSLocalizedString(@"Select song", "Prompt in media item picker");

  [self presentViewController:picker animated:YES completion:nil];
}

// Invoked when the user taps the Done button in the media item picker after
// having chosen
//		one or more media items to play.
- (void)mediaPicker:(MPMediaPickerController *)mediaPicker
    didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {

  // Dismiss the media item picker.
  [self dismissViewControllerAnimated:NO completion:nil];

  NSLog(@"media item coll: %lu",
        (unsigned long)[mediaItemCollection mediaTypes]);
  // Apply the chosen songs to the music player's queue.
  [self updatePlayerQueueWithMediaCollection:mediaItemCollection];
}

// Invoked when the user taps the Done button in the media item picker having
// chosen zero
//		media items to play
- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark player transport actions
- (IBAction)playAudio:(id)sender {
  // start playback
  [_player start];

  UIImage *btnImage = [UIImage imageNamed:@"playerButtonsPlayOn.png"];
  [_playButton setBackgroundImage:btnImage forState:0];

  btnImage = [UIImage imageNamed:@"playerButtonsStopOff.png"];
  [_playbackStop setImage:btnImage forState:0];

  btnImage = [UIImage imageNamed:@"playerButtonsPauseOff.png"];
  [_playbackPause setImage:btnImage forState:0];
}

- (IBAction)stopAudio:(id)sender {
//	//Is this the Free(Ads) or Pay version?
//	#if defined(TARGET_ADS)
//	if(_player.playbackElapsedSeconds > 120)
//		[self showAdView];
//		NSLog(@"Ads version");
//	#else
//		NSLog(@"Pay version");
//	#endif
	
  [_player stop];

  UIImage *btnImage = [UIImage imageNamed:@"playerButtonsPlayOff.png"];
  [_playButton setBackgroundImage:btnImage forState:0];

  btnImage = [UIImage imageNamed:@"playerButtonsStopOn.png"];
  [_playbackStop setImage:btnImage forState:0];

  btnImage = [UIImage imageNamed:@"playerButtonsPauseOff.png"];
  [_playbackPause setImage:btnImage forState:0];

	
	
}

- (IBAction)pauseAudio:(id)sender {
  [_player pause];
  UIImage *btnImage = [UIImage imageNamed:@"playerButtonsPauseOn.png"];
  [_playbackPause setImage:btnImage forState:0];
}

- (IBAction)setTarget:(UISlider *)sender {
  // NSLog(@"Target: %f",[sender value] );
  [_player setTarget:[sender value]];
}

- (IBAction)setWidth:(UISlider *)sender {
  [_player setTargetWidth:[sender value]];
}

- (IBAction)setIntensity:(UISlider *)sender {
  [_player setIntensity:[sender value]];
}

- (IBAction)setPhase:(UISlider *)sender {
  [_player setPhaseValue:[sender value]];
}

- (void)playbackCompleted:(NSNotification *)note {
  UIImage *btnImage = [UIImage imageNamed:@"playerButtonsPlayOff.png"];
  [_playButton setBackgroundImage:btnImage forState:0];

  btnImage = [UIImage imageNamed:@"playerButtonsStopOn.png"];
  [_playbackStop setImage:btnImage forState:0];

  btnImage = [UIImage imageNamed:@"playerButtonsPauseOff.png"];
  [_playbackPause setImage:btnImage forState:0];

}

- (void)activatePlayback:(NSNotification *)note {
  // when audio data is ready, update ui for playback
  [_fileLoadingBusy stopAnimating];
  [_playButton setEnabled:true];
  [_lblArtist setText:[_player artist]];
}
- (void)loadAudioData:(NSTimer *)timer {
  [_player initBufferProcess];
}

- (void)playerReset:(NSNotification *)note {
  [_fileLoadingBusy stopAnimating];
  [_lblArtist setText:@""];
  [_songLabelButton setTitle:_player.track forState:UIControlStateNormal];
}

- (void)updatePlayerQueueWithMediaCollection:
    (MPMediaItemCollection *)mediaItemCollection {

  // Configure the music player, but only if the user chose at least one song to
  // play
  if (mediaItemCollection) {

    [self setUserMediaItemCollection:mediaItemCollection];

    // stop player
    [self playbackCompleted:nil];

    MPMediaItem *mediaItem = [[_userMediaItemCollection items] objectAtIndex:0];

    NSNumber *isCloud =
        [mediaItem valueForProperty:MPMediaItemPropertyIsCloudItem];
    // NSLog (@"cloud item: %@",[mediaItem valueForProperty:
    // MPMediaItemPropertyIsCloudItem]);

    if ([isCloud isEqual:[NSNumber numberWithInt:1]]) {
      // media is from cloud, not supported. must be local media file
      // loading status
      [_lblArtist setText:@"Not Supported"];

      [utility
          showAlertWithTitle:@"Media file not supported"
                  andMessage:@"Please select a song from your local device "
                             @"library. Songs from the Cloud are not supported"
                       andVC:self];
    } else {

      // initialize audioPlayback
      [_player setUserMediaItemCollection:_userMediaItemCollection];

      [_player processMediaItems];

      // set song label button
      [_songLabelButton setTitle:[_player track] forState:UIControlStateNormal];

      // status messages
      [_fileLoadingBusy startAnimating];

      // loading status
      [_lblArtist setText:@"Loading"];

      [_playButton setEnabled:false];

      // this timer lets the picker window close before filling audio data
      _loadTimer =
          [NSTimer scheduledTimerWithTimeInterval:0.5
                                           target:self
                                         selector:@selector(loadAudioData:)
                                         userInfo:nil
                                          repeats:NO];
    }
  }
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
  // Releases the view if it doesn't have a superview.
  [super didReceiveMemoryWarning];

  // Release any cached data, images, etc that aren't in use.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
  return 4;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  const NSInteger TOP_LABEL_TAG = 1001;
  const NSInteger BOTTOM_LABEL_TAG = 1002;
  UILabel *topLabel;
  UILabel *bottomLabel;

  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell =
      [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (cell == nil) {
    // Create the cell.
    cell = [[UITableViewCell alloc] initWithFrame:CGRectZero];

    // [cell setIndentationWidth:20.0];

    UIImage *indicatorImage = [UIImage imageNamed:@"showSettings.png"];
    cell.accessoryView = [[UIImageView alloc] initWithImage:indicatorImage];

    const CGFloat LABEL_HEIGHT = 25;
    // UIImage *image = [UIImage imageNamed:@"vrMobileTarget.png"];

    // Create the label for the top row of text
    topLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          cell.indentationWidth,
                          0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT),
                          aTableView.bounds.size.width - cell.indentationWidth,
                          LABEL_HEIGHT)];
    [cell.contentView addSubview:topLabel];

    // Configure the properties for the text that are the same on every row
    topLabel.tag = TOP_LABEL_TAG;
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.textColor = [UIColor
        whiteColor]; //[UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
    topLabel.highlightedTextColor = [UIColor
        greenColor]; //[UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
    // topLabel.font = [UIFont systemFontOfSize: [UIFont labelFontSize]];
    topLabel.font = [UIFont fontWithName:@"Helvetica" size:21];

    // Create the label for the bottom row of text
    bottomLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          cell.indentationWidth + 3,
                          0.5 * (aTableView.rowHeight - 2 * LABEL_HEIGHT) +
                              LABEL_HEIGHT,
                          aTableView.bounds.size.width - cell.indentationWidth,
                          LABEL_HEIGHT)];
    [cell.contentView addSubview:bottomLabel];

    // Configure the properties for the text that are the same on every row
    bottomLabel.tag = BOTTOM_LABEL_TAG;
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.textColor = [UIColor whiteColor]; // [UIColor colorWithRed:0.25
                                                  // green:0.0 blue:0.0
                                                  // alpha:1.0];
    bottomLabel.highlightedTextColor = [UIColor
        whiteColor]; // [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
    bottomLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];

    // Create a background image view.
    cell.backgroundView = [[UIImageView alloc] init];
    cell.selectedBackgroundView = [[UIImageView alloc] init];
  } else {
    topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
    bottomLabel = (UILabel *)[cell viewWithTag:BOTTOM_LABEL_TAG];
  }

  topLabel.text =
      [NSString stringWithFormat:@"Cell at row %ld.", (long)[indexPath row]];

  NSInteger row = [indexPath row];
  cell.backgroundColor = [UIColor blackColor];

  // set image for row
  if (row == 0) {
    //[[cell imageView] setImage:[UIImage imageNamed:@"blunderbuss-50.png"]];
    topLabel.text = [NSString stringWithFormat:@"Target"];
    bottomLabel.text =
        [NSString stringWithFormat:@"%.0f Hz", [_player targetFrequency]];
  } else if (row == 1) {
    // [[cell imageView] setImage:[UIImage imageNamed:@"vrMobileWidth.png"]];
    topLabel.text = [NSString stringWithFormat:@"Width"];
    bottomLabel.text =
        [NSString stringWithFormat:@"%.0f Hz", [_player targetBandwidth]];
  } else if (row == 2) {
    //[[cell imageView] setImage:[UIImage imageNamed:@"vrMobileIntensity.png"]];
    topLabel.text = [NSString stringWithFormat:@"Intensity"];
    bottomLabel.text =
        [NSString stringWithFormat:@"%.1f", [_player reductionIntensity] * 10];
  } else {
    //  [[cell imageView] setImage:[UIImage imageNamed:@"vrMobilePresets.png"]];
    topLabel.text = [NSString stringWithFormat:@"Presets"];
    bottomLabel.text = [_player presetName];
  }

  return cell;
}

- (void)tableView:(UITableView *)aTableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // NSLog(@"row selected %d",[indexPath row]);

  switch ([indexPath row]) {
  case 0:
    [self showTarget:nil];
    break;
  case 1:
    [self showWidth:self];
    break;
  case 2:
    [self showIntensity:self];
    break;
  case 3:
    [self showPresets:self];
    break;

  default:
    break;
  }
}

#pragma mark AdMob delegates
/// Tells the delegate an ad request loaded an ad.
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
	NSLog(@"adViewDidReceiveAd");
}

/// Tells the delegate an ad request failed.
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
	NSLog(@"adView:didFailToReceiveAdWithError: %@", [error localizedDescription]);
}

/// Tells the delegate that a full-screen view will be presented in response
/// to the user clicking on an ad.
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
	NSLog(@"adViewWillPresentScreen");
}

/// Tells the delegate that the full-screen view will be dismissed.
- (void)adViewWillDismissScreen:(GADBannerView *)adView {
	NSLog(@"adViewWillDismissScreen");
}

/// Tells the delegate that the full-screen view has been dismissed.
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
	NSLog(@"adViewDidDismissScreen");
}

/// Tells the delegate that a user click will open another app (such as
/// the App Store), backgrounding the current app.
- (void)adViewWillLeaveApplication:(GADBannerView *)adView {
	NSLog(@"adViewWillLeaveApplication");
}

@end

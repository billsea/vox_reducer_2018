//
//  ViewController.m
//  vox_reducer
//
//  Created by Loud on 2/24/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	
	//Google ads example
	GADBannerView *adView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
	adView.rootViewController = self;
	adView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";
	[self.view addSubview:adView]; // Request an ad without any additional targeting information.
	[adView loadRequest:[GADRequest request]];
	
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end

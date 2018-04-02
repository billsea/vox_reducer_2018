//
//  FreqSpectrumView.m
//  FrequencySpectrum_Playback
//
//  Created by Loud on 3/19/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "FreqSpectrumView.h"
#import "FrequencySpectrumBarView.h"
#define sampleRate 44100
#define frequencyBuckets 256
#define kNumberOfDisplayFrequencies 18//64 is to 10kz//256 is max/full.

@implementation FreqSpectrumView

- (void)setFrequencyValues:(NSArray*)vals{
	_frequencyValues = vals;
	[self updateCustomBar];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
	[self setupCustomBarViews];
}

#pragma mark use custom segmented bar view
- (void)setupCustomBarViews {
	//Create bar view for each frequency value
	_customBarViews = [[NSMutableArray alloc] init];
	int i = 0;
	
	//Show only frequencies that have a value
	float barWidth = self.frame.size.width/kNumberOfDisplayFrequencies;
	_barBandwidth = sampleRate/frequencyBuckets;
	
	while (i < kNumberOfDisplayFrequencies) {
		FrequencySpectrumBarView* v = [[FrequencySpectrumBarView alloc] init];
		v.frame = CGRectMake(i * barWidth, 0, barWidth, self.frame.size.height);
		v.scaling = 7.0f;
		
		if(i==1 || i==4 || i==7 || i==12){
			//frequencies are calculated as
			//sample rate: 44100
			//buckets: 256
			// 44100/256 = 172 (each bar...barBandwidth)
			// 1000(<<that's hz)/172 = 5.89(round to 6)
			//1khz?
			if(_showFrequencyLabels) {
				float labelWidth = 50.0f;
				float labelHeight = 15.0f;
				float padding = 5.0f;
				UILabel* fLabel = [[UILabel alloc] initWithFrame:CGRectMake(barWidth*i, self.frame.size.height + padding, labelWidth, labelHeight)];
				fLabel.text = [NSString stringWithFormat:@"%d",i * _barBandwidth];
				fLabel.textColor = [UIColor whiteColor];
				[self addSubview:fLabel];
				
				UILabel* axisLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - labelWidth, self.frame.size.height + padding, labelWidth, labelHeight)];
				axisLabel.text = @"Hz";
				[axisLabel setTextAlignment:NSTextAlignmentRight];
				axisLabel.textColor = [UIColor whiteColor];
				[self addSubview: axisLabel];
			}
		}
		
		[_customBarViews addObject:v];
		[self addSubview:v];
		i++;
	}
}

- (void)updateCustomBar {
	float adjustedHighlightFreq = _selectedFrequency + 35;//just a tweak
	for(int i = 0;i < _customBarViews.count; i++){
		FrequencySpectrumBarView* barView = [_customBarViews objectAtIndex:i];
		if (_frequencyValues.count > i) {
			if(i<_customBarViews.count)
				barView.isHighlightedBand = (adjustedHighlightFreq > i * _barBandwidth && adjustedHighlightFreq < (i + 1) * _barBandwidth) ? YES : NO;//determine highlighted band from "target" setting
			barView.barFrequencyValue = [[_frequencyValues objectAtIndex:i] floatValue];
		}
	}
}

@end

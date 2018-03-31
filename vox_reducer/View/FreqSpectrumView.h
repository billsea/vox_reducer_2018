//
//  FreqSpectrumView.h
//  FrequencySpectrum_Playback
//
//  Created by Loud on 3/19/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreqSpectrumView : UIView{
	int _barBandwidth;
}
@property(nonatomic,weak) NSArray* frequencyValues;
@property(nonatomic)NSMutableArray* barViews;
@property(nonatomic)NSMutableArray* customBarViews;
@property(nonatomic)bool showFrequencyLabels;
@property(nonatomic)float selectedFrequency;
@end

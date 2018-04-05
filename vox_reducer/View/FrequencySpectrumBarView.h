//
//  FrequencySpectrumBarView.h
//  FrequencySpectrum_Playback
//
//  Created by Loud on 3/29/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FrequencySpectrumBarView : UIView
@property(nonatomic) float scaling;
@property(nonatomic) float barFrequencyValue;
@property(nonatomic) float segmentHeight;
@property(nonatomic) bool isHighlightedBand;
@end

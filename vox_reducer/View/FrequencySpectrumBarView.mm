//
//  FrequencySpectrumBarView.m
//  FrequencySpectrum_Playback
//
//  Created by Loud on 3/29/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "FrequencySpectrumBarView.h"

@implementation FrequencySpectrumBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)aRect
{
	if ((self = [super initWithFrame:aRect])) {
		[self commonInit];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
	if ((self = [super initWithCoder:coder])) {
		[self commonInit];
	}
	return self;
}

- (void) commonInit {
	//[self setClipsToBounds:YES];
	self.backgroundColor = [UIColor clearColor];
	[self setNeedsLayout];
}

- (void)setBarFrequencyValue:(float)value {
	_barFrequencyValue = value;
	[self updateSubviews];
}

- (void)createSegments{
	float currentY = self.frame.size.height - _segmentHeight;
	float segmentSpacing = 3.0f;
	float barSpacing = 3.0f;
	
	while(currentY > 0){
		UIView* seg = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, self.frame.size.width - barSpacing, _segmentHeight)];
		seg.backgroundColor = [UIColor clearColor];
		
		[self addSubview:seg];
		currentY = (currentY - _segmentHeight) - segmentSpacing;
	}
	
}

- (void)layoutSubviews {
	_segmentHeight = 0.45 * self.frame.size.width;
	[self createSegments];
}

- (void)updateSubviews {
	//NSLog(@"freq updated:%f",_barFrequencyValue);
	float freqLevel = self.frame.size.height * _barFrequencyValue;
	float warningLevel = 10.0f;
	
	for(UIView* subview in self.subviews){
		subview.backgroundColor = [UIColor clearColor];
		float adjustedLevel = freqLevel * _scaling;
		if(self.frame.size.height - subview.frame.origin.y < adjustedLevel) {
			subview.backgroundColor = _isHighlightedBand ? [UIColor redColor] : freqLevel < warningLevel ? [UIColor greenColor] : [UIColor yellowColor];
		}
	}
}

@end

//
//  rotaryKnob.m
//  vrMobile
//
//  Created by bill on 9/3/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "loudRotaryKnob.h"
#import <QuartzCore/QuartzCore.h>

/*
 For our purposes, it's more convenient if we put 0 degrees at the top, 
 negative degrees to the left (the minimum is -MAX_ANGLE), and positive
 to the right (the maximum is +MAX_ANGLE).
 */

#define MAX_ANGLE 135.0f
#define MIN_DISTANCE_SQUARED 16.0f

@implementation loudRotaryKnob


- (float)angleForValue:(float)theValue
{
	return ((theValue - _minimumValue)/(_maximumValue - _minimumValue) - 0.5f) * (MAX_ANGLE*2.0f);
}

- (float)valueForAngle:(float)theAngle
{
	return (theAngle/(MAX_ANGLE*2.0f) + 0.5f) * (_maximumValue - _minimumValue) + _minimumValue;
}

- (float)angleBetweenCenterAndPoint:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
    
	// Yes, the arguments to atan2() are in the wrong order. That's because our
	// coordinate system is turned upside down and rotated 90 degrees. :-)
	float theAngle = atan2(point.x - center.x, center.y - point.y) * 180.0f/M_PI;
    
	if (theAngle < -MAX_ANGLE)
		theAngle = -MAX_ANGLE;
	else if (theAngle > MAX_ANGLE)
		theAngle = MAX_ANGLE;
    
	return theAngle;
}

- (float)squaredDistanceToCenter:(CGPoint)point
{
	CGPoint center = CGPointMake(self.bounds.size.width/2.0f, self.bounds.size.height/2.0f);
	float dx = point.x - center.x;
	float dy = point.y - center.y;
	return dx*dx + dy*dy;
}

- (void)showNormalKnobImage
{
	_knobImageView.image = _knobImageNormal;
}

- (void)showHighlighedKnobImage
{
	if (_knobImageHighlighted != nil)
		_knobImageView.image = _knobImageHighlighted;
	else
		_knobImageView.image = _knobImageNormal;
}

- (void)showDisabledKnobImage
{
	if (_knobImageDisabled != nil)
		_knobImageView.image = _knobImageDisabled;
	else
		_knobImageView.image = _knobImageNormal;
}

- (void)valueDidChangeFrom:(float)oldValue to:(float)newValue animated:(BOOL)animated
{
	// (If you want to do custom drawing, then this is the place to do so.)
    
	float newAngle = [self angleForValue:newValue];
    
	if (animated)
	{
		// We cannot simply use UIView's animations because they will take the
		// shortest path, but we always want to go the long way around. So we
		// set up a keyframe animation with three keyframes: the old angle, the
		// midpoint between the old and new angles, and the new angle.
        
		float oldAngle = [self angleForValue:oldValue];
        
		CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
		animation.duration = 0.2f;
        
		animation.values = [NSArray arrayWithObjects:
                            [NSNumber numberWithFloat:oldAngle * M_PI/180.0f],
                            [NSNumber numberWithFloat:(newAngle + oldAngle)/2.0f * M_PI/180.0f], 
                            [NSNumber numberWithFloat:newAngle * M_PI/180.0f], nil]; 
        
		animation.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0.0f], 
                              [NSNumber numberWithFloat:0.5f], 
                              [NSNumber numberWithFloat:1.0f],
                              nil]; 
        
		animation.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut],
                                     nil];
        
		[_knobImageView.layer addAnimation:animation forKey:nil];
	}
    
	_knobImageView.transform = CGAffineTransformMakeRotation(newAngle * M_PI/180.0f);
}

- (void)setUp
{
	_minimumValue = 0.0f;
	_maximumValue = 1.0f;
	_value = _defaultValue = 0.5f;
	_angle = 0.0f;
	_continuous = YES;
	_resetsToDefault = YES;
    
	_backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[self addSubview:_backgroundImageView];
    
	_knobImageView = [[UIImageView alloc] initWithFrame:self.bounds];
	[self addSubview:_knobImageView];
    
	[self valueDidChangeFrom:_value to:_value animated:NO];
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setUp];
	}
	return self;
}

- (id)initWithCoder:(NSCoder*)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self setUp];
	}
	return self;
}

- (UIImage*)backgroundImage
{
	return _backgroundImageView.image;
}

- (void)setBackgroundImage:(UIImage*)image
{
	_backgroundImageView.image = image;
}

- (UIImage*)currentKnobImage
{
	return _knobImageView.image;
}

- (void)setKnobImage:(UIImage*)image forState:(UIControlState)theState
{
	if (theState == UIControlStateNormal)
	{
		if (image != _knobImageNormal)
		{
            _knobImageNormal = image;
            
			if (self.state == UIControlStateNormal)
			{
				_knobImageView.image = image;
				[_knobImageView sizeToFit];
			}
		}
	}
    
	if (theState & UIControlStateHighlighted)
	{
		if (image != _knobImageHighlighted)
		{
            _knobImageHighlighted = image;
            
			if (self.state & UIControlStateHighlighted)
				_knobImageView.image = image;
		}
	}
    
	if (theState & UIControlStateDisabled)
	{
		if (image != _knobImageDisabled)
		{
			_knobImageDisabled = image;
            
			if (self.state & UIControlStateDisabled)
				_knobImageView.image = image;
		}
	}
}

- (UIImage*)knobImageForState:(UIControlState)theState
{
	if (theState == UIControlStateNormal)
		return _knobImageNormal;
	else if (theState & UIControlStateHighlighted)
		return _knobImageHighlighted;
	else if (theState & UIControlStateDisabled)
		return _knobImageDisabled;
	else
		return nil;
}

- (CGPoint)knobImageCenter
{
	return _knobImageView.center;
}

- (void)setKnobImageCenter:(CGPoint)theCenter
{
	_knobImageView.center = theCenter;
}

- (void)setValue:(float)newValue
{
	[self setValue:newValue animated:NO];
}

- (void)setValue:(float)newValue animated:(BOOL)animated
{
	float oldValue = _value;
    
	if (newValue < _minimumValue)
		_value = _minimumValue;
	else if (newValue > _maximumValue)
		_value = _maximumValue;
	else
		_value = newValue;
    
	[self valueDidChangeFrom:(float)oldValue to:(float)_value animated:animated];
}

- (void)setEnabled:(BOOL)isEnabled
{
	[super setEnabled:isEnabled];
    
	if (!self.enabled)
		[self showDisabledKnobImage];
	else if (self.highlighted)
		[self showHighlighedKnobImage];
	else
		[self showNormalKnobImage];
}

- (BOOL)beginTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	CGPoint point = [touch locationInView:self];
    
	// If the touch is too close to the center, we can't calculate a decent
	// angle and the knob becomes too jumpy.
	if ([self squaredDistanceToCenter:point] < MIN_DISTANCE_SQUARED)
		return NO;
    
	// Calculate starting angle between touch and center of control.
	_angle = [self angleBetweenCenterAndPoint:point];
    
	self.highlighted = YES;
	[self showHighlighedKnobImage];
    
	return YES;
}

- (BOOL)handleTouch:(UITouch*)touch
{
	if (touch.tapCount > 1 && _resetsToDefault)
	{
		[self setValue:_defaultValue animated:YES];
		return NO;
	}
    
	CGPoint point = [touch locationInView:self];
    
	if ([self squaredDistanceToCenter:point] < MIN_DISTANCE_SQUARED)
		return NO;
    
	// Calculate how much the angle has changed since the last event.
	float newAngle = [self angleBetweenCenterAndPoint:point];
	float delta = newAngle - _angle;
	_angle = newAngle;
    
	// We don't want the knob to jump from minimum to maximum or vice versa
	// so disallow huge changes.
	if (fabsf(delta) > 45.0f)
		return NO;
    
	self.value += (_maximumValue - _minimumValue) * delta / (MAX_ANGLE*2.0f);
    
	// Note that the above is equivalent to:
	//self.value += [self valueForAngle:newAngle] - [self valueForAngle:angle];
    
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	if ([self handleTouch:touch] && _continuous)
		[self sendActionsForControlEvents:UIControlEventValueChanged];
    
	return YES;
}

- (void)endTrackingWithTouch:(UITouch*)touch withEvent:(UIEvent*)event
{
	self.highlighted = NO;
	[self showNormalKnobImage];
    
	[self handleTouch:touch];
	[self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent*)event
{
	self.highlighted = NO;
	[self showNormalKnobImage];
}

@end

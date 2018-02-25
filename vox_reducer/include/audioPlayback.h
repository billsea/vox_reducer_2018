//  audioPlayback.h
//  voxReducerMobile
//
//  Created by Bill Seaman on 9/11/09.
//  Copyright 2009 _LoudSoftware_. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>

#include "math.h"
#include <stdio.h>
#include <AVFoundation/AVFoundation.h>
#include "center_reducer.h"

@interface audioPlayback : NSObject <UIAlertViewDelegate> {
  UIAlertView *_alert;
}

@property(nonatomic, retain) MPMediaItemCollection *userMediaItemCollection;
@property(nonatomic, retain) NSString *artist;
@property(nonatomic, retain) NSString *track;
@property(nonatomic, retain) NSString *presetName;
@property(nonatomic) float targetFrequency;
@property(nonatomic) float targetBandwidth;
@property(nonatomic) float reductionIntensity;
@property(nonatomic, retain) NSTimer *stopTimer;
@property(nonatomic) int playbackElapsedSeconds;

- (OSStatus)start;
- (OSStatus)stop;
- (OSStatus)pause;
- (OSStatus)setIntensity:(float)value;
- (OSStatus)setPhaseValue:(float)value;
- (OSStatus)setAdjust:(float)value;
- (OSStatus)setTarget:(float)value;
- (OSStatus)setTargetWidth:(float)value;
- (NSData *)extractDataForAsset:(AVURLAsset *)songAsset
                     withFormat:(NSString *)fileFormat;
- (void)setBypass:(BOOL)value;
- (void)setFilterState:(BOOL)value;
- (bool)getFilterState;
- (void)cleanUp;
- (void)initializeAudio;
- (void)processMediaItems;
- (void)initBufferProcess;
- (void)updateUIstopped:(NSTimer *)timer;

@end

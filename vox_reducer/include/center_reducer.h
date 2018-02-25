//  center_reducer.h
//  common_dsp
//
//  Created by Loud on 6/11/17.
//  Copyright © 2017 loudsoftware. All rights reserved.
//

#ifndef center_reducer_h
#define center_reducer_h

#include <stdio.h>
#include "filt.h"
#include <memory>

#define kSampleRateScaling 1000;

class center_reducer {
public:
  center_reducer(float sample_rate);

  short process_audio(float *audioLeft, float *audioRight);
  void intensity(float level) { mIntensity = level; }
  float intensity() { return mIntensity; }
  void target(float fVal) { mTargetFrequency = fVal; }
  double target() { return mTargetFrequency; }
  void width(float fVal) { mBandwidth = fVal; }
  double width() { return mBandwidth; }
  void filter_enabled(bool val) { mFilterOn = val; }

private:
  std::shared_ptr<Filter> mNormFilter;
  std::shared_ptr<Filter> mProcFilter;
  double mTargetFrequency;
  double mBandwidth;
  //double mUpperFreq;
  //double mLowerFreq;
  float mSampleRate;
  double mSampleRateScaling = kSampleRateScaling;
  float mPhaseValue;
  int mMaxDelayFrames;
  int mWriteIndex;
  float mIntensity;
  bool mFilterOn;
  const float mMaxDelayTime = 5.0;
  int NormalizeIndex(int i);
  int16_t *mDelayBuffer;

  double filter_lower_frequency();
  double filter_upper_frequency();
};

#endif /* center_reducer_h */

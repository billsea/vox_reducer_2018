//
//  Preset.m
//  vrMobile
//
//  Created by bill on 9/6/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "Preset.h"

@implementation Preset

- (id)initWithCoder:(NSCoder *)decoder {
  self = [super init];

  if (self) {
    // For each instance variable that is archived, we decode it,
    // and pass it to our setters. (Where it is retained)
    [self setPresetName:[decoder decodeObjectForKey:@"presetName"]];
    [self setPresetTarget:[decoder decodeFloatForKey:@"presetTarget"]];
    [self setPresetWidth:[decoder decodeFloatForKey:@"presetWidth"]];
    [self setPresetIntensity:[decoder decodeFloatForKey:@"presetIntensity"]];
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
  // For each instance variable, archive it under its variable name
  // These objects will also be sent encodeWithCoder:
  [encoder encodeObject:_presetName forKey:@"presetName"];
  [encoder encodeFloat:_presetTarget forKey:@"presetTarget"];
  [encoder encodeFloat:_presetWidth forKey:@"presetWidth"];
  [encoder encodeFloat:_presetIntensity forKey:@"presetIntensity"];
}

@end

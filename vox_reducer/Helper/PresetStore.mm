//
//  PresetStore.m
//  vrMobile
//
//  Created by bill on 9/6/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import "PresetStore.h"
#import "Preset.h"

static PresetStore *defaultStore = nil;

@implementation PresetStore

+ (PresetStore *)defaultStore {
  if (!defaultStore) {
    // Create the singleton
    defaultStore = [[super allocWithZone:NULL] init];
  }
  return defaultStore;
}

- (id)init {
  // If we already have an instance of PossessionStore...
  if (defaultStore) {

    // Return the old one
    return defaultStore;
  }

  self = [super init];
  if (self) {
  }
  return self;
}

- (NSArray *)allPresets {
  [self fetchPresets];
  return allPresets;
}

- (void)createPresetWithName:(NSString *)name
                   andTarget:(float)target
                    andWidth:(float)width
                andIntensity:(float)intensity {
  Preset *p = [[Preset alloc] init];

  [p setPresetName:name];
  [p setPresetTarget:target];
  [p setPresetWidth:width];
  [p setPresetIntensity:intensity];

  [allPresets addObject:p];
}

- (void)removePreset:(Preset *)p {
  // NSLog(@"remove preset: %@",[p PresetName]);
  [allPresets removeObjectIdenticalTo:p];
}

- (NSString *)presetArchivePath {
  // return path to device data
  return pathInDocumentDirectory(@"Ver_3_Presets.data");
}

- (BOOL)saveChanges {
  // returns success or failure
  return [NSKeyedArchiver archiveRootObject:allPresets
                                     toFile:[self presetArchivePath]];
}

- (void)fetchPresets {
  if (!allPresets) {
    NSString *path = [self presetArchivePath];
    allPresets = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
  }
  if (!allPresets) {
    allPresets = [[NSMutableArray alloc] init];

    // load factory presets if first run
    [self createPresetWithName:@"Factory"
                     andTarget:1081
                      andWidth:1538
                  andIntensity:0.95];
  }
}

@end



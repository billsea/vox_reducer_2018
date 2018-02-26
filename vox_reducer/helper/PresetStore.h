//
//  PresetStore.h
//  vrMobile
//
//  Created by bill on 9/6/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

@class Preset;

@interface PresetStore : NSObject {

  NSMutableArray *allPresets;
}

+ (PresetStore *)defaultStore;

- (NSArray *)allPresets;
- (void)createPresetWithName:(NSString *)name
                   andTarget:(float)target
                    andWidth:(float)width
                andIntensity:(float)intensity;
- (void)removePreset:(Preset *)p;
- (NSString *)presetArchivePath;
- (BOOL)saveChanges;
- (void)fetchPresets;
@end

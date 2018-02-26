//
//  Preset.h
//  vrMobile
//
//  Created by bill on 9/6/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

@interface Preset : NSObject <NSCoding>
@property(nonatomic) NSString *presetName;
@property(nonatomic) float presetTarget;
@property(nonatomic) float presetWidth;
@property(nonatomic) float presetIntensity;

@end

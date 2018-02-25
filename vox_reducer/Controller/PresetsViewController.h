//
//  PresetsViewController.h
//  vrMobile
//
//  Created by bill on 9/6/11.
//  Copyright 2011 _Loudsoftware_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoViewController.h"
#import "audioPlayback.h"

@interface PresetsViewController : UIViewController <UIPickerViewDelegate> {
  int _factoryDefaultCount;
}
@property(nonatomic, retain) UIPickerView *presetSelect;
@property(nonatomic, retain) audioPlayback *player;
@property(nonatomic, retain) NSMutableArray *presetOptions;

- (IBAction)showInfo:(id)sender;
- (IBAction)loadPreset:(id)sender;
- (IBAction)removePreset:(id)sender;
- (IBAction)addPreset:(id)sender;
- (void)loadUserPresets;
@end

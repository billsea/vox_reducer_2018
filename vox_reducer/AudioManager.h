//
//  SharedManager.h
//  vox_reducer
//
//  Created by Loud on 4/3/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "audioPlayback.h"

@interface AudioManager : NSObject {
	audioPlayback * _player;
}

@property(nonatomic, retain) audioPlayback *player;

+ (id)sharedManager;

@end

//
//  SharedManager.m
//  vox_reducer
//
//  Created by Loud on 4/3/18.
//  Copyright © 2018 loudsoftware. All rights reserved.
//

#import "AudioManager.h"

@implementation AudioManager

#pragma mark Singleton Methods
+ (id)sharedManager {
	static AudioManager *sharedAudioManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedAudioManager = [[self alloc] init];
	});
	return sharedAudioManager;
}

- (id)init {
	if (self = [super init]) {
		// allocate the audio player
		_player = [[audioPlayback alloc] init];
		[_player initializeAudio];
	}
	return self;
}

- (void)dealloc {
	// Should never be called
}

@end

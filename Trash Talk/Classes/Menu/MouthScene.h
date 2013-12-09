//
//  MouthScene.h
//  Trash Talk
//
//  Created by Beau Young on 8/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>

@interface MouthScene : SKScene {
    AVAudioRecorder *recorder;
    double volumeLevel;
}

@property BOOL contentCreated;

@property (strong, nonatomic) SKSpriteNode *mouth;
@property (strong, nonatomic) NSString *textureAtlasName;

@end

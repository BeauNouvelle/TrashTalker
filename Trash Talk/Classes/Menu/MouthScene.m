//
//  MouthScene.m
//  Trash Talk
//
//  Created by Beau Young on 8/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "MouthScene.h"

@implementation MouthScene {
    SKTextureAtlas *textures;
    NSTimer *levelTimer;
    
    NSArray *animatedTextureArray;
}


- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        textures = [SKTextureAtlas atlasNamed:_textureAtlasName];
        
        animatedTextureArray = [NSArray arrayWithObjects:
                                [textures textureNamed:@"4"],
                                [textures textureNamed:@"6"],
                                [textures textureNamed:@"7"],
                                nil];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    self.mouth = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"1"]];
    self.mouth.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:_mouth];
    
    [self setupAudio];
}

- (void)setupAudio {
    // empty URL
    NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
    
    // define settings for AVAudioRecorder
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                      AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatAppleLossless],      AVFormatIDKey,
                              [NSNumber numberWithInt:1],                               AVNumberOfChannelsKey,
                              [NSNumber numberWithInt:AVAudioQualityMax],               AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    // init and apply settings
     recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    
    if (recorder) {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
    } else
        NSLog([error description]);
}

#pragma mark - Update Loop
- (void)update:(NSTimeInterval)currentTime {
    [recorder updateMeters];
    volumeLevel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
    _mouth.texture = [textures textureNamed:@"8"];
    
    if (volumeLevel >= 0.03 && volumeLevel < 0.05) {
        _mouth.texture = [textures textureNamed:@"1"];
    }
    if (volumeLevel >= 0.05 && volumeLevel < 0.08) {
        _mouth.texture = [textures textureNamed:@"2"];
    }
    if (volumeLevel >= 0.08 && volumeLevel < 0.10) {
        _mouth.texture = [textures textureNamed:@"3"];
    }
    if (volumeLevel >= 0.10 && volumeLevel < 0.13) {
        _mouth.texture = [textures textureNamed:@"5"];
    }
    if (volumeLevel >= 0.13) {
        SKAction *action = [SKAction animateWithTextures:animatedTextureArray timePerFrame:0.03];
        [_mouth runAction:action];
        if (volumeLevel > 0.15) {
            [_mouth runAction:[self showParticles]];
        }
    }
    
//    NSLog(@"Avergae input: %f Peak input: %f othe:%f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], volumeLevel);
}


- (SKAction *)showParticles {
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"cheese" ofType:@"sks"];
    SKEmitterNode *cheeseParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    cheeseParticle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:cheeseParticle];
    
    return nil;
}

@end

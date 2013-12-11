//
//  MouthScene.m
//  Trash Talk
//
//  Created by Beau Young on 8/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "MouthScene.h"
#import "MenuScene.h"
#import "AppDelegate.h"

@implementation MouthScene {
    SKTextureAtlas *textures;
    NSTimer *levelTimer;
    
    NSArray *animatedTextureArray;
    SKEmitterNode *spitParticle;
    NSString *particleTextureImageName;
}


- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        textures = [SKTextureAtlas atlasNamed:_textureAtlasName];
        particleTextureImageName = _textureAtlasName;
        
        [self doVolumeFade];
        
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
    
    // create particles
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"cheese" ofType:@"sks"];
    spitParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    spitParticle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    spitParticle.zPosition = 50;
    spitParticle.particleTexture = [SKTexture textureWithImage:[UIImage imageNamed:particleTextureImageName]];
    spitParticle.particleBirthRate = 0;
    [spitParticle resetSimulation];
    [self addChild:spitParticle];
    
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
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    
    if (recorder) {
        [recorder prepareToRecord];
        recorder.meteringEnabled = YES;
        [recorder record];
    } else
        NSLog(@"%@", [error description]);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    MenuScene *nextScene = [[MenuScene alloc] initWithSize:self.size];
    SKTransition *trans = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.4];
    if ([_textureAtlasName isEqualToString:@"TrashRat"]) {
        nextScene.screenPosition = 1;
    } else if ([_textureAtlasName isEqualToString:@"RottenApple"]) {
        nextScene.screenPosition = 2;
    } else if ([_textureAtlasName isEqualToString:@"BlowFly"]) {
        nextScene.screenPosition = 3;
    } else if ([_textureAtlasName isEqualToString:@"ScumGum"]) {
        nextScene.screenPosition = 4;
    } else if ([_textureAtlasName isEqualToString:@"SourSnail"]) {
        nextScene.screenPosition = 5;
    }
    
    [self.view presentScene:nextScene transition:trans];
    
}

#pragma mark - Update Loop
- (void)update:(NSTimeInterval)currentTime {
    [recorder updateMeters];
    volumeLevel = pow(10, (0.05 * [recorder averagePowerForChannel:0]));
    _mouth.texture = [textures textureNamed:@"8"];
    
    if (volumeLevel >= 0.03 && volumeLevel < 0.05) {
        _mouth.texture = [textures textureNamed:@"1"];
    }
    else if (volumeLevel >= 0.05 && volumeLevel < 0.08) {
        _mouth.texture = [textures textureNamed:@"2"];
    }
    else if (volumeLevel >= 0.08 && volumeLevel < 0.10) {
        _mouth.texture = [textures textureNamed:@"3"];
    }
    else if (volumeLevel >= 0.10 && volumeLevel < 0.13) {
        _mouth.texture = [textures textureNamed:@"5"];
    }
    else if (volumeLevel >= 0.13) {
        [spitParticle setParticleBirthRate:200];
        [spitParticle resetSimulation];

        SKAction *action = [SKAction animateWithTextures:animatedTextureArray timePerFrame:0.03];
        [_mouth runAction:action];
    }
}

- (void)doVolumeFade {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.redMusic.volume > 0.1) {
        appDelegate.redMusic.volume = appDelegate.redMusic.volume - 0.1;
        [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];
    } else {
        // Stop and get the sound ready for playing again
        [appDelegate.redMusic stop];
        appDelegate.redMusic.currentTime = 0;
        [appDelegate.redMusic prepareToPlay];
        appDelegate.redMusic.volume = 1.0;
    }
}

@end

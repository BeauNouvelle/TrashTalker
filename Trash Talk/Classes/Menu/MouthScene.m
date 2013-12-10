//
//  MouthScene.m
//  Trash Talk
//
//  Created by Beau Young on 8/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "MouthScene.h"
#import "MenuScene.h"

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
        
        // Create a swipe recognizer for the wanted direction
        [self addSwipeRecognizerForDirection:UISwipeGestureRecognizerDirectionUp];
        
        
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

#pragma mark - Gesture Recognizer
- (void)addSwipeRecognizerForDirection:(UISwipeGestureRecognizerDirection)direction {
    // Create a swipe recognizer for the wanted direction
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(isSwiped:)];
    swipeRecognizer.direction = direction;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)isSwiped:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
    MenuScene *menuScene = [[MenuScene alloc] initWithSize:self.size];
    SKTransition *cross = [SKTransition revealWithDirection:SKTransitionDirectionUp duration:0.55];
        
        // remove gesture recognizers
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            [self.view removeGestureRecognizer:recognizer];
        }
    
        // stop recording otherwise the feedback safety will kick in and only play the menu sounds through the earpiece.
        recorder.meteringEnabled = NO;
        [recorder stop];
        
    [self.view presentScene:menuScene transition:cross];
    }
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer {
    return YES;
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
        [spitParticle resetSimulation];
        _mouth.texture = [textures textureNamed:@"3"];
    }
    if (volumeLevel >= 0.10 && volumeLevel < 0.13) {
        [spitParticle resetSimulation];
        _mouth.texture = [textures textureNamed:@"5"];
    }
    if (volumeLevel >= 0.13) {
        [spitParticle resetSimulation];
        spitParticle.numParticlesToEmit = 10;
        [spitParticle setParticleBirthRate:50];
        SKAction *action = [SKAction animateWithTextures:animatedTextureArray timePerFrame:0.03];
        [_mouth runAction:action];
    }
//    NSLog(@"Avergae input: %f Peak input: %f othe:%f", [recorder averagePowerForChannel:0], [recorder peakPowerForChannel:0], volumeLevel);
}

@end

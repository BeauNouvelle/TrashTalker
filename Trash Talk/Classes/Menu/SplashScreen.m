//
//  SplashScreen.m
//  Trash Talk
//
//  Created by Sharp Agency on 25/11/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "SplashScreen.h"
#import "EnterScene.h"
#import "MenuScene.h"
#import "AppDelegate.h"

@interface SplashScreen ()

@property BOOL contentCreated;

@end

@implementation SplashScreen {
    SKTextureAtlas *textures;
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        
        // start playback of intro music
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.bgMusic play];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    textures = [SKTextureAtlas atlasNamed:@"SplashScreen"];
    
    [self addChild:[self backgroundImage]];
//    [self runAction:[SKAction playSoundFileNamed:@"bg.mp3" waitForCompletion:NO]];
    
    SKAction *wait = [SKAction waitForDuration:2];
    
    // Change to next scene after delay
    [self runAction: wait completion:^{
        SKScene *enterScene  = [[EnterScene alloc] initWithSize:self.size];
        SKTransition *fade = [SKTransition fadeWithDuration:0.5];
        [self.view presentScene:enterScene transition:fade];
    }];
}

// Create background sprite
- (SKSpriteNode *)backgroundImage {
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"background"]];
    image.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    return image;
}



@end

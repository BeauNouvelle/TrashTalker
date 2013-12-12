//
//  OtherAppsScene.m
//  Trash Talk
//
//  Created by Beau Young on 11/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "OtherAppsScene.h"
#import "MenuScene.h"

@implementation OtherAppsScene  {
    SKTextureAtlas *textures;
    NSArray *characterArray;
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        
        textures = [SKTextureAtlas atlasNamed:@"OtherApps"];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    // Create background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"bg"]];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    background.name = @"background";
    [self addChild:background];
    
    // Create stink lines
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"stink" ofType:@"sks"];
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.position = CGPointZero;
    myParticle.name = @"background";
    myParticle.particlePositionRange = CGVectorMake(1100, 300);
    [background addChild:myParticle];
    
    // Create icon buttons
    SKSpriteNode *ibookTwo = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"icon2"]];
    ibookTwo.scale = .7;
    ibookTwo.name = @"bookTwo";
    ibookTwo.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-40);
    ibookTwo.zPosition = 10;
    [self addChild:ibookTwo];
    
    SKSpriteNode *ibookOne = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"icon1"]];
    ibookOne.scale = .7;
    ibookOne.name = @"bookOne";
    ibookOne.position = CGPointMake(ibookTwo.position.x-(ibookOne.size.width+20), ibookTwo.position.y);
    ibookOne.zPosition = 10;
    [self addChild:ibookOne];
    
    SKSpriteNode *rescue = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"icon3"]];
    rescue.scale = .7;
    rescue.name = @"rescue";
    rescue.position = CGPointMake(ibookTwo.position.x+(rescue.size.width+20), ibookTwo.position.y);
    rescue.zPosition = 10;
    [self addChild:rescue];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKNode *touchedNode = (SKNode *)[self nodeAtPoint:positionInScene];
    
    if ([touchedNode.name isEqualToString:@"background"]) {
        
        NSLog(@"Sprite name %@", touchedNode.name);
        MenuScene *nextScene = [[MenuScene alloc] initWithSize:self.size];
        
        if (_screenPosition == 1) {
            nextScene.screenPosition = 1;
        } else if (_screenPosition == 2) {
            nextScene.screenPosition = 2;
        } else if (_screenPosition == 3) {
            nextScene.screenPosition = 3;
        } else if (_screenPosition == 4) {
            nextScene.screenPosition = 4;
        } else if (_screenPosition == 5) {
            nextScene.screenPosition = 5;
        }
        
        [self.view presentScene:nextScene];
    
    }
    if ([touchedNode.name isEqualToString:@"bookTwo"]) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/trash-pack-2/id645415594?mt=8";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];

        
    }
    if ([touchedNode.name isEqualToString:@"bookOne"]) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/trash-pack-1/id586118957?mt=8";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];

    }
    if ([touchedNode.name isEqualToString:@"rescue"]) {
        NSString *iTunesLink = @"https://itunes.apple.com/us/app/trash-pack-rescue-full/id680968339?mt=8";
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];

    }

}

@end

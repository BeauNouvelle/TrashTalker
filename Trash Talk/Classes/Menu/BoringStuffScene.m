//
//  BoringStuffScene.m
//  Trash Talk
//
//  Created by Beau Young on 11/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "BoringStuffScene.h"
#import "MenuScene.h"

@implementation BoringStuffScene  {
    SKTextureAtlas *textures;
    NSArray *characterArray;
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        
        textures = [SKTextureAtlas atlasNamed:@"BoringStuff"];
        

        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    // Create background image
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"bg"]];
    background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    [self addChild:background];
    
    // Create stink lines
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"stink" ofType:@"sks"];
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.position = CGPointZero;
    myParticle.particlePositionRange = CGVectorMake(1100, 300);
    [background addChild:myParticle];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
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



@end

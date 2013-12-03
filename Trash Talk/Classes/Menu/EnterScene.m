//
//  EnterScene.m
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "EnterScene.h"
#import "MenuScene.h"

@interface EnterScene ()

@property BOOL contentCreated;

@end

@implementation EnterScene {
    SKTextureAtlas *textures;
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}


- (void)createSceneContents {
    textures = [SKTextureAtlas atlasNamed:@"EnterScene"];
    
    [self addChild:[self backgroundImage]];
}

- (SKSpriteNode *)backgroundImage {
    SKSpriteNode *image = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"bg"]];
    image.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    
    return image;
}






@end

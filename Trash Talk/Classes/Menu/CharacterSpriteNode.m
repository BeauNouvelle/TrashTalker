//
//  CharacterSpriteNode.m
//  Trash Talk
//
//  Created by Beau Young on 4/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "CharacterSpriteNode.h"

@interface CharacterSpriteNode ()

@property (nonatomic, strong) NSString *textureName;

@end

@implementation CharacterSpriteNode {
    SKTextureAtlas *textures;
    SKSpriteNode *trashCan;
}

- (id)initWithTextureNamed:(NSString *)texture {
    if (self = [super init]) {
        textures = [SKTextureAtlas atlasNamed:@"MenuScene"];
        self.textureName = texture;
//        self.userInteractionEnabled = YES;
        
        [self setUp];
        
    }
    return self;
}

- (void)setUp {
    self.name = _textureName;
    
    trashCan = [self createTrashcan];
    _character = [self createCharacter];
    _character.position = CGPointMake(self.frame.size.width/2, 50);
    
    [self addChild:trashCan];
    [self addChild:_character];
}

- (SKSpriteNode *)createCharacter {
    SKSpriteNode *toon = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:_textureName]];
    toon.zPosition = 1;
    
    return toon;
}

- (SKSpriteNode *)createTrashcan {
    SKSpriteNode *bin = [[SKSpriteNode alloc] init];
    
    SKSpriteNode *trashcanBack = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"bin_back"]];
    trashcanBack.zPosition = 0;
    trashcanBack.position = CGPointMake(15, 0);
    
    SKSpriteNode *trashcanFront = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"bin_front"]];
    trashcanFront.zPosition = 2;
    trashcanFront.position = CGPointMake(15, 0);
    
    [bin addChild:trashcanBack];
    [bin addChild:trashcanFront];
    
    return bin;
}

- (SKAction *)animateWiggle {
    SKAction *rotateRight = [SKAction rotateToAngle:0.04 duration:.1 shortestUnitArc:YES];
    SKAction *rotateLeft = [SKAction rotateToAngle:6.26 duration:.1 shortestUnitArc:YES];
    SKAction *comeToRest = [SKAction rotateToAngle:0.0 duration:.1 shortestUnitArc:YES];
    
    SKAction *sequence = [SKAction sequence:@[rotateRight, rotateLeft, rotateRight, rotateLeft, comeToRest]];
    
    return sequence;
}

- (SKAction *)animationPopOut {
    SKAction *moveCharacterUp = [SKAction moveToY:80 duration:0.1];

    return moveCharacterUp;
}

- (SKAction *)animatePopIn {
    SKAction *moveCharacterDown = [SKAction moveToY:0 duration:0.1];

    return moveCharacterDown;
}



@end

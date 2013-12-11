//
//  CharacterSpriteNode.m
//  Trash Talk
//
//  Created by Beau Young on 4/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "CharacterSpriteNode.h"

@interface CharacterSpriteNode ()
@end

@implementation CharacterSpriteNode {
    SKTextureAtlas *textures;
}

- (id)initWithTextureNamed:(NSString *)texture {
    if (self = [super init]) {
        textures = [SKTextureAtlas atlasNamed:@"MenuScene"];
        self.textureName = texture;
        
        [self setUp];        
    }
    return self;
}

- (void)setUp {
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"fireFly" ofType:@"sks"];
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.position = CGPointMake(0, -40);
    
    // set up trashcan
    _trashCan = [self createTrashcan];
    
    // setup character
    _character = [self createCharacter];
    _character.position = CGPointMake(self.frame.size.width/2, 50);
    

    // setup name
    _nameSprite = [self createName];
    _nameSprite.scale = 0.8;
    _nameSprite.position = CGPointMake(self.size.width/2, 170);
    
    // add sprites to node
    [self addChild:_trashCan];
    [self addChild:_character];
    [self addChild:_nameSprite];
    [_character addChild:myParticle];
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

- (SKSpriteNode *)createName {
    SKSpriteNode *newName = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:[NSString stringWithFormat:@"%@_text", _textureName]]];
    newName.zPosition = 2;
    
    SKAction *scaleUp = [SKAction scaleTo:0.85 duration:0.9];
    SKAction *scaleDown = [SKAction scaleTo:0.75 duration:0.9];
    SKAction *sequence = [SKAction sequence:@[scaleUp, scaleDown]];
    
    [newName runAction:[SKAction repeatActionForever:sequence]];
                          
    return newName;
    
}

- (SKAction *)animateWiggle {
    SKAction *rotateRight = [SKAction rotateToAngle:0.04 duration:.1 shortestUnitArc:YES];
    SKAction *rotateLeft = [SKAction rotateToAngle:6.26 duration:.1 shortestUnitArc:YES];
    SKAction *comeToRest = [SKAction rotateToAngle:0.0 duration:.1 shortestUnitArc:YES];
    
    SKAction *sequence = [SKAction sequence:@[rotateRight, rotateLeft, rotateRight, rotateLeft, comeToRest]];
    
    return sequence;
}

- (SKAction *)animationPopOut {
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.position = CGPointMake(0, _trashCan.size.height+50);
    [_trashCan addChild:myParticle];
    
    [self runAction:[SKAction playSoundFileNamed:@"POP.caf" waitForCompletion:NO]];
    
    SKAction *moveCharacterUp = [SKAction moveToY:80 duration:0.1];

    return moveCharacterUp;
}

- (SKAction *)animatePopIn {
    SKAction *moveCharacterDown = [SKAction moveToY:0 duration:0.1];

    return moveCharacterDown;
}

- (SKAction *)moveUpOutOfScene {
    SKAction *moveOutOfScene = [SKAction moveToY:320+self.size.height duration:0.2];
    
    return moveOutOfScene;
}

@end

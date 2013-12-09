//
//  CharacterSpriteNode.h
//  Trash Talk
//
//  Created by Beau Young on 4/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CharacterSpriteNode : SKSpriteNode

@property (strong, nonatomic) SKSpriteNode *character;
@property (strong, nonatomic) SKSpriteNode *trashCan;

@property (nonatomic, strong) NSString *textureName;

@property BOOL wasTapped;

- (id)initWithTextureNamed:(NSString *)texture;

- (SKAction *)animateWiggle;
- (SKAction *)animationPopOut;
- (SKAction *)animatePopIn;

@end

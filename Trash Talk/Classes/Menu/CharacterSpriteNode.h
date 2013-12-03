//
//  CharacterSpriteNode.h
//  Trash Talk
//
//  Created by Beau Young on 4/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface CharacterSpriteNode : SKNode

@property (strong, nonatomic) SKSpriteNode *character;

- (id)initWithTextureNamed:(NSString *)texture;

- (SKAction *)animateWiggle;
- (SKAction *)animationPopOut;
- (SKAction *)animatePopIn;

@end

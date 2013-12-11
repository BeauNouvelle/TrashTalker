//
//  MenuScene.h
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ViewController.h"
#import "CharacterSpriteNode.h"
#import "MouthScene.h"
#import "AppDelegate.h"

@interface MenuScene : SKScene <UIGestureRecognizerDelegate>

@property int screenPosition;
@property BOOL isInBackground;
@property BOOL contentCreated;

// Backgrounds
@property (nonatomic, strong) SKSpriteNode *skyBackground;
@property (nonatomic, strong) SKSpriteNode *backtrashBackground;
@property (nonatomic, strong) SKSpriteNode *fenceBackground;
@property (nonatomic, strong) SKSpriteNode *trashBackground;
@property (nonatomic, strong) SKSpriteNode *groundBackground;

// Characters
@property (nonatomic, strong) CharacterSpriteNode *trashRat;
@property (nonatomic, strong) CharacterSpriteNode *rottenApple;
@property (nonatomic, strong) CharacterSpriteNode *blowFly;
@property (nonatomic, strong) CharacterSpriteNode *scumGum;
@property (nonatomic, strong) CharacterSpriteNode *sourSnail;

// UI
@property (nonatomic, strong) SKSpriteNode *leftArrow;
@property (nonatomic, strong) SKSpriteNode *rightArrow;

// Touch Zone, becuase for some stupid reason the sknode/skspritenode subclass of the characters wont detect touches.
@property (nonatomic, strong) SKSpriteNode *touchZone;

@end

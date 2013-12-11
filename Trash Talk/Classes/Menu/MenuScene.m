//
//  MenuScene.m
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

// The higher the number the slower it will be
#define SKY_SCROLL_SPEED 0.03
#define BACK_TRASH_SCROLL_SPEED 0.08
#define FENCE_SCROLL_SPEED 0.1
#define RUBBISH_SCROLL_SPEED .6
#define GROUND_SCROLL_SPEED 0.75

#define MOVE_BY_DISTANCE 960 // move all by a fraction of this distance
#define WITH_DURATION .5

#define CHARACTER_SPACING (MOVE_BY_DISTANCE * GROUND_SCROLL_SPEED)*2

#import "MenuScene.h"
#import "BoringStuffScene.h"
#import "OtherAppsScene.h"

@interface MenuScene ()

@end

@implementation MenuScene {
    SKTextureAtlas *textures;
    NSArray *characterArray;

    float skyX;
    float backTrashX;
    float fenceX;
    float trashX;
    float groundX;

}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        if (!_screenPosition) {
            _screenPosition = 1;
        }
        
        if (_screenPosition == 1) {
            skyX = 284.0;
            backTrashX = 556.0;
            fenceX = 578.2;
            trashX = 0.0;
            groundX = 0.0;
        }
        else if (_screenPosition == 2) {
            skyX = 255.2;
            backTrashX = 479.199;
            fenceX = 482.2;
            trashX = -575.999;
            groundX = -719.999;
        } else if (_screenPosition == 3) {
            skyX = 226.4;
            backTrashX = 402.399;
            fenceX = 386.199;
            trashX = -1152.0;
            groundX = -1439.999;
        } else if (_screenPosition == 4) {
            skyX = 197.599;
            backTrashX = 325.599;
            fenceX = 290.199;
            trashX = -1727.999;
            groundX = -2160.0;
        } else if (_screenPosition == 5) {
            skyX = 168.799;
            backTrashX = 248.799;
            fenceX = 194.199;
            trashX = -2303;
            groundX = -2880.0;
        }
        
        // start playing menu music
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        [appDelegate.redMusic prepareToPlay];
        [appDelegate.redMusic play];
        
        [self addSwipeRecognizerForDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addSwipeRecognizerForDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    textures = [SKTextureAtlas atlasNamed:@"MenuScene"];
    
    // Create Sky
    _skyBackground = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
    _skyBackground.position = CGPointMake(skyX, self.size.height-(_skyBackground.size.height/2));
    _skyBackground.zPosition = 0;
    [self addChild:_skyBackground];
    
    // Create Back Trash
    _backtrashBackground = [SKSpriteNode spriteNodeWithImageNamed:@"backtrash"];
    _backtrashBackground.position = CGPointMake(backTrashX, CGRectGetMidY(self.frame));
    _backtrashBackground.zPosition = 1;
    [self addChild:_backtrashBackground];
    
    // Create Fence
    _fenceBackground = [SKSpriteNode spriteNodeWithImageNamed:@"fenceline"];
    _fenceBackground.scale = .6;
    _fenceBackground.position = CGPointMake(fenceX, CGRectGetMidY(self.frame)+(_fenceBackground.size.height*.15));
    _fenceBackground.zPosition = 2;
    [self addChild:_fenceBackground];
    
    // Create Ground
    _groundBackground = [self createGroundSprite];
    _groundBackground.position = CGPointMake(groundX, _groundBackground.size.height/2);
    _groundBackground.zPosition = 3;
    [self addChild:_groundBackground];
    
    // Create Trash
    _trashBackground = [self createRubbishSprite];
    _trashBackground.position = CGPointMake(trashX, CGRectGetMidY(self.frame)/2);
    _trashBackground.zPosition = 4;
    [self addChild:_trashBackground];
    
    // Create stink lines and add as subview to trash background
    NSString *myParticlePath = [[NSBundle mainBundle] pathForResource:@"stink" ofType:@"sks"];
    SKEmitterNode *myParticle = [NSKeyedUnarchiver unarchiveObjectWithFile:myParticlePath];
    myParticle.position = CGPointZero;
    [_trashBackground addChild:myParticle];
    
    // Create Characters
    _trashRat = [[CharacterSpriteNode alloc] initWithTextureNamed:@"trashrat"];
    _trashRat.zPosition = 10;
    if (_screenPosition == 1) _trashRat.character.position = CGPointMake(_trashRat.character.position.x, 80);
    [self addChild:_trashRat];
    
    if (_screenPosition == 1) {
        _trashRat.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)*0.6);
    } else if (_screenPosition == 2) {
        _trashRat.position = CGPointMake(CGRectGetMidX(self.frame)-CHARACTER_SPACING, CGRectGetMidY(self.frame)*0.6);
    } else if (_screenPosition == 3) {
        _trashRat.position = CGPointMake(CGRectGetMidX(self.frame)-(CHARACTER_SPACING*2), CGRectGetMidY(self.frame)*0.6);
    } else if (_screenPosition == 4) {
        _trashRat.position = CGPointMake(CGRectGetMidX(self.frame)-(CHARACTER_SPACING*3), CGRectGetMidY(self.frame)*0.6);
    } else if (_screenPosition == 5) {
        _trashRat.position = CGPointMake(CGRectGetMidX(self.frame)-(CHARACTER_SPACING*4), CGRectGetMidY(self.frame)*0.6);
    }
    
    _rottenApple = [[CharacterSpriteNode alloc] initWithTextureNamed:@"rottenapple"];
    _rottenApple.position = CGPointMake(_trashRat.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _rottenApple.zPosition = 10;
    if (_screenPosition == 2) _rottenApple.character.position = CGPointMake(_rottenApple.character.position.x, 80);
    [self addChild:_rottenApple];
    
    _blowFly = [[CharacterSpriteNode alloc] initWithTextureNamed:@"blowfly"];
    _blowFly.position = CGPointMake(_rottenApple.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _blowFly.zPosition = 10;
    if (_screenPosition == 3) _blowFly.character.position = CGPointMake(_blowFly.character.position.x, 80);
    [self addChild:_blowFly];
    
    _scumGum = [[CharacterSpriteNode alloc] initWithTextureNamed:@"scumgum"];
    _scumGum.position = CGPointMake(_blowFly.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _scumGum.zPosition = 10;
    if (_screenPosition == 4) _scumGum.character.position = CGPointMake(_scumGum.character.position.x, 80);
    [self addChild:_scumGum];
    
    _sourSnail = [[CharacterSpriteNode alloc] initWithTextureNamed:@"soursnail"];
    _sourSnail.position = CGPointMake(_scumGum.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _sourSnail.zPosition = 10;
   if (_screenPosition == 5)  _sourSnail.character.position = CGPointMake(_sourSnail.character.position.x, 80);
    [self addChild:_sourSnail];
    
    // Create Touch Zone
    _touchZone = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:(CGSizeMake(120, 190))];
    _touchZone.position = CGPointMake(CGRectGetMidX(self.frame)+10, CGRectGetMidY(self.frame)*0.8);
    _touchZone.zPosition = 20;
    _touchZone.name = @"touchZone";
    [self addChild:_touchZone];
    
    // create arrows
    _leftArrow = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"leftArrow"]];
    _leftArrow.position = CGPointMake(_leftArrow.frame.size.width, CGRectGetMidY(self.frame));
    _leftArrow.zPosition = 30;
    [self addChild:_leftArrow];
    
    
    _rightArrow = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"rightArrow"]];
    _rightArrow.position = CGPointMake(self.size.width-_rightArrow.size.width, CGRectGetMidY(self.frame));
    _rightArrow.zPosition = 30;
    [self addChild:_rightArrow];
    
    
    // Menu Buttons
    SKSpriteNode *boringStuff = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"group"]];
    boringStuff.zPosition = 50;
    boringStuff.name = @"boringStuff";
    boringStuff.position = CGPointMake(self.frame.size.width-(boringStuff.size.width/2), boringStuff.size.height/2);
    [self addChild:boringStuff];
    
    SKSpriteNode *otherApps = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"look"]];
    otherApps.zPosition = 50;
    otherApps.name = @"otherApps";
    otherApps.position = CGPointMake(boringStuff.position.x-otherApps.size.width, otherApps.size.height/2);
    [self addChild:otherApps];
}

- (SKSpriteNode *)createGroundSprite {
    SKSpriteNode *ground = [[SKSpriteNode alloc] init];
    
    SKSpriteNode *groundOne = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    groundOne.anchorPoint = CGPointZero;
    groundOne.position = ground.position;
    [ground addChild:groundOne];
    
    SKSpriteNode *groundTwo = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    groundTwo.anchorPoint = CGPointZero;
    groundTwo.position = CGPointMake(groundOne.size.width, 0);
    [ground addChild:groundTwo];
    
    SKSpriteNode *groundThree = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    groundThree.anchorPoint = CGPointZero;
    groundThree.position = CGPointMake(groundTwo.size.width*2, 0);
    [ground addChild:groundThree];
    
    return ground;
}

- (SKSpriteNode *)createRubbishSprite {
    SKSpriteNode *rubbish = [[SKSpriteNode alloc] init];
    
    SKSpriteNode *rubbishOne = [SKSpriteNode spriteNodeWithImageNamed:@"rubbish"];
    rubbishOne.anchorPoint = CGPointZero;
    rubbishOne.position = rubbish.position;
    [rubbish addChild:rubbishOne];
    
    SKSpriteNode *rubbishTwo = [SKSpriteNode spriteNodeWithImageNamed:@"rubbish"];
    rubbishTwo.anchorPoint = CGPointZero;
    rubbishTwo.position = CGPointMake(rubbishOne.size.width, 0);
    [rubbish addChild:rubbishTwo];
    
    return rubbish;
}

#pragma mark - Swipe Gestures
- (void)addSwipeRecognizerForDirection:(UISwipeGestureRecognizerDirection)direction {
    // Create a swipe recognizer for the wanted direction
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(isSwiped:)];
    swipeRecognizer.direction = direction;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)isSwiped:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (_screenPosition < 5) {
            [self runAction:[SKAction playSoundFileNamed:@"binslide.caf" waitForCompletion:NO]];

            [self popCharactersIn];
            
            SKAction *moveSky = [SKAction moveByX:-MOVE_BY_DISTANCE*SKY_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveBacktrash = [SKAction moveByX:-MOVE_BY_DISTANCE*BACK_TRASH_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveFence = [SKAction moveByX:-MOVE_BY_DISTANCE*FENCE_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveRubbish = [SKAction moveByX:-MOVE_BY_DISTANCE*RUBBISH_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveGround = [SKAction moveByX:-MOVE_BY_DISTANCE*GROUND_SCROLL_SPEED y:0 duration:WITH_DURATION];
            
            SKAction *moveCharacter = [SKAction moveByX:-CHARACTER_SPACING y:0 duration:WITH_DURATION];
            
            [_skyBackground runAction:moveSky];
            [_backtrashBackground runAction:moveBacktrash];
            [_fenceBackground runAction:moveFence];
            [_trashBackground runAction:moveRubbish];
            [_groundBackground runAction:moveGround];
            
            [_trashRat runAction:moveCharacter completion:^{
                if (_screenPosition == 1) {
                    [_trashRat runAction:[_trashRat animateWiggle]];
                    [_trashRat.character runAction:[_trashRat animationPopOut]];
                }
            }];
            
            [_rottenApple runAction:moveCharacter completion:^{
                if (_screenPosition == 2) {
                    [_rottenApple runAction:[_rottenApple animateWiggle]];
                    [_rottenApple.character runAction:[_rottenApple animationPopOut]];
                }
            }];
            
            [_blowFly runAction:moveCharacter completion:^{
                if (_screenPosition == 3) {
                    [_blowFly runAction:[_blowFly animateWiggle]];
                    [_blowFly.character runAction:[_blowFly animationPopOut]];
                }
            }];
            
            [_scumGum runAction:moveCharacter completion:^{
                if (_screenPosition == 4) {
                    [_scumGum runAction:[_scumGum animateWiggle]];
                    [_scumGum.character runAction:[_scumGum animationPopOut]];
                }
            }];
            
            [_sourSnail runAction:moveCharacter completion:^{
                if (_screenPosition == 5) {
                    [_sourSnail runAction:[_sourSnail animateWiggle]];
                    [_sourSnail.character runAction:[_sourSnail animationPopOut]];
                }
            }];

            _screenPosition++;
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (_screenPosition > 1) {
            [self runAction:[SKAction playSoundFileNamed:@"binslide.caf" waitForCompletion:NO]];

            [self popCharactersIn];
            
            SKAction *moveSky = [SKAction moveByX:MOVE_BY_DISTANCE*SKY_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveBacktrash = [SKAction moveByX:MOVE_BY_DISTANCE*BACK_TRASH_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveFence = [SKAction moveByX:MOVE_BY_DISTANCE*FENCE_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveRubbish = [SKAction moveByX:MOVE_BY_DISTANCE*RUBBISH_SCROLL_SPEED y:0 duration:WITH_DURATION];
            SKAction *moveGround = [SKAction moveByX:MOVE_BY_DISTANCE*GROUND_SCROLL_SPEED y:0 duration:WITH_DURATION];
            
            SKAction *moveCharacter = [SKAction moveByX:CHARACTER_SPACING y:0 duration:WITH_DURATION];
            
            [_skyBackground runAction:moveSky];
            [_backtrashBackground runAction:moveBacktrash];
            [_fenceBackground runAction:moveFence];
            [_trashBackground runAction:moveRubbish];
            [_groundBackground runAction:moveGround];
            
            [_trashRat runAction:moveCharacter completion:^{
                if (_screenPosition == 1) {
                    [_trashRat runAction:[_trashRat animateWiggle]];
                    [_trashRat.character runAction:[_trashRat animationPopOut]];
                }
            }];
            
            [_rottenApple runAction:moveCharacter completion:^{
                if (_screenPosition == 2) {
                    [_rottenApple runAction:[_rottenApple animateWiggle]];
                    [_rottenApple.character runAction:[_rottenApple animationPopOut]];
                }
            }];
            
            [_blowFly runAction:moveCharacter completion:^{
                if (_screenPosition == 3) {
                    [_blowFly runAction:[_blowFly animateWiggle]];
                    [_blowFly.character runAction:[_blowFly animationPopOut]];
                }
            }];
            
            [_scumGum runAction:moveCharacter completion:^{
                if (_screenPosition == 4) {
                    [_scumGum runAction:[_scumGum animateWiggle]];
                    [_scumGum.character runAction:[_scumGum animationPopOut]];
                }
            }];
            [_sourSnail runAction:moveCharacter completion:^{
                if (_screenPosition == 5) {
                    [_sourSnail runAction:[_sourSnail animateWiggle]];
                    [_sourSnail.character runAction:[_sourSnail animationPopOut]];
                }
            }];
            
            _screenPosition--;
        }
    }

}

#pragma mark - Methods for character animations
- (void)popCharactersIn {
    if (_screenPosition == 1) [_trashRat.character runAction:[_trashRat animatePopIn]];
    if (_screenPosition == 2) [_rottenApple.character runAction:[_rottenApple animatePopIn]];
    if (_screenPosition == 3) [_blowFly.character runAction:[_blowFly animatePopIn]];
    if (_screenPosition == 4) [_scumGum.character runAction:[_scumGum animatePopIn]];
    if (_screenPosition == 5) [_sourSnail.character runAction:[_sourSnail animatePopIn]];
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Touch Event Listeners
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKNode *touchedNode = (SKNode *)[self nodeAtPoint:positionInScene];
    
    if ([touchedNode.name isEqualToString:@"touchZone"]) {
        
        NSLog(@"Sprite name %@", touchedNode.name);
        if (_screenPosition == 1) {
            [self runAction:[SKAction playSoundFileNamed:@"scream1.caf" waitForCompletion:NO]];
            [_trashRat.character runAction:[_trashRat moveUpOutOfScene] completion:^{
                [self goToNextSceneWithTextureAtlasNamed:@"TrashRat"];
            }];
        }
        if (_screenPosition == 2) {
            [self runAction:[SKAction playSoundFileNamed:@"scream2.caf" waitForCompletion:NO]];
            [_rottenApple.character runAction:[_rottenApple moveUpOutOfScene] completion:^{
                [self goToNextSceneWithTextureAtlasNamed:@"RottenApple"];
            }];
        }
        if (_screenPosition == 3) {
            [self runAction:[SKAction playSoundFileNamed:@"scream1.caf" waitForCompletion:NO]];
            [_blowFly.character runAction:[_blowFly moveUpOutOfScene] completion:^{
                [self goToNextSceneWithTextureAtlasNamed:@"BlowFly"];

            }];
        }
        if (_screenPosition == 4) {
            [self runAction:[SKAction playSoundFileNamed:@"scream2.caf" waitForCompletion:NO]];
            [_scumGum.character runAction:[_scumGum moveUpOutOfScene] completion:^{
                [self goToNextSceneWithTextureAtlasNamed:@"ScumGum"];
            }];
        }
        if (_screenPosition == 5) {
            [self runAction:[SKAction playSoundFileNamed:@"scream1.caf" waitForCompletion:NO]];
            [_sourSnail.character runAction:[_scumGum moveUpOutOfScene] completion:^{
                [self goToNextSceneWithTextureAtlasNamed:@"SourSnail"];
            }];
        }
    }
    if ([touchedNode.name isEqualToString:@"boringStuff"]) {
        BoringStuffScene *boringScene = [[BoringStuffScene alloc] initWithSize:self.size];
        [self.view presentScene:boringScene];
    }
    if ([touchedNode.name isEqualToString:@"otherApps"]) {
        OtherAppsScene *otherAppsScene = [[OtherAppsScene alloc] initWithSize:self.size];
        [self.view presentScene:otherAppsScene];
    }
}

#pragma mark - Navigation
- (void)goToNextSceneWithTextureAtlasNamed:(NSString *)textureAtlasName {
    MouthScene *mouthScene = [[MouthScene alloc] initWithSize:self.size];
    SKTransition *cross = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.6];
    
    mouthScene.textureAtlasName = textureAtlasName;
    
    // remove gesture recognizers. Otherwise they will persist in next screen and crash the app
    for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:recognizer];
    }
    
    [self.scene.view presentScene:mouthScene transition:cross];
}

#pragma mark - Call this method when returning to scene
- (void)update:(NSTimeInterval)currentTime {
    if (_screenPosition == 1) {
        _leftArrow.hidden = YES;
    } else _leftArrow.hidden = NO;
    
    if (_screenPosition == 5) {
        _rightArrow.hidden = YES;
    } else _rightArrow.hidden = NO;
    
}

@end

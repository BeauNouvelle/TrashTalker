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
#import "CharacterSpriteNode.h"
#import "MouthScene.h"

@interface MenuScene ()

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

// Touch Zone, becuase touch recognizers aren't working on the character SKNode subclass... which is fucking stupid. Worked on my last project.
@property (nonatomic, strong) SKSpriteNode *touchZone;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation MenuScene {
    SKTextureAtlas *textures;
    NSArray *characterArray;
    int screenPosition;
    
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        screenPosition = 1;
        
        [self addSwipeRecognizerForDirection:UISwipeGestureRecognizerDirectionLeft];
        [self addSwipeRecognizerForDirection:UISwipeGestureRecognizerDirectionRight];
        
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    textures = [SKTextureAtlas atlasNamed:@"MenuScene"];
    
    [self openingTransition];
    
    // Create Sky
    _skyBackground = [SKSpriteNode spriteNodeWithImageNamed:@"sky"];
    _skyBackground.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height-(_skyBackground.size.height/2));
    _skyBackground.zPosition = 0;
    [self addChild:_skyBackground];
    
    // Create Back Trash
    _backtrashBackground = [SKSpriteNode spriteNodeWithImageNamed:@"backtrash"];
    _trashBackground.scale = .2;
    _backtrashBackground.position = CGPointMake(_backtrashBackground.size.width, CGRectGetMidY(self.frame));
    _backtrashBackground.zPosition = 1;
    [self addChild:_backtrashBackground];
    
    // Create Fence
    _fenceBackground = [SKSpriteNode spriteNodeWithImageNamed:@"fenceline"];
    _fenceBackground.scale = .6;
    _fenceBackground.position = CGPointMake((_fenceBackground.size.width/2)-20, CGRectGetMidY(self.frame)+(_fenceBackground.size.height*.15));
    _fenceBackground.zPosition = 2;
    [self addChild:_fenceBackground];
    
    // Create Ground
    _groundBackground = [self createGroundSprite];
    _groundBackground.position = CGPointMake(_groundBackground.size.width/2, _groundBackground.size.height/2);
    _groundBackground.zPosition = 3;
    [self addChild:_groundBackground];
    
    // Create Trash
    _trashBackground = [self createRubbishSprite];
    _trashBackground.position = CGPointMake(_trashBackground.size.width/2, CGRectGetMidY(self.frame)/2);
    _trashBackground.zPosition = 4;
    [self addChild:_trashBackground];
    
    // Create Characters
    _trashRat = [[CharacterSpriteNode alloc] initWithTextureNamed:@"trashrat"];
    _trashRat.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)*0.6);
    _trashRat.zPosition = 10;
    [_trashRat.character runAction:[_trashRat animationPopOut]];
    [self addChild:_trashRat];
    
    _rottenApple = [[CharacterSpriteNode alloc] initWithTextureNamed:@"rottenapple"];
    _rottenApple.position = CGPointMake(_trashRat.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _rottenApple.zPosition = 10;
    [self addChild:_rottenApple];
    
    _blowFly = [[CharacterSpriteNode alloc] initWithTextureNamed:@"blowfly"];
    _blowFly.position = CGPointMake(_rottenApple.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _blowFly.zPosition = 10;
    [self addChild:_blowFly];
    
    _scumGum = [[CharacterSpriteNode alloc] initWithTextureNamed:@"scumgum"];
    _scumGum.position = CGPointMake(_blowFly.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _scumGum.zPosition = 10;
    [self addChild:_scumGum];
    
    _sourSnail = [[CharacterSpriteNode alloc] initWithTextureNamed:@"soursnail"];
    _sourSnail.position = CGPointMake(_scumGum.position.x+CHARACTER_SPACING, _trashRat.position.y);
    _sourSnail.zPosition = 10;
    [self addChild:_sourSnail];
    
    // Create Touch Zone
    _touchZone = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:(CGSizeMake(120, 190))];
    _touchZone.position = CGPointMake(CGRectGetMidX(self.frame)+10, CGRectGetMidY(self.frame)*0.8);
    _touchZone.zPosition = 20;
    _touchZone.name = @"touchZone";
    [self addChild:_touchZone];
    
    NSLog(@"%f", CHARACTER_SPACING);
    
}

- (void)openingTransition {
    // Set up sprites
    SKSpriteNode *bottomTrash = [SKSpriteNode spriteNodeWithImageNamed:@"bottom"];
    bottomTrash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    bottomTrash.zPosition = 30;
    [self addChild:bottomTrash];
    
    SKSpriteNode *middleTrash = [SKSpriteNode spriteNodeWithImageNamed:@"middle"];
    middleTrash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    middleTrash.zPosition = 29;
    [self addChild:middleTrash];
    
//    SKSpriteNode *topTrash = [SKSpriteNode spriteNodeWithImageNamed:@"top"];
//    topTrash.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
//    topTrash.zPosition = 28;
//    [self addChild:topTrash];
    
    SKAction *moveDown = [SKAction moveToY:-self.size.height duration:0.5];
    SKAction *remove = [SKAction removeFromParent];
    
    SKAction *sequence = [SKAction sequence:@[moveDown, remove]];
    
    
    [middleTrash runAction:sequence completion:^{
        [bottomTrash runAction:sequence];
    }];

    
//    
//    [topTrash runAction:sequence completion:^{
//        [middleTrash runAction:sequence completion:^{
//            [bottomTrash runAction:sequence];
//        }];
//    }];
    
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

- (void)addSwipeRecognizerForDirection:(UISwipeGestureRecognizerDirection)direction {
    // Create a swipe recognizer for the wanted direction
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(isSwiped:)];
    swipeRecognizer.direction = direction;
    [self.view addGestureRecognizer:swipeRecognizer];
}

#pragma mark - Swipe Gesture
- (void)isSwiped:(UISwipeGestureRecognizer *)recognizer {
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (screenPosition < 5) {
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
                [_trashRat runAction:[_trashRat animateWiggle]];
                [_trashRat.character runAction:[_trashRat animationPopOut]];
            }];
            [_rottenApple runAction:moveCharacter completion:^{
                [_rottenApple runAction:[_rottenApple animateWiggle]];
                [_rottenApple.character runAction:[_rottenApple animationPopOut]];
            }];
            [_blowFly runAction:moveCharacter completion:^{
                [_blowFly runAction:[_blowFly animateWiggle]];
                [_blowFly.character runAction:[_blowFly animationPopOut]];
            }];
            [_scumGum runAction:moveCharacter completion:^{
                [_scumGum runAction:[_scumGum animateWiggle]];
                [_scumGum.character runAction:[_scumGum animationPopOut]];
            }];
            [_sourSnail runAction:moveCharacter completion:^{
                [_sourSnail runAction:[_sourSnail animateWiggle]];
                [_sourSnail.character runAction:[_sourSnail animationPopOut]];
            }];
            

            screenPosition++;
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (screenPosition > 1) {
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
                [_trashRat runAction:[_trashRat animateWiggle]];
                [_trashRat.character runAction:[_trashRat animationPopOut]];
            }];
            [_rottenApple runAction:moveCharacter completion:^{
                [_rottenApple runAction:[_rottenApple animateWiggle]];
                [_rottenApple.character runAction:[_rottenApple animationPopOut]];
            }];
            [_blowFly runAction:moveCharacter completion:^{
                [_blowFly runAction:[_blowFly animateWiggle]];
                [_blowFly.character runAction:[_blowFly animationPopOut]];
            }];
            [_scumGum runAction:moveCharacter completion:^{
                [_scumGum runAction:[_scumGum animateWiggle]];
                [_scumGum.character runAction:[_scumGum animationPopOut]];
            }];
            [_sourSnail runAction:moveCharacter completion:^{
                [_sourSnail runAction:[_sourSnail animateWiggle]];
                [_sourSnail.character runAction:[_sourSnail animationPopOut]];
            }];
            
            screenPosition--;
        }
    }
    NSLog(@"ScreenPosition = %d", screenPosition);
}

#pragma mark - Methods for character animations
- (void)popCharactersIn {
    [_trashRat.character runAction:[_trashRat animatePopIn]];
    [_rottenApple.character runAction:[_rottenApple animatePopIn]];
    [_blowFly.character runAction:[_blowFly animatePopIn]];
    [_scumGum.character runAction:[_scumGum animatePopIn]];
    [_sourSnail.character runAction:[_sourSnail animatePopIn]];
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

#pragma mark - Touch Event Listeners
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    SKNode *touchedNode = (SKNode *)[self nodeAtPoint:positionInScene];
    
    if ([touchedNode.name isEqualToString:@"touchZone"]) {
        NSLog(@"Sprite name %@", touchedNode.name);
        if (screenPosition == 1) {
            [self runAction:[SKAction playSoundFileNamed:@"scream1.caf" waitForCompletion:NO]];
            [self goToNextSceneWithTextureAtlasNamed:@"TrashRat"];
        }
        if (screenPosition == 2) {
            [self goToNextSceneWithTextureAtlasNamed:@"RottenApple"];
        }
        if (screenPosition == 3) {
            [self goToNextSceneWithTextureAtlasNamed:@"BlowFly"];
        }
        if (screenPosition == 4) {
            [self goToNextSceneWithTextureAtlasNamed:@"ScumGum"];
        }
        if (screenPosition == 5) {
            [self goToNextSceneWithTextureAtlasNamed:@"SourSnail"];
        }
    }
}


#pragma mark - Update Method
- (void)update:(NSTimeInterval)currentTime {

}

#pragma mark - Navigation
- (void)goToNextSceneWithTextureAtlasNamed:(NSString *)textureAtlasName {
    MouthScene *mouthScene = [[MouthScene alloc] initWithSize:self.size];
    SKTransition *cross = [SKTransition crossFadeWithDuration:0.3];
    
    [self runAction:[SKAction playSoundFileNamed:@"scream1.caf" waitForCompletion:NO]];

    mouthScene.textureAtlasName = textureAtlasName;
    [self.view presentScene:mouthScene transition:cross];
}


@end

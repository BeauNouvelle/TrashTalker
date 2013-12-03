//
//  MenuScene.m
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

// A speed of 1 is a 1:1 ratio with the position of the touch input.
#define SKY_SCROLL_SPEED 0.03
#define BACK_TRASH_SCROLL_SPEED 0.08
#define FENCE_SCROLL_SPEED 0.1
#define RUBBISH_SCROLL_SPEED .5
#define GROUND_SCROLL_SPEED 0.75

#define MOVE_BY_DISTANCE 1136 // move all by a fraction of this distance
#define WITH_DURATION .5


#import "MenuScene.h"

@interface MenuScene ()

@property BOOL contentCreated;

@property (nonatomic, strong) SKSpriteNode *skyBackground;
@property (nonatomic, strong) SKSpriteNode *backtrashBackground;
@property (nonatomic, strong) SKSpriteNode *fenceBackground;
@property (nonatomic, strong) SKSpriteNode *trashBackground;
@property (nonatomic, strong) SKSpriteNode *groundBackground;

@property (nonatomic, strong) SKSpriteNode *garbageCanSprite;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;

@end

@implementation MenuScene {
    SKTextureAtlas *textures;
    int screenPosition;

}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        screenPosition = 1;
        
        [self addPanGestureRecognizer];
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
    _groundBackground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    _groundBackground.position = CGPointMake(_groundBackground.size.width/2, _groundBackground.size.height/2);
    _groundBackground.zPosition = 3;
    [self addChild:_groundBackground];
    
    // Create Trash
    _trashBackground = [SKSpriteNode spriteNodeWithImageNamed:@"rubbish"];
    _trashBackground.position = CGPointMake(_trashBackground.size.width/2, CGRectGetMidY(self.frame)-(_trashBackground.size.height/2));
    _trashBackground.name = @"trash";
    _trashBackground.zPosition = 4;
    [self addChild:_trashBackground];
    
    // Create Characters
    
}

- (void)addPanGestureRecognizer {
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragScene:)];
    pan.minimumNumberOfTouches = 1;
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
    
}

- (void)addSwipeRecognizerForDirection:(UISwipeGestureRecognizerDirection)direction {
    // Create a swipe recognizer for the wanted direction
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(isSwiped:)];
    swipeRecognizer.direction = direction;
    [self.view addGestureRecognizer:swipeRecognizer];
}

- (void)isSwiped:(UISwipeGestureRecognizer *)recognizer {

    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        if (screenPosition < 5) {
        
        SKAction *moveSky = [SKAction moveByX:-MOVE_BY_DISTANCE*SKY_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveBacktrash = [SKAction moveByX:-MOVE_BY_DISTANCE*BACK_TRASH_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveFence = [SKAction moveByX:-MOVE_BY_DISTANCE*FENCE_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveRubbish = [SKAction moveByX:-MOVE_BY_DISTANCE*RUBBISH_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveGround = [SKAction moveByX:-MOVE_BY_DISTANCE*GROUND_SCROLL_SPEED y:0 duration:WITH_DURATION];
        
        //        SKAction *moveCharacter = [SKAction moveByX:trans.x y:0 duration:0];
        
        [_skyBackground runAction:moveSky];
        [_backtrashBackground runAction:moveBacktrash];
        [_fenceBackground runAction:moveFence];
        [_trashBackground runAction:moveRubbish];
        [_groundBackground runAction:moveGround];
        NSLog(@"Swipe Left");
        
        screenPosition++;
        }
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        if (screenPosition > 1) {
        SKAction *moveSky = [SKAction moveByX:MOVE_BY_DISTANCE*SKY_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveBacktrash = [SKAction moveByX:MOVE_BY_DISTANCE*BACK_TRASH_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveFence = [SKAction moveByX:MOVE_BY_DISTANCE*FENCE_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveRubbish = [SKAction moveByX:MOVE_BY_DISTANCE*RUBBISH_SCROLL_SPEED y:0 duration:WITH_DURATION];
        SKAction *moveGround = [SKAction moveByX:MOVE_BY_DISTANCE*GROUND_SCROLL_SPEED y:0 duration:WITH_DURATION];
        
        //        SKAction *moveCharacter = [SKAction moveByX:trans.x y:0 duration:0];
        
        [_skyBackground runAction:moveSky];
        [_backtrashBackground runAction:moveBacktrash];
        [_fenceBackground runAction:moveFence];
        [_trashBackground runAction:moveRubbish];
        [_groundBackground runAction:moveGround];
        NSLog(@"Swipe Right");
        
        screenPosition--;
        }
    }
    NSLog(@"ScreenPosition = %d", screenPosition);
}

- (BOOL)gestureRecognizer:(UIPanGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UISwipeGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)dragScene:(UIPanGestureRecognizer *)gesture {
    
    CGPoint trans = [gesture translationInView:self.view];
    
    SKAction *moveSky = [SKAction moveByX:trans.x*SKY_SCROLL_SPEED y:0 duration:0];
    SKAction *moveBacktrash = [SKAction moveByX:trans.x*BACK_TRASH_SCROLL_SPEED y:0 duration:0];
    SKAction *moveFence = [SKAction moveByX:trans.x*FENCE_SCROLL_SPEED y:0 duration:0];
    SKAction *moveRubbish = [SKAction moveByX:trans.x*RUBBISH_SCROLL_SPEED y:0 duration:0];
    SKAction *moveGround = [SKAction moveByX:trans.x*GROUND_SCROLL_SPEED y:0 duration:0];
    
//    SKAction *moveCharacter = [SKAction moveByX:trans.x y:0 duration:0];

//    [_skyBackground runAction:moveSky];
//    [_backtrashBackground runAction:moveBacktrash];
//    [_fenceBackground runAction:moveFence];
//    [_trashBackground runAction:moveRubbish];
//    [_groundBackground runAction:moveGround];
    
    // Scroll conveyor sprite
//    if (_groundBackground.position.x < -_groundBackground.size.width){
//        _groundBackground.position = CGPointMake(_groundBackground.position.x + _groundBackground.size.width, _groundBackground.position.y);
//    }
    
    
    //    if (_trashBackground.position.x <= -_trashBackground.size.width*.25) {
    //        NSLog(@"Background is less than width");
    //        SKSpriteNode *newBackground = _trashBackground;
    //        newBackground.position = CGPointMake(_trashBackground.position.x + newBackground.size.width * 2, newBackground.position.y);
    //    }
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
    
}

//#pragma mark - Update Method
//- (void)update:(NSTimeInterval)currentTime {
//    // Scroll conveyor sprite
//    if (_trashBackground.position.x < -_trashBackground.size.width){
//        _trashBackground.position = CGPointMake(_trashBackground.position.x + _trashBackground.size.width, _trashBackground.position.y);
//    }
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    CGPoint positionInScene = [touch locationInNode:self];
//    [self selectNodeForTouch:positionInScene];
//}

@end

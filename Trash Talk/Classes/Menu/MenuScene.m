//
//  MenuScene.m
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

// A speed of 1 is a 1:1 ratio with the position of the touch input. 
#define SKY_SCROLL_SPEED 0.1
#define BACK_TRASH_SCROLL_SPEED 0.5
#define FENCE_SCROLL_SPEED 0.8
#define RUBBISH_SCROLL_SPEED 1
#define GROUND_SCROLL_SPEED 1.15


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
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        
        if (!self.pan) {
            
            self.pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragScene:)];
            self.pan.minimumNumberOfTouches = 1;
            self.pan.delegate = self;
            [self.view addGestureRecognizer:self.pan];
        }
        
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
    _backtrashBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    _backtrashBackground.zPosition = 1;
    _trashBackground.scale = .2;
    [self addChild:_backtrashBackground];

    // Create Fence
    _fenceBackground = [SKSpriteNode spriteNodeWithImageNamed:@"fenceline"];
    _fenceBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+(_fenceBackground.size.height*.15));
    _fenceBackground.zPosition = 2;
    _fenceBackground.scale = .6;
    [self addChild:_fenceBackground];
    
    // Create Ground
    _groundBackground = [SKSpriteNode spriteNodeWithImageNamed:@"ground"];
    _groundBackground.position = CGPointMake(CGRectGetMidX(self.frame), _groundBackground.size.height/2);
    _groundBackground.zPosition = 3;
    [self addChild:_groundBackground];
    
    // Create Trash
    _trashBackground = [SKSpriteNode spriteNodeWithImageNamed:@"rubbish"];
    _trashBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-(_trashBackground.size.height/2));
    _trashBackground.name = @"trash";
    _trashBackground.zPosition = 4;
    [self addChild:_trashBackground];
    
}

- (void)dragScene:(UIPanGestureRecognizer *)gesture {
    
    CGPoint trans = [gesture translationInView:self.view];
    
    SKAction *moveSky = [SKAction moveByX:trans.x*SKY_SCROLL_SPEED y:0 duration:0];
    SKAction *moveBacktrash = [SKAction moveByX:trans.x*BACK_TRASH_SCROLL_SPEED y:0 duration:0];
    SKAction *moveFence = [SKAction moveByX:trans.x*FENCE_SCROLL_SPEED y:0 duration:0];
    SKAction *moveRubbish = [SKAction moveByX:trans.x*RUBBISH_SCROLL_SPEED y:0 duration:0];
    SKAction *moveGround = [SKAction moveByX:trans.x*GROUND_SCROLL_SPEED y:0 duration:0];
    
    SKAction *moveCharacter = [SKAction moveByX:trans.x y:0 duration:0];
    
    [_skyBackground runAction:moveSky];
    [_backtrashBackground runAction:moveBacktrash];
    [_fenceBackground runAction:moveFence];
    [_trashBackground runAction:moveRubbish];
    [_groundBackground runAction:moveGround];
    
    
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

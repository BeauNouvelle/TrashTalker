//
//  EnterScene.m
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "EnterScene.h"
#import "MenuScene.h"

#define FOLLOW_PATH_SPEED 1.5
#define IS_WIDESCREEN ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


@interface EnterScene ()

@property BOOL contentCreated;

@end

@implementation EnterScene {
    SKTextureAtlas *textures;
    NSMutableArray *flyingRubbishArray;
    int directionNumber;      // varies between 0 and 1. Left and right, not respectively.
    int delayForFlyingTrash;  // When set to 1, flying trash starts.
    
    BOOL goingToNextScene;
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        textures = [SKTextureAtlas atlasNamed:@"EnterScene"];
        
        flyingRubbishArray = [[NSMutableArray alloc] init];
        directionNumber = 0;
        delayForFlyingTrash = 0;
        
        [self createSceneContents];
        self.contentCreated = YES;
        
    }
}


- (void)createSceneContents {
    
    self.backgroundColor = [SKColor whiteColor];
    self.scaleMode = SKSceneScaleModeAspectFill;
    
    // actions for animating clouds and fence
    SKAction *moveCloudsUp = [SKAction moveBy:CGVectorMake(0, 550) duration:2];
    SKAction *moveFenceUp = [SKAction moveBy:CGVectorMake(0, 180) duration:.7];
    SKAction *delay = [SKAction waitForDuration:1.3];
    SKAction *moveSequence = [SKAction sequence:@[delay, moveFenceUp]];
    
    // Scene sky background
    SKSpriteNode *sky = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"sky"]];
    sky.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame)));
    sky.zPosition = 0;
    [self addChild:sky];
    
    // clouds
    SKSpriteNode *clouds = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"clouds"]];
    clouds.position = CGPointMake(CGRectGetMidX(self.frame), 60);
    clouds.zPosition = 1;
    [self addChild:clouds];
    [clouds runAction:moveCloudsUp];
    
    // fence
    SKSpriteNode *fence = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"fence"]];
    fence.position = CGPointMake(CGRectGetMidX(self.frame), -150);
    fence.zPosition = 1;
    [self addChild:fence];
    [fence runAction:moveSequence completion:^{
        delayForFlyingTrash = 1;
    }];
    
    // game logo
    SKSpriteNode *logo = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"logo"]];
    logo.position = CGPointMake(CGRectGetMidX(self.frame), (CGRectGetMidY(self.frame)));
    logo.name = @"logoImage";
    logo.scale = 0.0;
    logo.zPosition = 3;  // Below are the actions to make it bounce in
    SKAction *delayAppearance = [SKAction waitForDuration:2.0];
    SKAction *scale = [SKAction scaleTo:1.075 duration:0.13];
    SKAction *scaleBack = [SKAction scaleTo:0.9 duration:0.13];
    SKAction *scaleBounce = [SKAction scaleTo:1.00 duration:0.08];
    SKAction *logoSequence = [SKAction sequence:@[delayAppearance, scale, scaleBack, scaleBounce]];
    [self addChild:logo];
    [logo runAction:logoSequence];
    
    // flying toilet paper
    SKSpriteNode *toiletPaperRight = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"toiletRollRight1"]];
    toiletPaperRight.position = CGPointMake(-200, -200);
    toiletPaperRight.zPosition = 2;
    toiletPaperRight.name = @"paper";
    [flyingRubbishArray addObject:toiletPaperRight];
    [self addChild:toiletPaperRight];
    
    // Drumstick
    SKSpriteNode *drumstick = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"drumstick"]];
    drumstick.position = CGPointMake(-200, -200);
    drumstick.zPosition = 2;
    [flyingRubbishArray addObject:drumstick];
    [self addChild:drumstick];
    
    // Apple
    SKSpriteNode *apple = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"apple"]];
    apple.position = CGPointMake(-200, -200);
    apple.zPosition = 2;
    [flyingRubbishArray addObject:apple];
    [self addChild:apple];
    
}

#pragma mark - Touch Recognisers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if logo is touched change to new scene
    if ([node.name isEqualToString:@"logoImage"]) {
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
        [node runAction:moveSequence completion:^{
            goingToNextScene = YES;
            [self moveUpTrash];
        }];
    }
}

- (void)moveUpTrash {
    // prepare actions for sprites
    //    SKAction *shakeRight = [SKAction moveToX:CGRectGetMidX(self.frame)+5 duration:0.1];
    //    SKAction *shakeLeft = [SKAction moveToX:CGRectGetMidX(self.frame)-5 duration:0.1];
    //    SKAction *shakeSequence = [SKAction sequence:@[shakeRight, shakeLeft]];
    
    SKAction *moveBottomUp = [SKAction moveToY:CGRectGetMidY(self.frame) duration:0.5];
    SKAction *wait = [SKAction waitForDuration:.2];
    
    // prepare sprites
    SKSpriteNode *bottomTrash = [SKSpriteNode spriteNodeWithImageNamed:@"bottom"];
    bottomTrash.position = CGPointMake(CGRectGetMidX(self.frame), -bottomTrash.size.height);
    bottomTrash.zPosition = 30;
    [self addChild:bottomTrash];
    
    SKSpriteNode *middleTrash = [SKSpriteNode spriteNodeWithImageNamed:@"middle"];
    middleTrash.position = CGPointMake(CGRectGetMidX(self.frame), -middleTrash.size.height);
    middleTrash.zPosition = 29;
    [self addChild:middleTrash];
    
    SKSpriteNode *topTrash = [SKSpriteNode spriteNodeWithImageNamed:@"top"];
    topTrash.position = CGPointMake(CGRectGetMidX(self.frame), -topTrash.size.height);
    topTrash.zPosition = 28;
    [self addChild:topTrash];
    
    [bottomTrash runAction:moveBottomUp completion:^ {
        [middleTrash runAction:moveBottomUp completion:^{
            [self runAction:wait completion:^{
                SKScene *menuScreen = [[MenuScene alloc] initWithSize:self.size];
                SKTransition *cross = [SKTransition crossFadeWithDuration:0.3];
                [self.view presentScene:menuScreen transition:cross];
            }];
        }];
    }];
}

// gets run every frame, used for throwing trash
- (void)update:(NSTimeInterval)currentTime {
    
    if(!goingToNextScene){
        if (delayForFlyingTrash == 1) {
            // each screen update, a number from 0 - 100 is generated
            // if its 0 a piece of flying trash is thrown across the screen
            for (SKSpriteNode *rubbish in flyingRubbishArray) {
                if (arc4random() % 100 == 0) {
                    if (!rubbish.hasActions) {
                        if ([rubbish.name isEqualToString:@"paper"]) { // If its toilet paper, animate trailing paper
                            NSArray *paperTextures = @[[textures textureNamed:@"toiletRollRight1"], [textures textureNamed:@"toiletRollRight2"]];
                            SKAction *animate = [SKAction animateWithTextures:paperTextures timePerFrame:0.05];
                            [rubbish runAction:[SKAction group:@[[SKAction repeatAction:animate count:30], [self getMoveSequence]]]];
                            
                        } else { // otherwise just throw it across screen
                            [rubbish runAction:[self getMoveSequence]];
                        }
                    }
                }
            }
        }
    }
}

// Method for flying trash movement
- (SKAction *)getMoveSequence {
    
    CGPathRef path = [self getBezierPathRight];
    SKAction *followPath = [SKAction followPath:path asOffset:NO orientToPath:YES duration:FOLLOW_PATH_SPEED];
    
    return followPath;
}

// Checks device type, and then uses Bezier path for flying trash to follow.
// Depending on the device, the arc will be different
- (CGPathRef)getBezierPathRight {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (IS_WIDESCREEN){
            if (directionNumber == 0) {    // This helps to randomize the direction
                directionNumber = 1;
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(726.5, 159.5)];
                [bezierPath addCurveToPoint: CGPointMake(-248.5, 159.5) controlPoint1: CGPointMake(726.5, 159.5) controlPoint2: CGPointMake(286.73, 460.7)];
                
                return bezierPath.CGPath;
            } else {
                directionNumber = 0;
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(-248.5, 159.5)];
                [bezierPath addCurveToPoint: CGPointMake(726.5, 159.5) controlPoint1: CGPointMake(-248.5, 159.5) controlPoint2: CGPointMake(191.27, 460.7)];
                
                return bezierPath.CGPath;
            }
            
        }
        else {
            if (directionNumber == 0) {
                directionNumber = 1;
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(726.5, 159.5)];
                [bezierPath addCurveToPoint: CGPointMake(-248.5, 159.5) controlPoint1: CGPointMake(726.5, 159.5) controlPoint2: CGPointMake(286.73, 460.7)];
                
                return bezierPath.CGPath;
            } else {
                directionNumber = 0;
                //// Bezier Drawing
                UIBezierPath* bezierPath = [UIBezierPath bezierPath];
                [bezierPath moveToPoint: CGPointMake(-248.5, 159.5)];
                [bezierPath addCurveToPoint: CGPointMake(726.5, 159.5) controlPoint1: CGPointMake(-248.5, 159.5) controlPoint2: CGPointMake(191.27, 460.7)];
                
                return bezierPath.CGPath;
            }
            
        }
    }
    return 0;
}




@end

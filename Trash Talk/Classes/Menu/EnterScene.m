//
//  EnterScene.m
//  Trash Talk
//
//  Created by Beau Young on 3/12/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "EnterScene.h"
#import "MenuScene.h"
#import "AppDelegate.h"

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
    
    SKSpriteNode *bottomTrash;
    SKSpriteNode *middleTrash;
    SKSpriteNode *otherTitle;
    SKSpriteNode *splat;
    SKSpriteNode *pressHere;
    SKSpriteNode *logo;
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
    logo = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"logo"]];
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
    
    // Other title
    otherTitle = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"title"]];
    otherTitle.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    otherTitle.zPosition = 50;
    otherTitle.scale = 0.0;
    
    // Splat
    splat = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"splat"]];
    splat.scale = 0.8;
    splat.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    splat.zPosition = 31;
    
    // Press here
    pressHere = [SKSpriteNode spriteNodeWithTexture:[textures textureNamed:@"presshere"]];
    pressHere.position = CGPointZero;
    pressHere.zPosition = 35;
    pressHere.name = @"logoImage";
    SKAction *scaleUp = [SKAction scaleTo:1.05 duration:.9];
    SKAction *scaleDown = [SKAction scaleTo:0.95 duration:.9];
    SKAction *sequenceScale = [SKAction sequence:@[scaleUp, scaleDown]];
    [pressHere runAction:[SKAction repeatActionForever:sequenceScale]];
    [logo addChild:pressHere];
    
    // prepare transition sprites
    bottomTrash = [SKSpriteNode spriteNodeWithImageNamed:@"bottom"];
    bottomTrash.position = CGPointMake(CGRectGetMidX(self.frame), -bottomTrash.size.height);
    bottomTrash.zPosition = 30;
    
    middleTrash = [SKSpriteNode spriteNodeWithImageNamed:@"middle"];
    middleTrash.position = CGPointMake(CGRectGetMidX(self.frame), -middleTrash.size.height);
    middleTrash.zPosition = 29;
}

#pragma mark - Touch Recognisers
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    // if logo is touched change to new scene
    if ([node.name isEqualToString:@"logoImage"]) {
        SKAction *wait = [SKAction waitForDuration:0.4];
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
        
        [self runAction:[SKAction playSoundFileNamed:@"splat.caf" waitForCompletion:NO]];

        [self addChild:splat];
        
        [logo runAction:moveSequence completion:^{
            [splat runAction:wait completion:^{
                [splat runAction:moveSequence];
                [self moveUpTrash];
            }];
        }];
    }
}

- (void)moveUpTrash {
    // prepare sprites
    [self addChild:bottomTrash];
    [self addChild:middleTrash];
    
    // create actions
    SKAction *moveBottomUp = [SKAction moveToY:CGRectGetMidY(self.frame) duration:0.7];
    SKAction *wait = [SKAction waitForDuration:0.3];
    
    [bottomTrash runAction:moveBottomUp completion:^ {
        
        SKAction *scale = [SKAction scaleTo:1.075 duration:0.13];
        SKAction *scaleBack = [SKAction scaleTo:0.9 duration:0.13];
        SKAction *scaleBounce = [SKAction scaleTo:1.00 duration:0.08];
        SKAction *logoSequence = [SKAction sequence:@[scale, scaleBack, scaleBounce]];
        [self addChild:otherTitle];
        [otherTitle runAction:logoSequence];
        
        [middleTrash runAction:moveBottomUp completion:^{
            SKSpriteNode *initialBackground = [SKSpriteNode spriteNodeWithImageNamed:@"initialBG"];
            initialBackground.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
            initialBackground.zPosition = 28;
            [self addChild:initialBackground];
            
            [middleTrash runAction:wait completion:^{
                [self moveDownTrash];
            }];
        }];
    }];
}

- (void)moveDownTrash {
    // create actions
    SKAction *moveDown = [SKAction moveToY:-self.size.height duration:0.7];
    SKAction *remove = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[moveDown, remove]];
    
    [middleTrash runAction:sequence completion:^{
        SKAction *fadeAway = [SKAction fadeOutWithDuration:0.25];
        SKAction *remove = [SKAction removeFromParent];
        
        SKAction *moveSequence = [SKAction sequence:@[fadeAway, remove]];
        [otherTitle runAction:moveSequence];
        
        [bottomTrash runAction:sequence completion:^{
            
            MenuScene *menuScreen = [[MenuScene alloc] initWithSize:self.size];
            menuScreen.screenPosition = 1;
            SKTransition *cross = [SKTransition crossFadeWithDuration:0.3];
            
            // fade our and stop playback of intro music
            [self doVolumeFade];
            [self.view presentScene:menuScreen transition:cross];
        }];
    }];
}

// gets run every frame, used for throwing trash
- (void)update:(NSTimeInterval)currentTime {
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

- (void)doVolumeFade {
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.bgMusic.volume > 0.1) {
        appDelegate.bgMusic.volume = appDelegate.bgMusic.volume - 0.1;
        [self performSelector:@selector(doVolumeFade) withObject:nil afterDelay:0.1];
    } else {
        // Stop and get the sound ready for playing again
        [appDelegate.bgMusic stop];
        appDelegate.bgMusic.currentTime = 0;
        [appDelegate.bgMusic prepareToPlay];
        appDelegate.bgMusic.volume = 1.0;
    }
}

@end

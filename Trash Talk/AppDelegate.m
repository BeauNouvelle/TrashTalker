//
//  AppDelegate.m
//  Trash Talk
//
//  Created by Sharp Agency on 25/11/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // start background sound
    NSString *bgSoundFilePath = [[NSBundle mainBundle] pathForResource:@"bg" ofType:@"mp3"];
    NSURL *bgFileURL = [[NSURL alloc] initFileURLWithPath:bgSoundFilePath];
    
    NSString *redSoundFilePath = [[NSBundle mainBundle] pathForResource:@"red" ofType:@"caf"];
    NSURL *redFileURL = [[NSURL alloc] initFileURLWithPath:redSoundFilePath];
    
    
    _bgMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:bgFileURL error:nil];
    _bgMusic.numberOfLoops = -1; // inifinite loop
    
    _redMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:redFileURL error:nil];
    _redMusic.numberOfLoops = -1;
    
    // Override point for customization after application launch.
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // prevent audio crash
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // prevent audio crash
    [[AVAudioSession sharedInstance] setActive:NO error:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // resume audio
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

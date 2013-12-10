//
//  AppDelegate.h
//  Trash Talk
//
//  Created by Sharp Agency on 25/11/2013.
//  Copyright (c) 2013 Sharp Agency. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, retain) AVAudioPlayer *bgMusic;
@property (nonatomic, retain) AVAudioPlayer *redMusic;

@property (strong, nonatomic) UIWindow *window;

@end

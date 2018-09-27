//
//  STIAppDelegate.m
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 08/10/2018.
//  Copyright (c) 2018 Sven Titgemeyer. All rights reserved.
//

#import "STIAppDelegate.h"
#import "STIBottomSheet_Example-Swift.h"
#import <STIBottomSheet/STIBottomSheet.h>

@implementation STIAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    STIMapViewController *mapVC = [[STIMapViewController alloc] init];
    STIBottomSheetViewController *sheetVC = [[STIBottomSheetViewController alloc] initWithRootViewController:mapVC];
    DemoSheetViewController *demoSheet = [[DemoSheetViewController alloc] init];
    [sheetVC addBottomSheet:demoSheet closable:NO];
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    window.rootViewController = sheetVC;
    window.backgroundColor = [UIColor whiteColor];
    [window makeKeyAndVisible];
    self.window = window;
    
    return YES;
    return YES;
}

@end


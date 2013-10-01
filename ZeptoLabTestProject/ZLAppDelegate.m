//
//  ZLAppDelegate.m
//  ZeptoLabTestProject
//
//  Copyright (c) 2013 Igor Smirnov. All rights reserved.
//

#import "ZLAppDelegate.h"
#import "ZLViewController.h"

@interface ZLAppDelegate ()

@end

@implementation ZLAppDelegate

- (BOOL) application: (UIApplication *) application didFinishLaunchingWithOptions: (NSDictionary *) launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ZLViewController alloc] initWithNibName: ZLRootNIBName bundle:nil];
    self.window.rootViewController = self.viewController;
    [[UIApplication sharedApplication] setStatusBarHidden: true withAnimation: UIStatusBarAnimationFade];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void) applicationWillResignActive: (UIApplication *) application {
    [((ZLViewController *) self.viewController) pauseGame];
}

- (void) applicationDidEnterBackground: (UIApplication *) application {
}

- (void) applicationWillEnterForeground: (UIApplication *) application {
    //[((ZLViewController *) self.viewController) resumeGame];
}

@end

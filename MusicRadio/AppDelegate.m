//
//  AppDelegate.m
//  MusicRadio
//
//  Created by 叶衍宏 on 16/1/16.
//  Copyright © 2016年 prot. All rights reserved.
//

#import "AppDelegate.h"
#import "PlayViewController.h"
#import "RadioListCollectionViewController.h"
#import "MFSideMenu.h"
#import "LoveManage.h"
#import "Reachability.h"
#import "NetworkChange.h"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIWindow *window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [window makeKeyAndVisible];
    self.window = window;
    
    
    //radio List
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = [UIScreen mainScreen].bounds.size;
    RadioListCollectionViewController *radioCC = [[RadioListCollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
    //play View
    PlayViewController *playVC = [[PlayViewController alloc]init];
    
    MFSideMenuContainerViewController *sideMenu = [MFSideMenuContainerViewController containerWithCenterViewController:playVC leftMenuViewController:radioCC rightMenuViewController:nil];
    sideMenu.leftMenuWidth = [[UIScreen mainScreen] bounds].size.width * 0.75;
    
    
    //添加网络监控
    [[NSNotificationCenter defaultCenter] addObserver:[NetworkChange share] selector:@selector(reachChange:) name:kReachabilityChangedNotification object:NO];
    
    [[[NetworkChange share] reachability] startNotifier];
    
    self.window.rootViewController = sideMenu;
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    BOOL result = [[LoveManage share] saveLoveList];
    NSLog(@"save isSuccess:%@",result == YES ? @"success" : @"fail");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

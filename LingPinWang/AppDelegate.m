//
//  AppDelegate.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "AppDelegate.h"

#import "FirstViewController.h"

#import "SecondViewController.h"

#import "LiPinViewController.h"
#import "QinDaoViewController.h"
#import "ShangJiaViewController.h"
#import "SheZhiViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize m_lipinViewController,m_qiandaoViewController,m_shangjiaViewController,m_shezhiViewController,m_loginViewController;


- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [m_lipinViewController release];
    [m_qiandaoViewController release];
    [m_shezhiViewController release];
    [m_shangjiaViewController release];
    [m_loginViewController release];
    
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
//    UIViewController *viewController1 = [[[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil] autorelease];
//    UIViewController *viewController2 = [[[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil] autorelease];
    
    m_lipinViewController = [[LiPinViewController alloc] init];
    m_qiandaoViewController = [[QinDaoViewController alloc] init];
    m_shangjiaViewController = [[ShangJiaViewController alloc] init];
    m_shezhiViewController = [[SheZhiViewController alloc] init];
    m_loginViewController = [[LoginViewController alloc] init];

    UINavigationController* rootNav1 = [[UINavigationController alloc] initWithRootViewController:m_lipinViewController];
    UINavigationController* rootNav2 = [[UINavigationController alloc] initWithRootViewController:m_qiandaoViewController];
    UINavigationController* rootNav3 = [[UINavigationController alloc] initWithRootViewController:m_shangjiaViewController];
    UINavigationController* rootNav4 = [[UINavigationController alloc] initWithRootViewController:m_shezhiViewController];
    
    
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[rootNav1,rootNav2,rootNav3,rootNav4]/*@[m_lipinViewController, m_qiandaoViewController,m_shangjiaViewController,m_shezhiViewController]*/;
    [rootNav1 release];
    [rootNav2 release];
    [rootNav3 release];
    [rootNav4 release];
    
    self.window.rootViewController = m_loginViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

-(void) entryTabControllerView;
{
    m_loginViewController.modalTransitionStyle = UIModalTransitionStylePartialCurl; //水平翻转
    [m_loginViewController presentViewController:self.tabBarController animated:YES completion:nil];
}
-(void) entryLoginControllerView
{
    
}


@end

//
//  AppDelegate.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "AppDelegate.h"

#import "ZhwxBaseNavCotroller.h"


#import "LiPinViewController.h"
#import "QinDaoViewController.h"
#import "ShangJiaViewController.h"
#import "SheZhiViewController.h"
#import "LoginViewController.h"

#import <QuartzCore/CoreAnimation.h>

#import "DataManager.h"
#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"
#import "RequestLogin.h"

@implementation AppDelegate

@synthesize m_lipinViewController,m_qiandaoViewController,m_shangjiaViewController,m_shezhiViewController,m_loginViewController;
@synthesize m_zhwxLoginBase;

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

    
    m_lipinViewController = [[LiPinViewController alloc] initWithNibName:SwitchWith(@"LiPinViewController5",@"LiPinViewController") bundle:nil];
    m_qiandaoViewController = [[QinDaoViewController alloc] initWithNibName:SwitchWith(@"QinDaoViewController5",@"QinDaoViewController") bundle:nil];
    m_shangjiaViewController = [[ShangJiaViewController alloc] initWithNibName:SwitchWith(@"ShangJiaViewController5",@"ShangJiaViewController") bundle:nil];
    m_shezhiViewController = [[SheZhiViewController alloc] initWithNibName:SwitchWith(@"SheZhiViewController5",@"SheZhiViewController") bundle:nil];
    m_loginViewController = [[LoginViewController alloc] initWithNibName:SwitchWith(@"LoginViewController5",@"LoginViewController") bundle:nil];

    
    ZhwxBaseNavCotroller* rootNav1 = [[ZhwxBaseNavCotroller alloc] initWithRootViewController:m_qiandaoViewController];
    ZhwxBaseNavCotroller* rootNav2 = [[ZhwxBaseNavCotroller alloc] initWithRootViewController:m_lipinViewController];
    ZhwxBaseNavCotroller* rootNav3 = [[ZhwxBaseNavCotroller alloc] initWithRootViewController:m_shangjiaViewController];
    ZhwxBaseNavCotroller* rootNav4 = [[ZhwxBaseNavCotroller alloc] initWithRootViewController:m_shezhiViewController];
    
    m_zhwxLoginBase = [[ZhwxBaseNavCotroller alloc] initWithRootViewController:m_loginViewController];
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = @[rootNav1,rootNav2,rootNav3,rootNav4]/*@[m_lipinViewController, m_qiandaoViewController,m_shangjiaViewController,m_shezhiViewController]*/;
    [rootNav1 release];
    [rootNav2 release];
    [rootNav3 release];
    [rootNav4 release];
    

    self.window.rootViewController = m_zhwxLoginBase;
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
    
    [self requestLogin];
    
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

-(void) entryTabControllerView
{
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:kCATransitionFromLeft];
    [self.window.layer addAnimation:transtion forKey:@"transtionKey"];
    self.window.rootViewController = self.tabBarController;
    [self.tabBarController setSelectedIndex:0];
    [self.m_qiandaoViewController setQiandaoButtonState];
    
    [[NSNotificationQueue defaultQueue] enqueueNotification:[NSNotification notificationWithName:@"REFRESH_TABLE_VEIW_DATA" object:nil userInfo:nil] postingStyle:NSPostASAP];
    
}
-(void) entryLoginControllerView
{
    
    [m_qiandaoViewController.navigationController popToRootViewControllerAnimated:NO];
    [m_lipinViewController.navigationController popToRootViewControllerAnimated:NO];
    [m_shangjiaViewController.navigationController popToRootViewControllerAnimated:NO];

    
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:kCATransitionFromLeft];
    [self.window.layer addAnimation:transtion forKey:@"transtionKey"];

    self.window.rootViewController = m_zhwxLoginBase;
    

}


-(void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex == 0) {
        [self.m_qiandaoViewController setQiandaoButtonState];
    }
}


#pragma mark- 请求问题

//升级请求
-(void) requestLogin
{
    
    NSString* name = [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME_DEAULT_KEY];
    NSString* pswd= [[NSUserDefaults standardUserDefaults] valueForKey:USER_PSWD_DEAULT_KEY];
    
    RequestLogin* loginObj = [[RequestLogin alloc] init];
    loginObj.m_loginType = @"iphone";
    loginObj.m_phone = name;
    loginObj.m_password = [Utilities md5:pswd];
    
    NSString* str = [MyXMLParser EncodeToStr:loginObj Type:REQUEST_FOR_LOGIN];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstLogin:)];
    [http threadFunStart];
    
    [http release];
    [loginObj release];
}

-(void) receiveDataByRequstLogin:(NSData*) data
{

    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        [DataManager shareInstance].m_loginResult = (ResultLogin*)[MyXMLParser DecodeToObj:str];
        [str release];
        
        ResultLogin* result = [DataManager shareInstance].m_loginResult;
        
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"back_login_success_notify" object:nil];
        });
        
        //登录成功
        if (0 == [result.m_result compare:@"8"]) {
            
            dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"back_login_success_notify" object:nil];
            });
            
            
             
             
        }else if (0 == [result.m_result compare:@"0"]){
            //[Utilities ShowAlert:@"登录失败，账号不存在！"];
        }else if (0 == [result.m_result compare:@"1"]){
           // [Utilities ShowAlert:@"登录失败，密码不正确！"];
        }
        
        
        
    }else{
        //NSLog(@"receiveDataByRequstCode 接收到 数据 异常");
        
        //[Utilities ShowAlert:@"登录失败，网络异常！"];
        
    }
    
    
    
}


@end

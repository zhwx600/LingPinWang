//
//  AppDelegate.h
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiPinViewController;
@class QinDaoViewController;
@class ShangJiaViewController;
@class SheZhiViewController;
@class LoginViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;


@property (nonatomic,retain) LiPinViewController* m_lipinViewController;
@property (nonatomic,retain) QinDaoViewController* m_qiandaoViewController;
@property (nonatomic,retain) ShangJiaViewController* m_shangjiaViewController;
@property (nonatomic,retain) SheZhiViewController* m_shezhiViewController;
@property (nonatomic,retain) LoginViewController* m_loginViewController;

-(void) entryTabControllerView;
-(void) entryLoginControllerView;


@end

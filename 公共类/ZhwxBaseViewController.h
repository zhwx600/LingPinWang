//
//  ZhwxBaseViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-11.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZhwxBaseViewController : UIViewController


-(void) addMyNavBar;
-(void) setNavTitle:(NSString*) title;
-(void) closeBtnAction:(id) sender;

-(void) addRightButton:(SEL) sel Title:(NSString*) title;


//alertview 进度条
-(void) showLoadMessageView;
-(void) dissLoadMessageView;

//显示信息提示框
-(void) showBaseMessOnMain:(CGRect)frame MesStr:(NSString*) mes Delay:(int) delays;

@end

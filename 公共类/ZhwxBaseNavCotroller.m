//
//  ZhwxBaseNavCotroller.m
//  LingPinWang
//
//  Created by zhwx on 13-4-11.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseNavCotroller.h"
#import "UINavigationBar+Image.h"

@interface ZhwxBaseNavCotroller ()

@end

@implementation ZhwxBaseNavCotroller

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // 设置导航栏背景颜色
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)])
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"]];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IOS6.0 旋转
- (BOOL)shouldAutorotate
{
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
//    //排除 播放界面
//    if([[self topViewController] isKindOfClass:[PlayVideoViewController class]])
//        return UIInterfaceOrientationMaskAll;
//    else
        return UIInterfaceOrientationMaskPortrait;
}


@end

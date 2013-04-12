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
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi.png"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi.png"]];
    }

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

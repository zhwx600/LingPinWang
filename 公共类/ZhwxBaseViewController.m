//
//  ZhwxBaseViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-11.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"
#import <QuartzCore/CALayer.h>
#import "UINavigationBar+Image.h"
#import "Utilities.h"

#import "ZhwxDefine.h"

@interface ZhwxBaseViewController ()

@property (nonatomic,retain)UINavigationBar* m_zhwxNavBar;
@property (nonatomic,retain)UIAlertView* m_baseAlertView;

@end

@implementation ZhwxBaseViewController
@synthesize m_zhwxNavBar;
@synthesize m_baseAlertView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        UIImageView* tem = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"全局视图背景"]] autorelease];
        [tem setFrame:autoRetina5Frame(DEV_FULLSCREEN_Vertical_FOR_5_FRAME, DEV_FULLSCREEN_Vertical_FOR_4_FRAME)];

        [self.view insertSubview:tem atIndex:0];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [m_zhwxNavBar release];
    [m_baseAlertView release];
    [super dealloc];
}

-(void) setNavTitle:(NSString*) title
{
    m_zhwxNavBar.topItem.title = title;
}
-(void) addMyNavBar
{
    m_zhwxNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [m_zhwxNavBar setBarStyle:UIBarStyleBlackTranslucent];
    UINavigationItem* navitem = [[UINavigationItem alloc] initWithTitle:nil];
    
    UIBarButtonItem* leftButton = /*[Utilities createNavItemByTarget:self Sel:@selector(closeBtnAction:) Imgage:[UIImage imageNamed:@"item_back.png"] Title:@"返回" Pos:0];*/
    [Utilities createNavItemByTarget:self Sel:@selector(closeBtnAction:) Imgage:[UIImage imageNamed:@"item_back.png"]];

    navitem.leftBarButtonItem = leftButton;
    
    [m_zhwxNavBar pushNavigationItem:navitem animated:YES];
    [navitem release];
    
    if ([m_zhwxNavBar respondsToSelector:@selector( setBackgroundImage:forBarMetrics:)])
    {
        [m_zhwxNavBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        [m_zhwxNavBar setBackgroundImage:[UIImage imageNamed:@"bgCartNavi"]];
    }

    [self.view addSubview:m_zhwxNavBar];

}

-(void) closeBtnAction:(id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addRightButton:(SEL) sel Title:(NSString*) title
{
    UIBarButtonItem* rightButton = [Utilities createNavItemByTarget:self Sel:sel Imgage:[UIImage imageNamed:@"item_right.png"] Title:title Pos:2];
    m_zhwxNavBar.topItem.rightBarButtonItem = rightButton;
}


#pragma mark UIAlertView 进度条
-(void) showLoadMessageView
{
    self.m_baseAlertView = [Utilities createProgressionAlertWithMessage:@"正在请求数据..." withActivity:YES];
}


-(void) dissLoadMessageView
{
    [self.m_baseAlertView dismissWithClickedButtonIndex:0 animated:YES];
}


#pragma mark 提示框(自动隐藏)

-(void) hideBaseMessage:(UIView*) view
{
    [view setHidden:YES];
}

-(void) showBaseMessage:(id) argarr
//-(void) showBaseMessage:(NSString*) str Delay:(int) sec
{
    // NSArray* argArr = [NSArray arrayWithObjects:(id)frame,mes,(id)delays, nil];
    
    CGRect temframe = CGRectMake([(NSNumber*)[argarr objectAtIndex:0] floatValue],
                                 [(NSNumber*)[argarr objectAtIndex:1] floatValue],
                                 [(NSNumber*)[argarr objectAtIndex:2] floatValue],
                                 [(NSNumber*)[argarr objectAtIndex:3] floatValue]);
    
    NSString* str = (NSString*)[argarr objectAtIndex:4];
    int delays = [(NSNumber*)[argarr objectAtIndex:5] intValue];
    
    
    UIView* tem_loadView = [[UIView alloc] initWithFrame:temframe];
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 7, temframe.size.width, 21)];
    //  NSString* mess = [[NSString alloc] initWithFormat:@"当前已经是最新版本(%@)",m_latestVersion];
    label.text = @"";
    //    [mess release];
    label.tag = 1;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:13.0f];
    label.text = str;
    
    //view
    tem_loadView.backgroundColor = [UIColor blackColor];
    tem_loadView.layer.cornerRadius = 6;
	tem_loadView.layer.masksToBounds = YES;
	tem_loadView.layer.borderWidth = 1;
	tem_loadView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    
    [tem_loadView addSubview:label];
    [label release];
    tem_loadView.tag = 520;
    [self.view addSubview:tem_loadView];
    [self.view bringSubviewToFront:tem_loadView];
    //[self.view insertSubview:tem_loadView atIndex:9999];
    [self performSelector:@selector(hideBaseMessage:) withObject:tem_loadView afterDelay:delays];
    
    [tem_loadView release];
}

-(void) showBaseMessOnMain:(CGRect)frame MesStr:(NSString*) mes Delay:(int) delays
{
    
    NSArray* argArr = [NSArray arrayWithObjects:
                       [NSNumber numberWithFloat:frame.origin.x],
                       [NSNumber numberWithFloat:frame.origin.y],
                       [NSNumber numberWithFloat:frame.size.width],
                       [NSNumber numberWithFloat:frame.size.height],
                       mes,
                       [NSNumber numberWithInt:delays],
                       nil];
    
    [self performSelectorOnMainThread:@selector(showBaseMessage:) withObject:argArr waitUntilDone:NO];
    
    // [self showBaseMessage:mes Delay:2.0];
}




@end

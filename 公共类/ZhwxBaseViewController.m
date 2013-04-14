//
//  ZhwxBaseViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-11.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"
#import "UINavigationBar+Image.h"
#import "Utilities.h"

@interface ZhwxBaseViewController ()

@property (nonatomic,retain)UINavigationBar* m_zhwxNavBar;

@end

@implementation ZhwxBaseViewController
@synthesize m_zhwxNavBar;


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [m_zhwxNavBar release];
    
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


@end

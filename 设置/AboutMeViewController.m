//
//  AboutMeViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-5-12.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "AboutMeViewController.h"
#import "Utilities.h"

@interface AboutMeViewController ()

@end

@implementation AboutMeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"关于我们";
        self.navigationItem.leftBarButtonItem = [Utilities createNavItemByTarget:self Sel:@selector(closeBtnAction:) Imgage:[UIImage imageNamed:@"item_back.png"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) closeBtnAction:(id) sender
{
    [super closeBtnAction:sender];
}

@end

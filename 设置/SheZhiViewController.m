//
//  SheZhiViewController.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "SheZhiViewController.h"
#import "AppDelegate.h"


@interface SheZhiViewController ()

@end

@implementation SheZhiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"four"];
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

- (IBAction)registerLogin:(id)sender
{
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    [del entryLoginControllerView];
}
@end

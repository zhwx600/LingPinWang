//
//  LoginViewController.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "LoginViewController.h"

#import "AppDelegate.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.m_userNameField) {
        [self.m_passwordField becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
        [self login:nil];
    }
    return YES;
}

- (IBAction)login:(id)sender {
    
    NSLog(@"LOGIN A ");
    
    AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [del entryTabControllerView];
    
}

- (IBAction)registerAct:(id)sender {
}

- (IBAction)getPasswordAct:(id)sender {
}

- (IBAction)savePasswordAct:(id)sender
{
    [self.m_userNameField resignFirstResponder];
    [self.m_passwordField resignFirstResponder];
    
}

- (IBAction)cancelInputView:(id)sender
{
    [self.m_userNameField resignFirstResponder];
    [self.m_passwordField resignFirstResponder];
}

- (void)dealloc {
    [_m_userNameField release];
    [_m_passwordField release];
    [super dealloc];
}
@end

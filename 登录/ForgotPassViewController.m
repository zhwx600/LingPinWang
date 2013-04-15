//
//  ForgotPassViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ForgotPassViewController.h"

@interface ForgotPassViewController ()

@end

@implementation ForgotPassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"密码找回";
        [self addMyNavBar];
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

-(void) closeBtnAction:(id)sender
{
    [super closeBtnAction:sender];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [self getNewPassword: nil];
    return YES;
}


- (IBAction)getNewPassword:(id)sender
{
    UIAlertView* passAlert = [[UIAlertView alloc] initWithTitle:@"新密码" message:@"新密码是:【123456】.请牢记!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [passAlert show];
    [passAlert release];
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self closeBtnAction:nil];
}


- (void)dealloc {
    [_m_phoneNumberField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_phoneNumberField:nil];
    [super viewDidUnload];
}
@end

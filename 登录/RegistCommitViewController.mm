//
//  RegistCommitViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RegistCommitViewController.h"
#import "HttpProcessor.h"
#import "xmlparser.h"


@interface RegistCommitViewController ()

@end

@implementation RegistCommitViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self addMyNavBar];
        [self setNavTitle:@"注册"];
        
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


-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    
    if (textField == self.m_phoneNumberField || textField == self.m_codeField) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        
        [UIView commitAnimations];
    }else{
        
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];

        CGRect rect = CGRectMake(0.0f, -180.0f, self.view.frame.size.width, self.view.frame.size.height);
        self.view.frame = rect;
        [UIView commitAnimations];
        
    }
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.m_phoneNumberField) {
        
        [self getCodeAct:nil];
        
    }else if (textField == self.m_codeField){
        
        [self.m_passwordField becomeFirstResponder];
        
    }else if (textField == self.m_passwordField){
        [self.m_passwordSureField becomeFirstResponder];
    }else if (textField == self.m_passwordSureField){
        [self registerButtonAct:nil];
    }
    
    return YES;
}


- (IBAction)m_passwordField:(id)sender {
}

- (IBAction)getCodeAct:(id)sender
{
    [self closeInputView:nil];
}

- (IBAction)registerButtonAct:(id)sender
{
    [self closeInputView:nil];
}

- (IBAction)closeInputView:(id)sender
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    
    [UIView commitAnimations];
    [self.m_codeField resignFirstResponder];
    [self.m_phoneNumberField resignFirstResponder];
    [self.m_passwordField resignFirstResponder];
    [self.m_passwordSureField resignFirstResponder];
}
- (void)dealloc {
    [_m_phoneNumberField release];
    [_m_codeField release];
    [_m_passwordField release];
    [_m_passwordSureField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_phoneNumberField:nil];
    [self setM_codeField:nil];
    [self setM_passwordField:nil];
    [self setM_passwordSureField:nil];
    [super viewDidUnload];
}







@end

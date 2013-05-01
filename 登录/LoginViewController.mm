//
//  LoginViewController.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "LoginViewController.h"
#import "DataManager.h"

#import "AppDelegate.h"
#import "RegistViewController.h"
#import "ForgotPassViewController.h"

#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"
#import "RequestLogin.h"

@interface LoginViewController ()

@property (nonatomic,assign)bool m_bSavePassword;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.m_bSavePassword = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
    if (self.m_bSavePassword) {
        self.m_userNameField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME_DEAULT_KEY];
        self.m_passwordField.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_PSWD_DEAULT_KEY];
        [self.m_saveButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        
    }else{
        self.m_userNameField.text = @"";
        self.m_passwordField.text = @"";
        [self.m_saveButton setImage:[UIImage imageNamed:@"没选中"] forState:UIControlStateNormal];
    }

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
    
    if (!self.m_userNameField.text || self.m_userNameField.text.length <= 0) {
        [Utilities ShowAlert:@"用户名输入为空！"];
        return;
    }
    if (!self.m_passwordField.text || self.m_passwordField.text.length <= 0) {
        [Utilities ShowAlert:@"密码输入为空！"];
        return;
    }
    if (self.m_userNameField.text.length != 11) {
        [Utilities ShowAlert:@"手机号码必须为11位数！"];
        return;
    }
    
    [self showLoadMessageView];
    
    [self requestLogin];
    

    
}

- (IBAction)registerAct:(id)sender
{
    RegistViewController* registview = [[RegistViewController alloc] init];
    [self.navigationController pushViewController:registview animated:YES];
    [registview release];
}

- (IBAction)getPasswordAct:(id)sender
{
    ForgotPassViewController* forgotview = [[ForgotPassViewController alloc] init];
    [self.navigationController pushViewController:forgotview animated:YES];
    [forgotview release];
}

- (IBAction)savePasswordAct:(id)sender
{

    if (self.m_bSavePassword) {
        [self.m_saveButton setImage:[UIImage imageNamed:@"没选中"] forState:UIControlStateNormal];
        self.m_bSavePassword = NO;
    }else{
        self.m_bSavePassword = YES;
        [self.m_saveButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
    }
    
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
    [_m_saveButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_saveButton:nil];
    [super viewDidUnload];
}
#pragma mark- UITextFieldDelegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int length = 0;
    if (textField == self.m_userNameField) {
        length = 11;
    }else{
        length = 16;
    }
    
    if (range.location >= length)
        return NO; // return NO to not change text
    return YES;
}
#pragma mark- 请求问题

//升级请求
-(void) requestLogin
{
    RequestLogin* loginObj = [[RequestLogin alloc] init];
    loginObj.m_loginType = @"iphone";
    loginObj.m_phone = self.m_userNameField.text;
    loginObj.m_password = [Utilities md5:self.m_passwordField.text];
    
    NSString* str = [MyXMLParser EncodeToStr:loginObj Type:REQUEST_FOR_LOGIN];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstLogin:)];
    [http threadFunStart];
    
    [http release];
    [loginObj release];
}

-(void) receiveDataByRequstLogin:(NSData*) data
{
    
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        [DataManager shareInstance].m_loginResult = (ResultLogin*)[MyXMLParser DecodeToObj:str];
        
        ResultLogin* result = [DataManager shareInstance].m_loginResult;
        
        //登录成功
        if (0 == [result.m_result compare:@"8"]) {

            AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            [del entryTabControllerView];
            
            if (self.m_bSavePassword) {
                
                [[NSUserDefaults standardUserDefaults] setValue:self.m_userNameField.text forKey:USER_NAME_DEAULT_KEY];
                [[NSUserDefaults standardUserDefaults] setValue:self.m_passwordField.text forKey:USER_PSWD_DEAULT_KEY];
            }else{
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_NAME_DEAULT_KEY];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_PSWD_DEAULT_KEY];
            }
            
        }else if (0 == [result.m_result compare:@"0"]){
            [Utilities ShowAlert:@"登录失败，账号不存在！"];
        }else if (0 == [result.m_result compare:@"1"]){
            [Utilities ShowAlert:@"登录失败，密码不正确！"];
        }
        
        
        
    }else{
        NSLog(@"receiveDataByRequstCode 接收到 数据 异常");
        
        [Utilities ShowAlert:@"登录失败，网络异常！"];
        
    }
    
    
    
}

@end

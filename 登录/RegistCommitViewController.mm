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

#import "RequestRegist.h"
#import "ProtocolDefine.h"

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
    
    [self requestCode];
    
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
    [_m_segment release];
    [_m_nameField release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_phoneNumberField:nil];
    [self setM_codeField:nil];
    [self setM_passwordField:nil];
    [self setM_passwordSureField:nil];
    [self setM_segment:nil];
    [self setM_nameField:nil];
    [super viewDidUnload];
}



#pragma mark- 请求问题

//升级请求
-(void) requestCode
{
    
    NSString* str = [MyXMLParser EncodeToStr:self.m_phoneNumberField.text Type:REQUEST_FOR_CODE];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstCode:)];
    [http threadFunStart];
    
    [http release];
}

-(void) receiveDataByRequstCode:(NSData*) data
{
    
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSString* getCode = (NSString*)[MyXMLParser DecodeToObj:str];
        
        self.m_codeField.text = getCode;
        
        NSLog(@" getCode = %@",getCode);
        
    }else{
        NSLog(@"receiveDataByRequstCode 接收到 数据 异常");
        
        self.m_codeField.text = @"";
        
    }
    
    
    
}


//升级请求
-(void) requestRegist
{
    
    RequestRegist* requestObj = [[RequestRegist alloc] init];
    requestObj.m_name = self.m_nameField.text;
    requestObj.m_password = self.m_passwordField.text;
    requestObj.m_phone = self.m_phoneNumberField.text;
    requestObj.m_sex = [self.m_segment titleForSegmentAtIndex:self.m_segment.selectedSegmentIndex];
    requestObj.m_answerDic = nil;
    
    
    NSString* str = [MyXMLParser EncodeToStr:nil Type:REQUEST_FOR_REGIST];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstRegist:)];
    [http threadFunStart];
    
    [http release];
}

-(void) receiveDataByRequstRegist:(NSData*) data
{
    
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSString* getCode = (NSString*)[MyXMLParser DecodeToObj:str];
        
        self.m_codeField.text = getCode;
        
        NSLog(@" getCode = %@",getCode);
        
    }else{
        NSLog(@"receiveDataByRequstCode 接收到 数据 异常");
        
        self.m_codeField.text = @"";
        
    }
    
    
    
}


@end

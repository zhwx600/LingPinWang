//
//  ForgotPassViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ForgotPassViewController.h"

#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "RequestRegist.h"
#import "ProtocolDefine.h"

@interface ForgotPassViewController ()

@property (nonatomic,retain) NSString* m_recCode;

@end

@implementation ForgotPassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        [self addMyNavBar];
        [self setNavTitle:@"找回密码"];
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
    if (!self.m_phoneNumberField.text || self.m_phoneNumberField.text.length<=0) {
        [Utilities ShowAlert:@"手机号码为空，请重输！"];
        return;
    }
    if (self.m_phoneNumberField.text.length != 11) {
        [Utilities ShowAlert:@"手机号码必须为11位数！"];
        return;
    }
    [self showLoadMessageView];
    [self requestForget];
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self closeBtnAction:nil];
}


- (void)dealloc {
    [_m_phoneNumberField release];
    self.m_recCode = nil;
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_phoneNumberField:nil];
    [super viewDidUnload];
}

#pragma mark- UITextFieldDelegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int length = 0;
    if (textField == self.m_phoneNumberField) {
        length = 11;
    }
    
    if (range.location >= length)
        return NO; // return NO to not change text
    return YES;
}


#pragma mark- 请求问题
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
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSString* getCode = (NSString*)[MyXMLParser DecodeToObj:str];
        
        [str release];
        if (0 == [getCode compare:@"-1"]) {
            [Utilities ShowAlert:@"获取验证码失败，请稍后再试！"];
        }else if (0 == [getCode compare:@"-2"]) {
            [Utilities ShowAlert:@"验证码已发送到该手机，请稍后再试！"];
        }else if (0 == [getCode compare:@"-3"]){
            [Utilities ShowAlert:@"该手机今天获取验证码已满，请明天再试！"];
        }else{
            self.m_recCode = getCode;
            
            [Utilities ShowAlert:@"验证码已通过短信发送到您手机，请注意查收"];
        }
        
        NSLog(@" getCode = %@",getCode);
        
    }else{
        NSLog(@"receiveDataByRequstCode 接收到 数据 异常");
        
        self.m_recCode = @"";
        [Utilities ShowAlert:@"获取验证码，网络异常！"];
        
    }
    
    
    
}


//升级请求
-(void) requestForget
{
    
    NSString* str = [MyXMLParser EncodeToStr:self.m_phoneNumberField.text Type:REQUEST_FOR_GET_PASSWORD];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstForget:)];
    [http threadFunStart];
    
    [http release];

}

-(void) receiveDataByRequstForget:(NSData*) data
{
    
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSString * result = (NSString*)[MyXMLParser DecodeToObj:str];
        [str release];
        //登录成功
        if (0 == [result compare:@"8"]) {
            [Utilities ShowAlert:@"处理成功，密码已通过短信发送给您手机！"];
            [self closeBtnAction:nil];
        }else if (0 == [result compare:@"1"]){
            [Utilities ShowAlert:@"找回密码失败，账号不存在！"];
        }else/* if (0 == [result compare:@"2"])*/{
            [Utilities ShowAlert:@"处理失败，请重试！"];
        }

        
    }else{
        NSLog(@"receiveDataByRequstForget 接收到 数据 异常");
        
        [Utilities ShowAlert:@"发送验证失败，网络异常！"];
        
    }
    
    
    
}


@end

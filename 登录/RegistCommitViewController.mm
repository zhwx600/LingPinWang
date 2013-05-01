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
#import "Utilities.h"

#import "AppDelegate.h"
#import "DataManager.h"
#import "Answer.h"
#import "RequestRegist.h"
#import "ProtocolDefine.h"
#import "RequestLogin.h"
#import "ResultLogin.h"

@interface RegistCommitViewController ()<UIAlertViewDelegate>

@property (nonatomic,retain)NSString* m_recCode;

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
        
    }else if (textField == self.m_nameField){
        
        [self.m_passwordField becomeFirstResponder];
        
    }else if (textField == self.m_codeField){
        
        [self.m_nameField becomeFirstResponder];
        
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
    if (!self.m_phoneNumberField.text || self.m_phoneNumberField.text.length <= 0) {
        [Utilities ShowAlert:@"用户名输入为空！"];
        return;
    }
    if (self.m_phoneNumberField.text.length != 11) {
        [Utilities ShowAlert:@"手机号码必须为11位数！"];
        return;
    }
    
    [self showLoadMessageView];
    [self requestCode];
    
}

- (IBAction)registerButtonAct:(id)sender
{
    [self closeInputView:nil];
    
    //验证手机号
    if (!self.m_phoneNumberField.text || self.m_phoneNumberField.text.length <= 0) {
        [Utilities ShowAlert:@"用户名输入为空！"];
        return;
    }
    if (self.m_phoneNumberField.text.length != 11) {
        [Utilities ShowAlert:@"手机号码必须为11位数！"];
        return;
    }
    //验证 验证码
    if (!self.m_codeField.text || self.m_codeField.text.length <= 0) {
        [Utilities ShowAlert:@"验证码输入为空！"];
        return;
    }
    if (0 != [self.m_recCode compare:self.m_codeField.text]) {
        [Utilities ShowAlert:@"验证码错误，请输入正确的验证码！"];
        return;
    }
    //验证 密码
    if (!self.m_passwordField.text || self.m_passwordField.text.length <= 0 || !self.m_passwordSureField.text || self.m_passwordSureField.text.length <= 0) {
        [Utilities ShowAlert:@"密码输入为空！"];
        return;
    }
    if (self.m_passwordField.text.length < 6 || self.m_passwordSureField.text.length < 6) {
        [Utilities ShowAlert:@"密码至少为6位！"];
        return;
    }
    if (0 != [self.m_passwordField.text compare:self.m_passwordSureField.text]) {
        [Utilities ShowAlert:@"两次输入的密码不一致！"];
        return;
    }
    
    [self showLoadMessageView];
    [self requestRegist];

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
    [self.m_nameField resignFirstResponder];
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

#pragma mark- UITextFieldDelegate
-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    int length = 0;
    if (textField == self.m_phoneNumberField) {
        length = 11;
    }else if(textField == self.m_nameField){
        length = 16;
    }else if(textField == self.m_codeField){
        length = 10;
    }else if(textField == self.m_passwordField || textField == self.m_passwordSureField){
        length = 16;
    }
    
    
    if (range.location >= length)
        return NO; // return NO to not change text
    return YES;
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
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        NSString* getCode = (NSString*)[MyXMLParser DecodeToObj:str];
        
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

-(NSMutableDictionary*) initAnswerDicData
{
    
    NSMutableDictionary* temMuDic = [[NSMutableDictionary alloc] init];
    for (int page=0; page<self.m_requestDataArray.count; page++) {
        
        Answer* temAnswer = (Answer*)[self.m_requestDataArray objectAtIndex:page];
        
        NSMutableArray* seletValueArr = [[NSMutableArray alloc] init];
        for (NSString* key in [temAnswer.m_answerSelect allKeys]) {
            if (0 == [(NSString*)([((NSString*)temAnswer.m_answerSelect) valueForKey:key]) compare:@"1"]) {
                [seletValueArr addObject:key];
            }
        }
        
        NSString* answerIdStr = [seletValueArr componentsJoinedByString:@","];
        [seletValueArr release];
        
        [temMuDic setValue:answerIdStr forKey:temAnswer.m_questionId];

    }
    return temMuDic;
    
}

//升级请求
-(void) requestRegist
{
    
    RequestRegist* requestObj = [[RequestRegist alloc] init];
    requestObj.m_name = self.m_nameField.text;
    requestObj.m_password = self.m_passwordField.text;
    requestObj.m_phone = self.m_phoneNumberField.text;
    requestObj.m_sex = [self.m_segment titleForSegmentAtIndex:self.m_segment.selectedSegmentIndex];
    requestObj.m_answerDic = [self initAnswerDicData];
    
    
    NSString* str = [MyXMLParser EncodeToStr:requestObj Type:REQUEST_FOR_REGIST];
    [requestObj release];
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
        
       // self.m_codeField.text = getCode;
        
        NSLog(@" getCode = %@",getCode);
        
        int codeValue = [getCode intValue];
        if (codeValue == 0) {
            [self dissLoadMessageView];
            [Utilities ShowAlert:@"注册失败，请重新提交或稍后再试!"];
        }else if(codeValue == 1){
            
            [self requestLogin];
            
           /* UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"恭喜您注册成功，赶紧签到吧，免费赠品等你来拿哦，也可使用此帐号登入网站(www.51Lpw.cn)签到哦,登入网站完善个人信息得到赠品的机会会更大哦赶紧行动吧。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 101;
            [alert show];
            [alert release];*/
            
        }else{
            [self dissLoadMessageView];
            [Utilities ShowAlert:@"该手机已被注册，请更换其它手机!"];
            
        }
        
        
        
    }else{
        [self dissLoadMessageView];
        NSLog(@"receiveDataByRequstCode 接收到 数据 异常");
        
       // self.m_codeField.text = @"";
        [Utilities ShowAlert:@"注册失败，请确认网络是否正常！"];
        
    }
    
    
    
}


//升级请求
-(void) requestLogin
{
    RequestLogin* loginObj = [[RequestLogin alloc] init];
    loginObj.m_loginType = @"iphone";
    loginObj.m_phone = self.m_phoneNumberField.text;
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

            [[NSUserDefaults standardUserDefaults] setValue:self.m_phoneNumberField.text forKey:USER_NAME_DEAULT_KEY];
            [[NSUserDefaults standardUserDefaults] setValue:self.m_passwordField.text forKey:USER_PSWD_DEAULT_KEY];

            
        }else if (0 == [result.m_result compare:@"0"]){
            [Utilities ShowAlert:@"登录失败，账号不存在！"];
        }else if (0 == [result.m_result compare:@"1"]){
            [Utilities ShowAlert:@"登录失败，密码不正确！"];
        }
        
        
        
    }else{
        NSLog(@"receiveDataByRequstLogin 接收到 数据 异常");
        
        [Utilities ShowAlert:@"登录失败，网络异常！"];
        
    }
    
    
    
}



#pragma mark - uialertdelegate
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101){
        AppDelegate* del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        [del entryTabControllerView];
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
    
}

@end

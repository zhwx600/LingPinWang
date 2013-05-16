//
//  ReplyViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-5-12.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ReplyViewController.h"
#import "Utilities.h"

#import "DataManager.h"
#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"
#import "RequestLogin.h"
#import "RequestStver.h"



@interface ReplyViewController ()
@property (retain, nonatomic) IBOutlet UITextView *m_textView;

- (IBAction)sendButtonAct:(id)sender;
@end

@implementation ReplyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"意见反馈";
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


- (void)dealloc {
    [_m_textView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_textView:nil];
    [super viewDidUnload];
}
- (IBAction)sendButtonAct:(id)sender {
    
    //验证手机号
    if (!self.m_textView.text || self.m_textView.text.length <= 0) {
        [Utilities ShowAlert:@"反馈内容不能为空！"];
        return;
    }
    
    [self showLoadMessageView];
    [self requestStver];
}


#pragma mark- 请求问题

//升级请求
-(void) requestStver
{
    ResultLogin* resultLogin = [DataManager shareInstance].m_loginResult;
    RequestStver* linPinObj = [[RequestStver alloc] init];
    
    linPinObj.m_content = self.m_textView.text;
    linPinObj.m_phoneNumber = [DataManager shareInstance].m_loginPhone;
    linPinObj.m_sessionId = resultLogin.m_sessionId;
    
    NSString* str = [MyXMLParser EncodeToStr:linPinObj Type:REQUEST_FOR_STVER];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstStver:)];
    [http threadFunStart];
    
    [http release];
    [linPinObj release];
}

-(void) receiveDataByRequstStver:(NSData*) data
{
    
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@" receiveDataByRequstProduct str = %@",str);
        
        NSString* resultstr = (NSString*)[MyXMLParser DecodeToObj:str];
        if (0 == [resultstr compare:@"1"]) {
            [Utilities ShowAlert:@"谢谢您的反馈，我们会及时查看！"];
            [self closeBtnAction:nil];
            return;
        }if (0 == [resultstr compare:@"-2"]) {
            [Utilities ShowAlert:@"您操作太频繁，请明天再试！"];
            [self closeBtnAction:nil];
            return;
        }else{
            [Utilities ShowAlert:@"提交反馈内容失败，请重试！"];
        }

        
        
    }else{
        NSLog(@"receiveDataByRequstQiandao 接收到 数据 异常");
        
        [Utilities ShowAlert:@"网络异常，提交失败，请重试！"];
        
    }
    
    
    
}




@end

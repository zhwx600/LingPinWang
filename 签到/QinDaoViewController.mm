//
//  QinDaoViewController.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "QinDaoViewController.h"

#import "DataManager.h"
#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"
#import "RequestLogin.h"
#import "RequestCheckIn.h"


#import "UIImageView+WebCache.h"
#import "ZWXPageScrollView.h"


@interface QinDaoViewController ()<ZWXPageScrollDelegate>

@property (nonatomic,retain) ZWXPageScrollView* m_pageView;
@property (retain, nonatomic) IBOutlet UIImageView *m_upImageView;
@property (retain, nonatomic) IBOutlet UILabel *m_userNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_stateLabel;
@property (retain, nonatomic) IBOutlet UILabel *m_timesLabel;
@property (retain, nonatomic) IBOutlet UIImageView *m_headImageView;
@property (retain, nonatomic) IBOutlet UIButton *m_qiandaoButton;

- (IBAction)qiandaoButtonAct:(id)sender;

@end

@implementation QinDaoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"签到";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self setQiandaoButtonState];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@" viewWillAppear:(BOOL)animated ; ");
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    self.m_pageView = nil;
    
    [_m_upImageView release];
    [_m_userNameLabel release];
    [_m_stateLabel release];
    [_m_timesLabel release];
    [_m_headImageView release];
    [_m_qiandaoButton release];
    [super dealloc];
}

-(void) setQiandaoButtonState
{
    
    ResultLogin* result = [DataManager shareInstance].m_loginResult;
    
    [self.m_pageView removeFromSuperview];
    self.m_pageView = nil;
    self.m_pageView = [[[ZWXPageScrollView alloc] initWithFrame:CGRectMake(0, 297, 320, 68)
                                                      PathList:result.m_adImageUrlArrary
                                                          Flag:INIT_SCROLL_URL
                                                      Delegate:self] autorelease];
    [self.view addSubview:_m_pageView];
    
    self.m_stateLabel.text = result.m_userState;
    self.m_timesLabel.text = result.m_linpinCount;
    self.m_userNameLabel.text = result.m_userName;
    
    [self.m_upImageView setImageWithURL:[NSURL URLWithString:result.m_upImageUrl]
                       placeholderImage:[UIImage imageNamed:@"Default"]
                                options:(SDWebImageOptions)SDWebImageCacheMemoryOnly];

    [self.m_headImageView setImageWithURL:[NSURL URLWithString:result.m_userImageUrl]
                         placeholderImage:[UIImage imageNamed:@"Default"] options:(SDWebImageOptions)SDWebImageCacheMemoryOnly];
    
    
    NSDictionary* dic = [[NSUserDefaults standardUserDefaults] valueForKey:USER_QIANDAO_DEAULT_KEY];
    NSString* userKey = [DataManager shareInstance].m_loginPhone;
    NSDate* valueDate = [dic valueForKey:userKey];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
    
    NSString* startDateStr =[dateFormatter stringFromDate:[NSDate date]];


    
    
    if (valueDate) {
        
        //已签到时间
        NSString* didDateStr =[dateFormatter stringFromDate:valueDate];
        
        
        if (0 != [startDateStr compare:didDateStr]) {
            [self.m_qiandaoButton setEnabled:YES];
        }else{
            [self.m_qiandaoButton setEnabled:NO];
        }
        
    }else{
        [self.m_qiandaoButton setEnabled:YES];
    }

    [dateFormatter release];
}


#pragma mark - ZWXPageScrollDelegate
-(void) imageSelectWithButton:(UIButton*) button
{
    ResultLogin* result = [DataManager shareInstance].m_loginResult;
    
    
    @try {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result.m_adToUrlArrary objectAtIndex:button.tag]]];
    }
    @catch (NSException *exception) {
        NSLog(@"imageSelectWithButton e = %@",exception);
    }
    @finally {
        
    }
    
    
    NSLog(@"button.tag = %d !",button.tag);
}


- (void)viewDidUnload {
    [self setM_upImageView:nil];
    [self setM_userNameLabel:nil];
    [self setM_stateLabel:nil];
    [self setM_timesLabel:nil];
    [self setM_headImageView:nil];
    [self setM_qiandaoButton:nil];
    [super viewDidUnload];
}
- (IBAction)qiandaoButtonAct:(id)sender
{
    [self showLoadMessageView];
    [self requestQiandao];
    
}

#pragma mark- 请求问题

//升级请求
-(void) requestQiandao
{
    RequestCheckIn* loginObj = [[RequestCheckIn alloc] init];
    loginObj.m_phone = [DataManager shareInstance].m_loginPhone;
    loginObj.m_sessionId = [DataManager shareInstance].m_loginResult.m_sessionId;
    
    NSString* str = [MyXMLParser EncodeToStr:loginObj Type:REQUEST_FOR_CHECK_IN];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstQiandao:)];
    [http threadFunStart];
    
    [http release];
    [loginObj release];
}

//签到返回状态，1=成功，-1=失败.(失败统一提示“网络有问题，请稍后再试！”),-2=今日已经有签到(提示“今日您已有签到，感谢您的参考，别忘了明天继续哦！”)
-(void) receiveDataByRequstQiandao:(NSData*) data
{
    
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSString* result = (NSString*)[MyXMLParser DecodeToObj:str];
        
        
        if (0 == [result compare:@"1"]) {
            
            NSLog(@" receiveDataByRequstQiandao str = %@",str);
            [self.m_qiandaoButton setEnabled:NO];
            
            [Utilities ShowAlert:@"签到成功!\n感谢您的参考,别忘了明天继续哦!"];
            
            NSDictionary* dic = [[NSUserDefaults standardUserDefaults] valueForKey:USER_QIANDAO_DEAULT_KEY];
            NSString* userKey = [DataManager shareInstance].m_loginPhone;
            //保存 key 和时间
            NSMutableDictionary* mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
            
            
            //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            //        //设定时间格式,这里可以设置成自己需要的格式
            //
            //        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //
            //        [mDic setObject:[dateFormatter dateFromString:@"2013-05-08 23:33:44"] forKey:userKey];
            
            [mDic setObject:[NSDate date] forKey:userKey];
            [[NSUserDefaults standardUserDefaults] setObject:mDic forKey:USER_QIANDAO_DEAULT_KEY];
        }else if (0 == [result compare:@"-1"]){
            [Utilities ShowAlert:@"签到，网络异常！"];
        }else{
            [Utilities ShowAlert:@"今日已经有签到，感谢您的参考，别忘了明天继续哦！"];
        }
        
        
        [str release];

        
        
    }else{
        NSLog(@"receiveDataByRequstQiandao 接收到 数据 异常");
        
        [Utilities ShowAlert:@"签到，网络异常！"];
        
    }
    
    
    
}


@end

//
//  LinPinDetailViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-5-7.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "LinPinDetailViewController.h"
#import "UIImageView+WebCache.h"

#import "DataManager.h"
#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"

#import "RequsetProduct.h"
#import "ResultProduct.h"
#import "ResultLiPinDetail.h"


#import "ZWXPageScrollView.h"

@interface LinPinDetailViewController ()<ZWXPageScrollDelegate>

@property (nonatomic,retain) ZWXPageScrollView* m_pageView;

@end


#define PARAM_SPARETESTR @"\n"

@implementation LinPinDetailViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        
        self.navigationItem.leftBarButtonItem = [Utilities createNavItemByTarget:self Sel:@selector(closeBtnAction:) Imgage:[UIImage imageNamed:@"item_back.png"]];
        
        // [self initParamScrollView:m_imageUrlList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self showLoadMessageView];
    [self requestLiPinDetail];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    self.m_pageView = nil;
    
    [_m_scrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [super viewDidUnload];
}

-(void) closeBtnAction:(id) sender
{
    
    
    [super closeBtnAction:sender];
}


-(void) initImageViewWithDetail:(ResultLiPinDetail*) detail
{
    
    [self.m_pageView removeFromSuperview];
    self.m_pageView = nil;
    self.m_pageView = [[[ZWXPageScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 240)
                                                       PathList:detail.m_imageUrlArrary
                                                           Flag:INIT_SCROLL_URL
                                                       Delegate:self] autorelease];
    self.m_pageView.m_buttonSelectEnable = NO;
    [self.view addSubview:self.m_pageView];
    
}


-(void) initParamScrollView:(NSArray*) arr
{
    
    int startVerOff = 200;
    
    for (int i=0; i<arr.count; i++) {
        
        NSString* textstr = [arr objectAtIndex:i];
        UIFont *font =  [UIFont fontWithName:@"Helvetica" size:15.0f];
        CGSize size = [textstr sizeWithFont:font constrainedToSize:CGSizeMake(278, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(21, startVerOff, size.width, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        label.textColor = [UIColor blackColor];
        [label setNumberOfLines:0];
        [label setLineBreakMode:NSLineBreakByWordWrapping];
        
        label.text = textstr;
        [self.m_scrollView addSubview:label];
        [label release];
        
        startVerOff += size.height + 9;
        
        NSLog(@"nitParamScrollView: %@",[arr objectAtIndex:i]);
    }
    [self.m_scrollView setContentSize:CGSizeMake(0, startVerOff)];
    [self.m_scrollView setFrame:DEV_HAVE_TABLE_VIEW_FRAME];
    
    
}



#pragma mark- 请求问题

//升级请求
-(void) requestLiPinDetail
{
    
    ResultLogin* loginObj = [DataManager shareInstance].m_loginResult;
    
    NSString* str = [MyXMLParser EncodeToStr:loginObj.m_sessionId Type:REQUEST_FOR_PRODUCT_DETAIL];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstLiPinDetail:)];
    [http threadFunStart];
    
    [http release];

}

//
-(void) receiveDataByRequstLiPinDetail:(NSData*) data
{
    
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        ResultLiPinDetail* result = (ResultLiPinDetail*)[MyXMLParser DecodeToObj:str];
        [str release];
        
        if (result && result.m_imageUrlArrary && result.m_imageUrlArrary.count>0) {
            
            [self initImageViewWithDetail:result];
            [self initParamScrollView:[result.m_description componentsSeparatedByString:PARAM_SPARETESTR]];
            
        }else{
            [Utilities ShowAlert:@"获取礼品详情异常！"];
        }

    }else{
        NSLog(@"receiveDataByRequstLiPinDetail 接收到 数据 异常");
        
        [Utilities ShowAlert:@"签到，网络异常！"];
        
    }
    
    
    
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



@end

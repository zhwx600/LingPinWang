//
//  ShangJiaDetailViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ShangJiaDetailViewController.h"
#import "UIImageView+WebCache.h"

#import "DataManager.h"
#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"

#import "RequestBusiness.h"
#import "ResultBusiness.h"
#import "ResultShangjiaDetail.h"


#import "ZWXPageScrollView.h"

@interface ShangJiaDetailViewController ()<ZWXPageScrollDelegate>
@property (nonatomic,retain) ZWXPageScrollView* m_pageView;

@property (nonatomic,assign) BOOL m_bFirstInView;

@end

@implementation ShangJiaDetailViewController
@synthesize m_bFirstInView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.m_bFirstInView = YES;
        self.navigationItem.leftBarButtonItem = [Utilities createNavItemByTarget:self Sel:@selector(closeBtnAction:) Imgage:[UIImage imageNamed:@"item_back.png"]];
        
        // [self initParamScrollView:m_imageUrlList];
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

    if (self.m_bFirstInView) {
        [self showLoadMessageView];
        [self requestShangJiaDetail];
        self.m_bFirstInView = NO;
    }

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


-(void) initImageViewWithDetail:(ResultShangjiaDetail*) detail
{
    
    [self.m_pageView removeFromSuperview];
    self.m_pageView = nil;
    self.m_pageView = [[[ZWXPageScrollView alloc] initWithFrame:CGRectMake(21, 15, 280, 180)
                                                       PathList:detail.m_imageUrlArrary
                                                           Flag:INIT_SCROLL_URL
                                                       Delegate:self] autorelease];
    self.m_pageView.m_buttonSelectEnable = NO;
    [self.m_scrollView addSubview:self.m_pageView];
    
}

-(void) initParamMessWithDetail:(ResultShangjiaDetail*) detail
{
    int labelVerOff = 210;
    int imageVerOff = 210;
    int spearetVerOff = 248;
    
    //UIImageView* telImageView = nil;
    UIImageView* sperImageView = nil;
    UIFont *font =  [UIFont fontWithName:@"Helvetica" size:14.0f];
    UIFont *titlefont =  [UIFont boldSystemFontOfSize: 17.0];
    CGSize size = CGSizeZero;
    UILabel* label = nil;
    UILabel* titleLabel = nil;
    
    detail.m_telephone = @"13811111111";
    detail.m_address = @"厦门市软件园二区2号楼";
    detail.m_fax = @"059234234234";
    
    if (detail.m_activity && [detail.m_activity length]>0) {
        
//        telImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"item_right.png"]];
//        [telImageView setFrame:CGRectMake(20, imageVerOff, 60, 35)];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageVerOff, 90, 35)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = titlefont;
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setNumberOfLines:0];
        titleLabel.text = @"优惠活动:";
        
        
        sperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"详情_分割线"]];
        [sperImageView setFrame:CGRectMake(20, spearetVerOff, sperImageView.frame.size.width, sperImageView.frame.size.height)];
        
        
        size = [detail.m_activity sizeWithFont:font constrainedToSize:CGSizeMake(500, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        label = [[UILabel alloc] initWithFrame:CGRectMake(100, labelVerOff, 210, 35)];
        
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = font;
        label.textColor = [UIColor blackColor];
        [label setNumberOfLines:0];
        label.text = detail.m_activity;
        label.textColor = [UIColor redColor];
        
        [self.m_scrollView addSubview:label];
        [self.m_scrollView addSubview:titleLabel];
        [self.m_scrollView addSubview:sperImageView];
        [label release];
        [titleLabel release];
        [sperImageView release];
        
        labelVerOff += 45;
        spearetVerOff += 45;
        imageVerOff += 45;
        

    }
    if (detail.m_telephone && [detail.m_telephone length]>0) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageVerOff, 90, 35)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = titlefont;
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setNumberOfLines:0];
        titleLabel.text = @"联系电话:";
        
        sperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"详情_分割线"]];
        [sperImageView setFrame:CGRectMake(20, spearetVerOff, sperImageView.frame.size.width, sperImageView.frame.size.height)];
        
        UITextView* tview = [[UITextView alloc] initWithFrame:CGRectMake(100, labelVerOff, 210, 40)];
        tview.text = detail.m_telephone;
        tview.backgroundColor = [UIColor clearColor];
        tview.textAlignment = NSTextAlignmentLeft;
        tview.font = font;
        tview.textColor = [UIColor grayColor];
        [tview setEditable:NO];
        [tview setDataDetectorTypes:UIDataDetectorTypePhoneNumber|UIDataDetectorTypeAddress|UIDataDetectorTypeCalendarEvent];
        
        [self.m_scrollView addSubview:tview];
        [self.m_scrollView addSubview:titleLabel];
        [self.m_scrollView addSubview:sperImageView];
        [tview release];
        [titleLabel release];
        [sperImageView release];
        
        labelVerOff += 45;
        spearetVerOff += 45;
        imageVerOff += 45;
    }
    
    if (detail.m_fax && [detail.m_fax length]>0) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageVerOff, 90, 35)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = titlefont;
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setNumberOfLines:0];
        titleLabel.text = @"传       真:";
        
        sperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"详情_分割线"]];
        [sperImageView setFrame:CGRectMake(20, spearetVerOff, sperImageView.frame.size.width, sperImageView.frame.size.height)];
        
        UITextView* tview = [[UITextView alloc] initWithFrame:CGRectMake(100, labelVerOff, 210, 40)];
        tview.text = detail.m_fax;
        tview.backgroundColor = [UIColor clearColor];
        tview.textAlignment = NSTextAlignmentLeft;
        tview.font = font;
        tview.textColor = [UIColor grayColor];
        [tview setEditable:NO];
        [tview setDataDetectorTypes:UIDataDetectorTypePhoneNumber|UIDataDetectorTypeAddress|UIDataDetectorTypeCalendarEvent];
        
        [self.m_scrollView addSubview:tview];
        [self.m_scrollView addSubview:titleLabel];
        [self.m_scrollView addSubview:sperImageView];
        [tview release];
        [titleLabel release];
        [sperImageView release];
        
        labelVerOff += 45;
        spearetVerOff += 45;
        imageVerOff += 45;
    }
    if (detail.m_address && [detail.m_address length]>0) {
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, imageVerOff, 90, 35)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.font = titlefont;
        titleLabel.textColor = [UIColor blackColor];
        [titleLabel setNumberOfLines:0];
        titleLabel.text = @"联系地址:";
        
        sperImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"详情_分割线"]];
        [sperImageView setFrame:CGRectMake(20, spearetVerOff, sperImageView.frame.size.width, sperImageView.frame.size.height)];
        
        UITextView* tview = [[UITextView alloc] initWithFrame:CGRectMake(100, labelVerOff, 210, 40)];
        tview.text = detail.m_address;
        tview.backgroundColor = [UIColor clearColor];
        tview.textAlignment = NSTextAlignmentLeft;
        tview.font = font;
        tview.textColor = [UIColor grayColor];
        [tview setEditable:NO];
        [tview setDataDetectorTypes:UIDataDetectorTypePhoneNumber|UIDataDetectorTypeAddress|UIDataDetectorTypeCalendarEvent];
        
        [self.m_scrollView addSubview:tview];
        [self.m_scrollView addSubview:titleLabel];
        [self.m_scrollView addSubview:sperImageView];
        [tview release];
        [titleLabel release];
        [sperImageView release];
        
        labelVerOff += 45;
        spearetVerOff += 45;
        imageVerOff += 45;
    }

    [self initParamScrollView:[detail.m_description componentsSeparatedByString:PARAM_SPARETESTR] Index:spearetVerOff-35];
        
}


-(void) initParamScrollView:(NSArray*) arr Index:(int) index
{
    
    int startVerOff = index;
    
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
-(void) requestShangJiaDetail
{
    NSString* str = [MyXMLParser EncodeToStr:self.m_proResult.m_businessId Type:REQUEST_FOR_BUSINESS_DETAIL];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstShangJiaDetail:)];
    [http threadFunStart];
    
    [http release];
    
}

//
-(void) receiveDataByRequstShangJiaDetail:(NSData*) data
{
    
    [self dissLoadMessageView];
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        ResultShangjiaDetail* result = (ResultShangjiaDetail*)[MyXMLParser DecodeToObj:str];
        [str release];
        
        if (result && result.m_imageUrlArrary && result.m_imageUrlArrary.count>0) {
            
            [self initImageViewWithDetail:result];
            [self initParamMessWithDetail:result];
            
        }else{
            [Utilities ShowAlert:@"获取商家详情异常！"];
        }
        
    }else{
        NSLog(@"receiveDataByRequstLiPinDetail 接收到 数据 异常");
        
        [Utilities ShowAlert:@"获取失败，网络异常！"];
        
    }
    
    
    
}


#pragma mark - ZWXPageScrollDelegate
-(void) imageSelectWithButton:(UIButton*) button
{
//    ResultLogin* result = [DataManager shareInstance].m_loginResult;
//    
//    
//    @try {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[result.m_adToUrlArrary objectAtIndex:button.tag]]];
//    }
//    @catch (NSException *exception) {
//        NSLog(@"imageSelectWithButton e = %@",exception);
//    }
//    @finally {
//        
//    }
    
    
    NSLog(@"button.tag = %d !",button.tag);
}


@end

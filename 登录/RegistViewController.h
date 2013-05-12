//
//  RegistViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

#import "RequestRegist.h"

@interface RegistViewController : ZhwxBaseViewController<UITableViewDelegate,UITableViewDataSource,
UIScrollViewDelegate>

{
    NSMutableArray *viewArr;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    int m_tableViewCount;
    
    NSMutableDictionary* m_questionArrDic;
    
    NSMutableArray* m_requestDataArray;
    
}


@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (retain, nonatomic) IBOutlet UIPageControl *m_pageControl;
@property (retain, nonatomic) IBOutlet UILabel *m_pageLabel;
@property (retain, nonatomic) IBOutlet UIButton *m_nextButton;
@property (retain, nonatomic) IBOutlet UIButton *m_checkButton;

@property (nonatomic,retain) RequestRegist* m_rRegistRequest;


- (IBAction)pageChangeAct:(id)sender;

-(IBAction)tiaoguoButton:(id) sender;
@property (retain, nonatomic) IBOutlet UIButton *previousButtonAct;
- (IBAction)previousButtonAct:(id)sender;
- (IBAction)nextButtonAct:(id)sender;


@end

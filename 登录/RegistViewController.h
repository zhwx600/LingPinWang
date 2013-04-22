//
//  RegistViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

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

- (IBAction)pageChangeAct:(id)sender;

-(void) tiaoguoButton:(id) sender;
@property (retain, nonatomic) IBOutlet UIButton *previousButtonAct;
- (IBAction)previousButtonAct:(id)sender;
- (IBAction)nextButtonAct:(id)sender;


@end

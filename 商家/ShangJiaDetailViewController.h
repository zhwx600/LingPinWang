//
//  ShangJiaDetailViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

@interface ShangJiaDetailViewController : ZhwxBaseViewController<UIScrollViewDelegate>
{
    NSMutableArray *viewArr;

    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    
    int imageCount;
}


@property (retain, nonatomic) IBOutlet UIPageControl *m_pageControl;
@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;
@property (retain, nonatomic) IBOutlet UITextView *m_desTextView;

@property (nonatomic,retain)    NSMutableArray* m_imageUrlList;

-(void) closeBtnAction:(id)sender;
-(void) initImageViewForLiPin;
-(void) initImageViewForShangJia;

@end

//
//  ShangJiaDetailViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

#import "ResultBusiness.h"

@interface ShangJiaDetailViewController : ZhwxBaseViewController<UIScrollViewDelegate>
{

}


@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (nonatomic,assign)ResultBusiness* m_proResult;

-(void) closeBtnAction:(id)sender;

-(void) initParamScrollView:(NSArray*) arr;

@end

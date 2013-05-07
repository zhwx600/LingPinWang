//
//  LinPinDetailViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-5-7.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"
#import "ResultProduct.h"

@interface LinPinDetailViewController : ZhwxBaseViewController<UIScrollViewDelegate>
{

}


@property (retain, nonatomic) IBOutlet UIScrollView *m_scrollView;

@property (nonatomic,assign)ResultProduct* m_proResult;

-(void) closeBtnAction:(id)sender;

-(void) initParamScrollView:(NSArray*) arr;

@end

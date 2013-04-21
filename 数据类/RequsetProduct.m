//
//  RequsetProduct.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RequsetProduct.h"

@implementation RequsetProduct


-(void) dealloc
{
    [self.m_endIndex release];
    [self.m_startIndex release];
    [super dealloc];
}

@end

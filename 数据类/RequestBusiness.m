//
//  RequestBusiness.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RequestBusiness.h"

@implementation RequestBusiness
-(void) dealloc
{
    [self.m_endIndex release];
    [self.m_startIndex release];
    [super dealloc];
}

@end

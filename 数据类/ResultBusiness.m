//
//  ResultBusiness.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ResultBusiness.h"

@implementation ResultBusiness
-(void) dealloc
{
    self.m_imageUrl = nil;
    self.m_businessName = nil;
    self.m_businessId = nil;
    self.m_businessDes = nil;
    
    
    [super dealloc];
}

@end

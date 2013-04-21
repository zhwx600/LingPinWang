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
    [self.m_imageUrl release];
    [self.m_businessName release];
    [self.m_businessId release];
    [self.m_businessDes release];
    
    
    [super dealloc];
}

@end

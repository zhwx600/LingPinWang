//
//  ResultProduct.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ResultProduct.h"

@implementation ResultProduct

-(void) dealloc
{
    self.m_imageUrl  = nil;
    self.m_productDes  = nil;
    self.m_productId  = nil;
    self.m_productName  = nil;
    self.m_productNum  = nil;
    self.m_productState  = nil;
    
    
    [super dealloc];
}

@end

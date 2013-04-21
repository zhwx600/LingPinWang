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
    [self.m_imageUrl release];
    [self.m_productDes release];
    [self.m_productId release];
    [self.m_productName release];
    [self.m_productNum release];
    [self.m_productState release];
    
    
    [super dealloc];
}

@end

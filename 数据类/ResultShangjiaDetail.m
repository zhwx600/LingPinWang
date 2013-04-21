//
//  ResultShangjiaDetail.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ResultShangjiaDetail.h"

@implementation ResultShangjiaDetail
-(id) init
{
    if (self = [super init]) {
        self.m_imageUrlArrary = [[NSMutableArray alloc] init];
    }
    return  self;
}


-(void) dealloc
{
    [self.m_imageUrlArrary release];
    [self.m_description release];
    [self.m_address release];
    [self.m_fax release];
    [self.m_telephone release];
    
    [super dealloc];
}
@end

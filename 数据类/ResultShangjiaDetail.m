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
        self.m_imageUrlArrary = [[[NSMutableArray alloc] init] autorelease];
    }
    return  self;
}


-(void) dealloc
{
    self.m_imageUrlArrary = nil;
    self.m_description = nil;
    self.m_address = nil;
    self.m_fax = nil;
    self.m_telephone = nil;
    self.m_activity = nil;
    
    [super dealloc];
}
@end

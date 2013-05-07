//
//  ResultLiPinDetail.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ResultLiPinDetail.h"

@implementation ResultLiPinDetail
-(id) init
{
    if (self = [super init]) {
        self.m_imageUrlArrary = [[[NSMutableArray alloc] init] autorelease];
    }
    return  self;
}


-(void) dealloc
{
    self.m_imageUrlArrary  = nil;
    self.m_description = nil;
    
    [super dealloc];
}

@end

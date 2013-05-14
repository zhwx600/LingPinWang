//
//  RequestStver.m
//  LingPinWang
//
//  Created by zhwx on 13-5-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RequestStver.h"

@implementation RequestStver


-(void) dealloc
{
    self.m_content = nil;
    self.m_phoneNumber = nil;
    self.m_sessionId = nil;
    
    [super dealloc];
}

@end

//
//  RequestCheckIn.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RequestCheckIn.h"

@implementation RequestCheckIn


-(void) dealloc
{
    self.m_phone = nil;
    self.m_sessionId = nil;
    
    [super dealloc];
}

@end

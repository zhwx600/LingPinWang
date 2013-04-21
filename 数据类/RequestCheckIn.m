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
    [self.m_phone release];
    [self.m_sessionId release];
    
    [super dealloc];
}

@end

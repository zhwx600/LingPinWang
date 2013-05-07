//
//  ResultLogin.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ResultLogin.h"

@implementation ResultLogin
-(id) init
{
    if (self = [super init]) {
        self.m_adToUrlArrary = [[[NSMutableArray alloc] init] autorelease];
        self.m_adImageUrlArrary = [[[NSMutableArray alloc] init] autorelease];
    }
    return  self;
}


-(void) dealloc
{
    self.m_linpinCount = nil;
    self.m_result = nil;
    self.m_sessionId = nil;
    self.m_upImageUrl = nil;
    self.m_userName = nil;
    self.m_userState = nil;
    self.m_adImageUrlArrary = nil;
    self.m_adToUrlArrary = nil;
    self.m_userImageUrl = nil;
    [super dealloc];
}

@end

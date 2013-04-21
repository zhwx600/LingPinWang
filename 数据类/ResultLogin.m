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
        self.m_adUrlDic = [[NSMutableDictionary alloc] init];
        self.m_adToUrlArrary = [[NSMutableArray alloc] init];
        self.m_adImageUrlArrary = [[NSMutableArray alloc] init];
    }
    return  self;
}


-(void) dealloc
{
    [self.m_adUrlDic release];
    [self.m_linpinCount release];
    [self.m_result release];
    [self.m_sessionId release];
    [self.m_upImageUrl release];
    [self.m_userName release];
    [self.m_userState release];
    [self.m_adImageUrlArrary release];
    [self.m_adToUrlArrary release];
    
    [super dealloc];
}

@end

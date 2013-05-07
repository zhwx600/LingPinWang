//
//  RequestRegist.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RequestRegist.h"

@implementation RequestRegist

-(id) init
{
    if (self = [super init]) {
        self.m_answerDic = [[[NSMutableDictionary alloc] init] autorelease];
    }
    return  self;
}


-(void) dealloc
{
    self.m_answerDic = nil;
    self.m_name = nil;
    self.m_password = nil;
    self.m_phone = nil;
    self.m_sex = nil;
    
    [super dealloc];
}

@end

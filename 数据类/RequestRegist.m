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
        self.m_answerDic = [[NSMutableDictionary alloc] init];
    }
    return  self;
}


-(void) dealloc
{
    [self.m_answerDic release];
    [self.m_name release];
    [self.m_password release];
    [self.m_phone release];
    [self.m_sex release];
    
    [super dealloc];
}

@end

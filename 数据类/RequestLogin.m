//
//  RequestLogin.m
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RequestLogin.h"

@implementation RequestLogin
-(id) init
{
    if (self = [super init]) {
        
    }
    return  self;
}


-(void) dealloc
{
    [self.m_password release];
    [self.m_phone release];
    [self.m_loginType release];
    
    [super dealloc];
}

@end

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
    self.m_password = nil;
    self.m_phone = nil;
    self.m_loginType = nil;
    
    [super dealloc];
}

@end

//
//  Answer.m
//  LingPinWang
//
//  Created by zhwx on 13-4-19.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "Answer.h"

@implementation Answer

-(id) init
{
    if (self = [super init]) {
        self.m_keyArr = [[NSMutableArray alloc] init];
        self.m_answer = [[NSMutableDictionary alloc] init];
    }
    return  self;
}


-(void) dealloc
{
    [self.m_questionId release];
    [self.m_answer release];
    [self.m_keyArr release];
    [self.m_question release];
    [self.m_type release];
    
    [super dealloc];
}


@end

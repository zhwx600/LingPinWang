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
        self.m_keyArr = [[[NSMutableArray alloc] init] autorelease];
        self.m_answer = [[[NSMutableDictionary alloc] init] autorelease];
        self.m_answerSelect = [[[NSMutableDictionary alloc] init] autorelease];
        self.m_max = 0;
        self.m_min = 0;
    }
    return  self;
}


-(void) dealloc
{
    self.m_questionId = nil;
    self.m_answer = nil;
    self.m_keyArr = nil;
    self.m_question = nil;
    self.m_type = nil;
    self.m_answerSelect = nil;
    
    [super dealloc];
}


@end

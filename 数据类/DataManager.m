//
//  DataManager.m
//  LingPinWang
//
//  Created by zhwx on 13-5-1.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

+(DataManager*) shareInstance
{
    static DataManager* s_dataManager = nil;
    if (!s_dataManager) {
        s_dataManager = [[DataManager alloc] init];
    }
    return s_dataManager;
}


-(void) dealloc{

    
    
    [super dealloc];
}


@end

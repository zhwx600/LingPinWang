//
//  DataManager.h
//  LingPinWang
//
//  Created by zhwx on 13-5-1.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResultLogin.h"


@interface DataManager : NSObject

@property (nonatomic,retain)ResultLogin* m_loginResult;

+(DataManager*) shareInstance;


@end

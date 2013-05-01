//
//  RequestLogin.h
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestLogin : NSObject

@property (nonatomic,retain) NSString* m_phone;//电话
@property (nonatomic,retain) NSString* m_password;//昵称
@property (nonatomic,retain) NSString* m_loginType;

@end

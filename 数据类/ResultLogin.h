//
//  ResultLogin.h
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultLogin : NSObject

@property (nonatomic,retain) NSString* m_result;//登录结果
@property (nonatomic,retain) NSString* m_sessionId;//通话 sessionid
@property (nonatomic,retain) NSString* m_userName;//用户名
@property (nonatomic,retain) NSString* m_linpinCount;//领品次数
@property (nonatomic,retain) NSString* m_userState;//用户状态 签到1 未签到0
@property (nonatomic,retain) NSString* m_upImageUrl;//上图 url
@property (nonatomic,retain) NSString* m_userImageUrl;//上图 url

@property (nonatomic,retain) NSMutableArray* m_adImageUrlArrary;
@property (nonatomic,retain) NSMutableArray* m_adToUrlArrary;

@end

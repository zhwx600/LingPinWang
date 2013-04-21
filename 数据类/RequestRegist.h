//
//  RequestRegist.h
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestRegist : NSObject

@property (nonatomic,retain) NSString* m_phone;//电话
@property (nonatomic,retain) NSString* m_name;//昵称
@property (nonatomic,retain) NSString* m_sex;//性别
@property (nonatomic,retain) NSString* m_password;//密码
@property (nonatomic,retain) NSMutableDictionary* m_answerDic;//答案字典（问题，答案数组）


@end

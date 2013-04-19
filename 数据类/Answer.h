//
//  Answer.h
//  LingPinWang
//
//  Created by zhwx on 13-4-19.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject



@property (nonatomic,retain) NSString* m_questionId;//问题id
@property (nonatomic,retain) NSString* m_question;//问题
@property (nonatomic,retain) NSString* m_type;//问题类型
@property (nonatomic,retain) NSMutableDictionary* m_answer;//答案字典
@property (nonatomic,retain) NSMutableArray* m_keyArr;//字典KEY 的数组， 保存顺序


@end

//
//  ResultShangjiaDetail.h
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultShangjiaDetail : NSObject
@property (nonatomic,retain) NSString* m_description;//描述
@property (nonatomic,retain) NSString* m_telephone;
@property (nonatomic,retain) NSString* m_fax;
@property (nonatomic,retain) NSString* m_address;
@property (nonatomic,retain) NSMutableArray* m_imageUrlArrary;
@end

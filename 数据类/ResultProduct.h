//
//  ResultProduct.h
//  LingPinWang
//
//  Created by zhwx on 13-4-21.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResultProduct : NSObject

@property (nonatomic,retain) NSString* m_productId;//登录结果
@property (nonatomic,retain) NSString* m_productName;//通话 sessionid
@property (nonatomic,retain) NSString* m_imageUrl;//用户名
@property (nonatomic,retain) NSString* m_productDes;//商品简介
@property (nonatomic,retain) NSString* m_productNum;//点击量
@property (nonatomic,retain) NSString* m_productState;//是否 为 今日礼品。


@end

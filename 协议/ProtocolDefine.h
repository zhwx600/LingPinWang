//
//  ProtocolDefine.h
//  LingPinWang
//
//  Created by zhwx on 13-4-19.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#ifndef LingPinWang_ProtocolDefine_h
#define LingPinWang_ProtocolDefine_h

#define SQL_FILE_NAME @"data.sqlite3"

#define REQUEST_SERVER_URL @"http://service.la-minas.cn/Default.aspx"

#define PARAM_SPARETE_STR @"$paramSeparate$"

#define OPTION_SPARETE_STR @","

#define ID_VALUE_SPARETE_STR @"="


#define PARAM_SPARETESTR @"\n"

//协议命令 宏
//获取问题答案
#define REQUEST_FOR_ANSWER @"getweijian"
//获取验证码
#define REQUEST_FOR_CODE @"getregno"
//注册
#define REQUEST_FOR_REGIST @"regsubmit"
//登录
#define REQUEST_FOR_LOGIN @"login"
//商品详细
#define REQUEST_FOR_PRODUCT_DETAIL @"productdetail"
//商家详细
#define REQUEST_FOR_BUSINESS_DETAIL @"businessesdetail"
//礼品发布
#define REQUEST_FOR_PRODUCT @"product"
//签到
#define REQUEST_FOR_CHECK_IN @"checkin"
//商家发布
#define REQUEST_FOR_BUSINESSES @"businesses"
//找回密码
#define REQUEST_FOR_GET_PASSWORD @"getpw"



//编码

#define ENC_GB1832 CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)



// 保存用户
#define USER_NAME_DEAULT_KEY @"user_login_name_key"
#define USER_PSWD_DEAULT_KEY @"user_login_pswd_key"

//点到保存KEY
#define USER_QIANDAO_DEAULT_KEY @"user_qiandao_key"


#endif

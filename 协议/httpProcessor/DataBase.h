//
//  DataBase.h
//  LiDaXin-iPad
//
//  Created by zheng wanxiang on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "DataProcess.h"



@interface DataBase : NSObject
//创建数据库
+(sqlite3*) createDB;

//-------------------------参展请求------------------------------
+(BOOL) addCanZhanTableObj:(CanZhanTableObj*)showobj;
+(BOOL) deleteCanZhanTableObj:(CanZhanTableObj*) showobj;
+(BOOL) alterCanZhanTableObj:(CanZhanTableObj*) showobj;

//获取所有信息
+(NSArray*) getAllCanZhanTableObj;
//获取某 图片的 信息
+(CanZhanTableObj*) getOneCanZhanTableInfoShowid:(NSString*) showid;




@end

//
//  DataBase.m
//  LiDaXin-iPad
//
//  Created by zheng wanxiang on 12-9-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DataBase.h"

static NSString* dbFileName = @"data.sqlite3";


@implementation DataBase


//创建数据库
+(sqlite3*) createDB
{
    sqlite3* database = nil;
    
    NSString* path = [[DataProcess getDocumentsPath] stringByAppendingPathComponent:dbFileName];
    
    @try {
//        
//        NSError* error = nil;
//        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//            NSLog(@"文件 已经 在 document");
//
//        }else{
//            [[NSFileManager defaultManager] createFileAtPath:path contents:nil attributes:nil];
//        }
//        if (error) {
//            return NO;
//        }
        
        if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert(0,@"创建数据库文件失败！");
            NSLog(@"创建数据库文件失败！");
            return nil;
        }
        NSString* sql = nil;
        char* message;
        
        //参展请求返回
        static bool bCreateCanZhan = false;
        if (!bCreateCanZhan) {
             sql = [NSString stringWithFormat:@"create table if not exists canzhantable(showid text,showname text,showmemo text,versionid text,primary key (showid))"];
            // @"create table if not exists statversion(row integer primary key,db_statversion text);";
            
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建canzhantable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateCanZhan = true;
        }
        
        //产品发布表
        static bool bCreateProRelease = false;
        if (!bCreateProRelease) {
            
            sql = [NSString stringWithFormat:@"create table if not exists chanpinfabutable(productid text,productcls text,imageid text,cjmemo text,versionid text,primary key (productid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建chanpinfabutable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateProRelease = true;
        }

        //产品类型 表
        static bool bCreateProType = false;
        if (!bCreateProType) {

            sql = [NSString stringWithFormat:@"create table if not exists chanpintypetable(typeid text,typename text,versionid text,primary key (typeid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建chanpintypetable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateProType = true;
        }
        //调查明细表
        static bool bCreateDiaochanDetail = false;
        if (!bCreateDiaochanDetail) {
            
            sql = [NSString stringWithFormat:@"create table if not exists diaochandetailtable(detailid text,diaochaid text,diaochacontent text,versionid text,primary key (detailid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建diaochandetailtable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateDiaochanDetail = true;
        }

        //调查请求
        static bool bCreateDiaochanRequest = false;
        if (!bCreateDiaochanRequest) {
            
            sql = [NSString stringWithFormat:@"create table if not exists diaochanrequesttable(diaochaid text,diaochaname text,versionid text,primary key (diaochaid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建diaochanrequesttable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateDiaochanRequest = true;
        }

        //公司图片请求
        static bool bCreateCompanyImage = false;
        if (!bCreateCompanyImage) {
            
            sql = [NSString stringWithFormat:@"create table if not exists companyimagetable(companyid text,companydes text,companyimageid text,versionid text,primary key (companyid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建companyimagetable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateCompanyImage = true;
        }

        //图片表请求
        static bool bCreateImageRequest = false;
        if (!bCreateImageRequest) {
            
            sql = [NSString stringWithFormat:@"create table if not exists imagerequesttable(imageid text,imageurl text,imagetype text,description text,versionid text,primary key (imageid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建imagerequesttable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateImageRequest = true;
        }

        //站位产品
        static bool bCreateZhanweiPro = false;
        if (!bCreateZhanweiPro) {
            
            sql = [NSString stringWithFormat:@"create table if not exists zhanweiprotable(showproid text,showid text,showproimageid text,showpromemo text,versionid text,primary key (showproid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建zhanweiprotable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateZhanweiPro = true;
        }

        //站位产品
        static bool bCreateZhanweiMes = false;
        if (!bCreateZhanweiMes) {
            
            sql = [NSString stringWithFormat:@"create table if not exists zhanweimestable(showitemid text,showid text,showitemimageid text,versionid text,primary key (showitemid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建zhanweimestable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateZhanweiMes = true;
        }

        //总版本
        static bool bCreateVersion = false;
        if (!bCreateVersion) {
            sql = [NSString stringWithFormat:@"create table if not exists versiontable(versionid text)"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建versiontable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateVersion = true;
        }  
        
        //站位产品
        static bool bCreateChangJing = false;
        if (!bCreateChangJing) {
            
            sql = [NSString stringWithFormat:@"create table if not exists changjingtable(changjingid text,changjingtype text,productid text,imageid text,versionid text,primary key (changjingid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建changjingtable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateChangJing = true;
        }
        
        //调查选项表
        static bool bCreateDiaochaItem = false;
        if (!bCreateDiaochaItem) {
            
            sql = [NSString stringWithFormat:@"create table if not exists diaochaitemtable(itemid text,diaochaid text,diaochazhuti text,versionid text,primary key (itemid))"];
            if (sqlite3_exec(database, [sql UTF8String],nil, nil, &message) != SQLITE_OK) {
                sqlite3_close(database);
                NSAssert1(0,@"创建diaochaitemtable表失败：%s",message);
                sqlite3_free(message);
                return nil;
            }
            bCreateDiaochaItem = true;
        }

        
        return database;
    }
    @catch (NSException *exception) {
        sqlite3_close(database);
        return nil;
    }
    
}

#pragma mark  参展请求表
//-------------------------参展请求------------------------------
+(BOOL) addCanZhanTableObj:(CanZhanTableObj*)showobj
{
    sqlite3* database = nil;
    @try {
        //打开数据库
        database = [DataBase createDB];
        char* message;
        
        NSString* desStr = [showobj.m_zhanhuiDescription stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        
        NSString* updateSql =[[NSString alloc] initWithFormat:@"insert or replace into canzhantable values('%@','%@','%@','%@');",showobj.m_canzhanId,showobj.m_canzhanName,desStr,showobj.m_versionId];
        if (sqlite3_exec(database, [updateSql UTF8String],nil, nil, &message) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert1(0,@"addImagaddCanZhanTableObj:(CanZhanTableObj*)showobj表失败：%s",message);
            sqlite3_free(message);
            [updateSql release];
            return NO;
        }
        sqlite3_close(database);
        [updateSql release];
        return YES;
        
    }
    @catch (NSException *exception) {
        sqlite3_close(database);
        return NO;
    }

}
+(BOOL) deleteCanZhanTableObj:(CanZhanTableObj*) showobj
{
    sqlite3* database = nil;
    @try {
        //打开数据库
        database = [DataBase createDB];
        NSString* deletesql = [NSString stringWithFormat:@"delete from canzhantable where showid='%@';",showobj.m_canzhanId];
        
        char *message=nil;
        if (sqlite3_exec(database, [deletesql UTF8String],nil, nil, &message) != SQLITE_OK) {
            NSLog(@"删除 canzhantable where showi 数据：%s",message);
            sqlite3_free(message);
        }else {
            NSLog(@"删除 canzhantable where showi 数据成功");
        }
        
        sqlite3_close(database);
        return YES;
        
    }
    @catch (NSException *exception) {
        sqlite3_close(database);
        return NO;
    }

}

+(BOOL) alterCanZhanTableObj:(CanZhanTableObj*) showobj
{
    sqlite3* database = nil;
    @try {
        //打开数据库
        database = [DataBase createDB];
        char* message;
        NSString* desStr = [showobj.m_zhanhuiDescription stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        NSString* updateSql =[[NSString alloc] initWithFormat:@"insert or replace into canzhantable values('%@','%@','%@','%@');",showobj.m_canzhanId,showobj.m_canzhanName,desStr,showobj.m_versionId];
        if (sqlite3_exec(database, [updateSql UTF8String],nil, nil, &message) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert1(0,@"addImagaddCanZhanTableObj:(CanZhanTableObj*)showobj表失败：%s",message);
            sqlite3_free(message);
            [updateSql release];
            return NO;
        }
        sqlite3_close(database);
        [updateSql release];
        return YES;
        
    }
    @catch (NSException *exception) {
        sqlite3_close(database);
        return NO;
    }

}

//获取所有信息
+(NSArray*) getAllCanZhanTableObj
{
    sqlite3* database = nil;
    @try {
        //打开数据库
        database  = [DataBase createDB];;
        NSString* sql = @"select * from canzhantable;";
        
        //  @"select db_recordbusnum from recordbusnum";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            NSMutableArray* dataArry = [[NSMutableArray alloc] init];
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char* data0 = (char*)sqlite3_column_text(statement, 0);
                char* data1 = (char*)sqlite3_column_text(statement, 1);
                char* data2 = (char*)sqlite3_column_text(statement, 2);
                char* data3 = (char*)sqlite3_column_text(statement, 3);
                CanZhanTableObj* line = [[CanZhanTableObj alloc] init];
                
                line.m_canzhanId = [[NSString alloc] initWithUTF8String:data0];
                line.m_canzhanName = [[NSString alloc] initWithUTF8String:data1];
                line.m_zhanhuiDescription = [[NSString alloc] initWithUTF8String:data2];
                line.m_versionId = [[NSString alloc] initWithUTF8String:data3];
                
                [dataArry addObject:line];
                [line release];
                
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            [dataArry autorelease];		
            return dataArry;
        }
        sqlite3_close(database);
        NSLog(@"查询ggetAllCanZhanTableObj canzhantable表时失败！");
        return nil;
    }
    @catch (NSException *exception) {
        sqlite3_close(database);
        return nil;
    }

}
//获取某 图片的 信息
+(CanZhanTableObj*) getOneCanZhanTableInfoShowid:(NSString*) showid
{
    sqlite3* database = nil;
    @try {
        //打开数据库
        database  = [DataBase createDB];;
        NSString* sql = [NSString stringWithFormat:@"select * from canzhantable where showid='%@';",showid];
        
        
        //  @"select db_recordbusnum from recordbusnum";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
            
            CanZhanTableObj* line = [[[CanZhanTableObj alloc] init] autorelease];
            
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char* data0 = (char*)sqlite3_column_text(statement, 0);
                char* data1 = (char*)sqlite3_column_text(statement, 1);
                char* data2 = (char*)sqlite3_column_text(statement, 2);
                char* data3 = (char*)sqlite3_column_text(statement, 3);
                
                line.m_canzhanId= [[NSString alloc] initWithUTF8String:data0];
                line.m_canzhanName = [[NSString alloc] initWithUTF8String:data1];
                line.m_zhanhuiDescription = [[NSString alloc] initWithUTF8String:data2];
                line.m_versionId = [[NSString alloc] initWithUTF8String:data3];
                break;
                
            }
            sqlite3_finalize(statement);
            sqlite3_close(database);
            return line;
            
        }
        sqlite3_close(database);
        NSLog(@"查询getOneCanZhanTableInfoShowid:(NSString*) showid canzhantable表时失败！");
        return nil;
    }
    @catch (NSException *exception) {
        sqlite3_close(database);
        return nil;
    }

}


@end

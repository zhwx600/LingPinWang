//
//  Utilities.h
//  iFrameExtractor
//
//  Created by lajos on 1/10/10.
//
//  Copyright 2010 Lajos Kamocsay
//
//  lajos at codza dot com
//
//  iFrameExtractor is free software; you can redistribute it and/or
//  modify it under the terms of the GNU Lesser General Public
//  License as published by the Free Software Foundation; either
//  version 2.1 of the License, or (at your option) any later version.
// 
//  iFrameExtractor is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
//  Lesser General Public License for more details.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#define SAFE_DEL(X)  if(X){delete X;X=NULL;}
@interface Utilities : NSObject {

}

+(NSString *)bundlePath:(NSString *)fileName;
+(NSString *)documentsPath:(NSString *)fileName;
+ (void)		 ShowAlert:(NSString *) nstrMessage;
+ (void)     ShowNetWorkIcon:(bool)bShow;
+ (BOOL) IsConnectedToNetwork;

+ (UIView*) ShowMsg: (NSString *)strMsg :(BOOL)waitIcon;
+ (UIAlertView *) createProgressionAlertWithMessage:(NSString *)message withActivity:(BOOL)activity;
+ (void) StopProgressionAlert:(UIAlertView *)pAlertView;
+ (NSString *) md5:(NSString *)str;

//pos 0 back, 1 left ,2 right
+ (UIBarButtonItem*) createNavItemByTarget:(id) target Sel:(SEL) sel Imgage:(UIImage*) image Title:(NSString*)title Pos:(int)pos;


+ (UIBarButtonItem*) createNavItemByTarget:(id) target Sel:(SEL) sel Imgage:(UIImage*) image;


+ (NSString*) srandNumberBit:(int) bit;

+(float) getSystemVersion;


//获取数据库文件路径
+(NSString*) getDocumentsPath;
+(BOOL) writeData:(NSData*) data FileName:(NSString*) fileName;
+(BOOL) fileIsExists:(NSString*) fileName;
//删除文件
+(BOOL) removeFileByName:(NSString*) fileName;
+(NSString*) getImageFilePath;

//用后缀获取唯一的文件名
+(NSString*) getSoleFileName:(NSString*) fileName;


@end

//
//  Utilities.m
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

#import "Utilities.h"
#import <SystemConfiguration/SystemConfiguration.h>
#include <netdb.h>

@implementation Utilities

+(NSString *)bundlePath:(NSString *)fileName {
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
}

+(NSString *)documentsPath:(NSString *)fileName {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	return [documentsDirectory stringByAppendingPathComponent:fileName];
}

+(void)		 ShowAlert:(NSString *) nstrMessage
{
	UIAlertView *av=[[[UIAlertView alloc] initWithTitle:nil
										  message:nstrMessage  delegate:nil
									  cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
	[av show];
	
}
+ (void)     ShowNetWorkIcon:(bool)bShow
{
	UIApplication *app=[UIApplication sharedApplication];
	app.networkActivityIndicatorVisible=bShow;
	
}

+ (BOOL) IsConnectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);    
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags) 
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}


+ (UIView*) ShowMsg: (NSString *)strMsg :(BOOL)waitIcon
{
	
	CGRect  viewRect = CGRectMake(0, 0, 160, 90);
	UIView* myView2 = [[UIView alloc] initWithFrame:viewRect];
	myView2.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
	
	UILabel *label=[[UILabel alloc] initWithFrame:CGRectMake(0.0f,0.0f, 140.0f, 50)];
	label.text=strMsg;
	[label setTextColor:[UIColor whiteColor]];
	label.center=myView2.center;
	
	label.center=CGPointMake(myView2.bounds.size.width/2.0f,
							 60.0f);
	label.textAlignment=UITextAlignmentCenter;
	label.backgroundColor=[UIColor clearColor];
	
	[myView2 addSubview:label];
	
	[label release];
	if(waitIcon)
	{
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		activityView.center=CGPointMake(myView2.bounds.size.width/2.0f,30.0f);
		[activityView startAnimating];
		[myView2 addSubview:activityView];
		
		[activityView release];
	}
	
	
	return myView2;
}



+ (UIAlertView *) createProgressionAlertWithMessage:(NSString *)message withActivity:(BOOL)activity
{
	UIAlertView *pProgressAlert = [[[UIAlertView alloc] initWithTitle: message
												   message: nil
												  delegate: self
										 cancelButtonTitle: nil
										 otherButtonTitles: nil]autorelease];
	[pProgressAlert show];
	// Create the progress bar and add it to the alert
	if (activity) {
		UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		//activityView.frame = CGRectMake(139.0f-18.0f, 80.0f, 37.0f, 37.0f);
		activityView.center=CGPointMake(140.0f,65.0f);

      //  activityView.center=CGPointMake(pProgressAlert.bounds.size.width/2.0f,pProgressAlert.bounds.size.height-40.0f);
		
        
		[pProgressAlert addSubview:activityView];
		[activityView startAnimating];
		[activityView release];
	} else {
		UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(30.0f, 80.0f, 225.0f, 90.0f)];
		[pProgressAlert addSubview:progressView];
		[progressView setProgressViewStyle: UIProgressViewStyleBar];
		[progressView release];
	}return pProgressAlert;
}

+ (void) StopProgressionAlert:(UIAlertView *)pAlertView
{
	if(pAlertView)
	{
		[pAlertView dismissWithClickedButtonIndex:0 animated:NO];
	}
}
+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3], 
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}


+ (UIBarButtonItem*) createNavItemByTarget:(id) target Sel:(SEL) sel Imgage:(UIImage*) image Title:(NSString*)title Pos:(int)pos
{
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:14.0f];
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setExclusiveTouch:YES];
    CGSize strsize = [title sizeWithFont:font];
    CGRect frame;
    
    //back
    if (0 == pos) {
        
        frame = CGRectMake(0, 0, 2*10+strsize.width+10, 32);
        button.frame = frame;
        
        if ([Utilities getSystemVersion]<5.0) {
            [button setBackgroundImage:[image stretchableImageWithLeftCapWidth:35 topCapHeight:15] forState:UIControlStateNormal];
            [button setBackgroundImage:[image stretchableImageWithLeftCapWidth:35 topCapHeight:15] forState:UIControlStateHighlighted];
            NSLog(@"size = %@ ",image);
        }else{
            [button setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 20)] forState:UIControlStateNormal];
            [button setBackgroundImage:[image resizableImageWithCapInsets:UIEdgeInsetsMake(10, 30, 10, 20)] forState:UIControlStateHighlighted];
            NSLog(@"size ++= %@ ",image);
        }
        
        
        
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.text = [NSString stringWithFormat:@"   %@",title];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        [button addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label release];

    //left
    }else if(1 == pos){
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        
        frame = CGRectMake(0, 0, 2*10+strsize.width, 32);
        button.frame = frame;
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.text = title;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        [button addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label release];
    //right
    }else if(2 == pos){
        
        [button setBackgroundImage:image forState:UIControlStateNormal];
        [button setBackgroundImage:image forState:UIControlStateHighlighted];
        
        frame = CGRectMake(0, 0, 2*10+strsize.width, 32);
        button.frame = frame;
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.text = title;
        label.textAlignment = UITextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
        [button addSubview:label];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        [label release];
    }
    
    
    
    [button setShowsTouchWhenHighlighted:YES];
    
    
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    return item;
}

//pos 0 back, 1 left ,2 right
+ (UIBarButtonItem*) createNavItemByTarget:(id) target Sel:(SEL) sel Imgage:(UIImage*) image
{
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [button setExclusiveTouch:YES];
    
    
    
    CGSize strsize = CGSizeMake(image.size.width/2.0, image.size.height/2.0);
    
    CGRect frame;
    frame = CGRectMake(0, 0, strsize.width, strsize.height);
    button.frame = frame;
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateHighlighted];
    
    [button setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem* item = [[[UIBarButtonItem alloc] initWithCustomView:button] autorelease];
    return item;
}


+ (NSString*) srandNumberBit:(int) bit
{
    NSMutableString* formstr = [[[NSMutableString alloc] init] autorelease];
    for (int i=0; i<bit; i++) {
        [formstr appendFormat:@"%d",(unsigned)(arc4random()%10)];
    }
    return formstr;
}

+(float) getSystemVersion
{
    static float fversion = 0.0;
    if (fversion <= 0.0) {
        fversion = [[[UIDevice currentDevice] systemVersion] floatValue];
    }
    return fversion;
    
}

#pragma mark- 文件操作 

//获取数据库文件路径
+(NSString*) getDocumentsPath
{
	NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* str = [path objectAtIndex:0];
	NSMutableString* pathfile = [[[NSMutableString alloc] initWithString:str] autorelease];
	return pathfile;
}

+(BOOL) writeData:(NSData*) data FileName:(NSString*) fileName
{
    NSError* error = nil;
    NSString* filePath = [[Utilities getImageFilePath] stringByAppendingPathComponent:fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSLog(@"文件 已经 在 document");
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    }
    if (error) {
        return NO;
    }
    
    return [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
}

+(BOOL) fileIsExists:(NSString*) fileName
{
    NSString* filePath = [[Utilities getImageFilePath] stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

//删除文件
+(BOOL) removeFileByName:(NSString*) fileName
{
    NSString* filePath = [[Utilities getImageFilePath] stringByAppendingPathComponent:fileName];
    NSError* error = nil;
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
}



+(NSString*) getImageFilePath
{
    NSArray* path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString* str = [path objectAtIndex:0];
    
    
    NSString* docpath = [str stringByAppendingPathComponent:@"CapImage"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:docpath]) {
        return docpath;
    }
    
    NSError* error;
    if ([[NSFileManager defaultManager] createDirectoryAtPath:docpath withIntermediateDirectories:YES attributes:nil error:&error]) {
        return docpath;
    }
    return  nil;
    //  return [DataProcess getMainPath];
    
}

+(NSString*) getSoleFileName:(NSString*) fileName
{
    NSLog(@"saveImgeToLocalAct button tag = %@",fileName);
    if ([Utilities fileIsExists:fileName]) {
        
        NSString* namestr = [fileName substringWithRange:NSMakeRange(0, 14)];
        NSString* indexstr = [fileName substringWithRange:NSMakeRange(15, 2)];
        
        NSString* newName = [NSString stringWithFormat:@"%@-%02d.png",namestr,[indexstr intValue]+1];
        return [Utilities getSoleFileName:newName];
        
    }else{
        return fileName;
    }    
    
}

@end

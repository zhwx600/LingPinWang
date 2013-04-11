//
//  IconDownloader.h
//  LiveByTouch
//
//  Created by hao.li on 11-7-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@protocol IconDownloaderDelegate <NSObject>
- (void)appImageDidLoad:(Document)docType;
@optional
- (void)appImageDidLoad:(Document)docType :(int)row;
@end
@interface IconDownloader : NSObject {
	UIImage *appIcon;	 //图片的 下载保存
	
	id <IconDownloaderDelegate> delegate;
	
	NSMutableData *activeDownload;
    NSURLConnection *imageConnection;
	int code;
	NSString *imageUrl;//图片的名字
	
	Document imageType;
	
	BOOL isCancle;
	
	int row;
}
@property (assign) id<IconDownloaderDelegate> delegate;
@property (nonatomic,retain) UIImage *appIcon;

-(void) cancleDownload;
-(void) startDownload:(NSString*)iconUrl Type:(Document)type;
-(void) startDownload:(NSString*)iconUrl Type:(Document)type Row:(int)value;
@end

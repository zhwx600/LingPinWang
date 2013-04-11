//
//  IconDownloader.m
//  LiveByTouch
//
//  Created by hao.li on 11-7-27.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "IconDownloader.h"
#import "Global.h"

@implementation IconDownloader
@synthesize delegate;
@synthesize appIcon;


-(void) startDownload:(NSString*)iconUrl Type:(Document)type {
	
	imageType = type;
	row = -1;
	self.appIcon = [[Global GetInstance] getDiskImage:iconUrl Type:type];
	if (self.appIcon != nil ) {
	
		// call our delegate and tell it that our icon is ready for display
        if ([delegate respondsToSelector:@selector(appImageDidLoad:)]) {
            if (row>-1) {
                [delegate appImageDidLoad:imageType :row];
            }
            else {
                [delegate appImageDidLoad:imageType];
            }
        }
		return;
	}
	
	[imageUrl release];
	[iconUrl retain];
	imageUrl = iconUrl;
	activeDownload = [[NSMutableData alloc] initWithData:nil];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:iconUrl]] delegate:self];
    imageConnection = conn;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [conn release];
}

-(void) startDownload:(NSString*)iconUrl Type:(Document)type Row:(int)value{
	imageType = type;
	row = value;
	
	self.appIcon = [[Global GetInstance] getDiskImage:iconUrl Type:type];
	if (self.appIcon != nil) {
		
		// call our delegate and tell it that our icon is ready for display
        if ([delegate respondsToSelector:@selector(appImageDidLoad:)]) {
            if (row>-1) {
                [delegate appImageDidLoad:imageType :row];
            }
            else {
                [delegate appImageDidLoad:imageType];
            }
        }
		
		return;
	}
	
	[imageUrl release];
	[iconUrl retain];
	imageUrl = iconUrl;
	activeDownload = [[NSMutableData alloc] initWithData:nil];
    // alloc+init and start an NSURLConnection; release on completion/failure
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:
                             [NSURLRequest requestWithURL:
                              [NSURL URLWithString:iconUrl]] delegate:self];
    imageConnection = conn;
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [conn release];
	
}

-(void) cancleDownload{
	isCancle = YES;
}

#pragma mark Download support (NSURLConnectionDelegate)

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [activeDownload appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	NSHTTPURLResponse *http = (NSHTTPURLResponse*)response;
	code = [http statusCode];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	// Clear the activeDownload property to allow later attempts
    activeDownload = nil;
    
    // Release the connection now that it's finished
    imageConnection = nil;
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	UIImage *image=nil;
	
	// Set appIcon and clear temporary data/image
	image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NoPicFrame1.png" ofType:nil]];;

	self.appIcon = [image retain];
	
    [image release];
	
    // call our delegate and tell it that our icon is ready for display
    if (isCancle) {
		return;
	}
	if ([delegate respondsToSelector:@selector(appImageDidLoad:)]) {
		if (row>-1) {
			[delegate appImageDidLoad:imageType :row];
		}
		else {
			[delegate appImageDidLoad:imageType];
		}
	}
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	UIImage *image=nil;
	
	// Set appIcon and clear temporary data/image
	if (code>=400) {//服务器返回错误信息
		image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"NoPicFrame.png" ofType:nil]];;
	}
	else {
		image = [[UIImage alloc] initWithData:activeDownload];
	}
	
	//异步缓存图片
	dispatch_queue_t network_queue;  
	network_queue = dispatch_queue_create("com.myapp.network", nil); 
	
	dispatch_async(network_queue, ^{
		//保存图片的本地缓存
		[[Global GetInstance] savingImage:imageUrl Image:image Type:imageType];
		dispatch_async(dispatch_get_main_queue(), ^{ 
			
		}); 
		
	} ); 
	
	self.appIcon = [image retain];
	
    [image release];
    activeDownload = nil;
    // Release the connection now that it's finished
    imageConnection = nil;
	
    // call our delegate and tell it that our icon is ready for display
	if (isCancle) {
		return;
	}
	if ([delegate respondsToSelector:@selector(appImageDidLoad:)]) {
		if (row>-1) {
			[delegate appImageDidLoad:imageType :row];
		}
		else {
			[delegate appImageDidLoad:imageType];
		}
	}
}


- (void)dealloc
{
	[appIcon release];
	appIcon = nil;
    [activeDownload release];
	activeDownload = nil;
    [imageConnection cancel];
    [imageConnection release];
	imageConnection = nil;
	[imageUrl release];
	imageUrl = nil;
    [super dealloc];
}
@end

//
//  Global.m
//  LiveByTouch
//
//  Created by hao.li on 11-7-18.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "Global.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "JSON.h"
#import "LableView.h"

@implementation Global
@synthesize ScreenWidth,ScreenHeight;
@synthesize mainViewController;
@synthesize lat,lng,locationConfirm,lblConfirm,targetView,hasNetwork;

static Global *global;
static LableView *lblToast;
static UIView *vv;
static NSTimer *timer;
+(Global*) GetInstance
{
	
	@synchronized(self)
	{
		if (!global){
			global = [[Global alloc] init];
//			global.lng = 31.202377f;
//			global.lat = 121.408828f;
		}
		return global;
	}
}

-(void) setLocationConfirm:(NSString *)loc{
	if (locationConfirm != loc) {
		[loc retain];
		[locationConfirm release];
		locationConfirm = loc;
	}
	if (lblConfirm) {
		lblConfirm.text = locationConfirm;
		lblConfirm.textAlignment = NSTextAlignmentCenter;
		lblConfirm.frame = CGRectMake(0, 460-20 - 44, 320,20);
	}
}

//获取提示
-(BOOL) isOk{
	
	if ([Global GetInstance].lat<0.001&&[Global GetInstance].lng<0.001) {
		[Global messagebox:@"请开启“设置->通用->定位服务”中\r\n的相关选项。"];
		return NO;
	}
	return YES;
}

+(NSDate*)NSStringDateToNSDate:(NSString*)dateString{
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat: @"yyyyMMdd-HHmmss"];
	NSDate *dt = [formatter dateFromString:dateString];
	[formatter release];
	return dt;
}

+(NSString*)NSDateToNSString:(NSDate*)date{
	//private final static SimpleDateFormat debitSDF=new SimpleDateFormat("yyyyMMdd-HHmmss");
	//private final static SimpleDateFormat timecnSDF=new SimpleDateFormat("yyyy年MM月dd日HH时mm分");
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat: @"yyyy年MM月dd日HH时mm分"];//yyyy-MM-dd'T'HH:mm:ss
	NSString *dateString = [formatter stringFromDate:date ];
	[formatter release];
	return dateString;
}

+(NSString*)GetCurrentDate:(NSDate*)date{
	//得到毫秒
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateStyle:NSDateFormatterMediumStyle];
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	//[dateFormatter setDateFormat:@"hh:mm:ss"]
	[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
	//NSLog(@"Date%@", [dateFormatter stringFromDate:[NSDate date]]);
	NSString *currentdt = [dateFormatter stringFromDate:date];
	[dateFormatter release];
	return currentdt;
}

+(NSString*)GetGoodReviews:(int) good :(int)bad{
	if (good + bad >0) {
		int lv = (float)good/(good + bad) * 100;
		return [@"" stringByAppendingFormat:@"%d%@", lv,@"%"];
	}
	return @"0";
}

//取消键盘
+(void) cancelKeyBoard:(UIView*)view{
	NSArray *childs = view.subviews;
	
	for (int i = 0; i< [childs count]; i++) {
		UIView *tb = [childs objectAtIndex:i];	
		
		if ([tb isKindOfClass:[UITextField class]]) {
			[tb resignFirstResponder];
		}
		else {
			[self cancelKeyBoard:tb];
		}
	}
}

+(void) removeChilds:(UIView*)view{
	NSArray *arr = [view subviews];
	for (int i = 0; i<[arr count]; i++) {
		UIView *uv = [arr objectAtIndex:i];
		if (uv!=nil) {
			[uv removeFromSuperview];
		}
	}
}

+ (void)messagebox:(NSString*)string{
	UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" 
												  message:string 
												 delegate:self 
										cancelButtonTitle:@"好" 
										otherButtonTitles:nil ,
						nil];
	[ale show];
	[ale release];
}

+ (void)messagetoast:(NSString*)string target:(UIViewController*)pt{
	[Global GetInstance].targetView = pt.view;
	if (lblToast == nil) {
		lblToast = [[LableView alloc] initWithString:[@"      " stringByAppendingFormat:@"%@",string] FontSize:16];
		lblToast.textColor = [UIColor whiteColor];
		lblToast.backgroundColor = [UIColor blackColor];
		lblToast.alpha = 0.8;
		lblToast.layer.cornerRadius = 5;
		lblToast.layer.masksToBounds = YES;
		lblToast.opaque = NO;
		
	}
	[lblToast setText:[@"      " stringByAppendingFormat:@"%@",string]];
	
	CGRect frame = lblToast.frame;
	frame.size.width = frame.size.width + 20;
	frame.size.height = frame.size.height + 20;
	lblToast.frame = frame;
	
	frame.origin.x = (pt.view.frame.size.width - [lblToast getWidth])/2;
	frame.origin.y = (460 - 80 - 44 - [lblToast getHeigth]);
	frame.size.width = frame.size.width;
	frame.size.height = frame.size.height;
	
	if (vv == nil) {
		vv = [[UIView alloc] initWithFrame:frame];
		vv.tag = 888;
		[vv addSubview:lblToast];
		vv.layer.shadowColor = [UIColor blackColor].CGColor;
		vv.layer.shadowOffset = CGSizeMake(4, 4);
		vv.layer.shadowOpacity = 0.5; 
		vv.layer.shadowRadius = 2.0;
	}
	vv.frame = frame;
	
	[pt.view addSubview:vv];
	[self AlphaToOne:vv];
	
	if (timer != nil) {
		[timer invalidate];
		timer = nil;
	}
	
	timer=[NSTimer scheduledTimerWithTimeInterval:1.5f target:self selector:@selector(render:) userInfo:nil repeats:NO  ];
}

+(void) render:(id)sender{
//	NSTimer *timer = (NSTimer*)sender;
	[timer invalidate];
	timer = nil;
	
	if ([Global GetInstance].targetView == nil) {
		return;
	}
	UIView *view = [[Global GetInstance].targetView viewWithTag:888];
	if (view != nil) {
		//[view removeFromSuperview];
		[self AlphaToZero:view];
	}
}

- (void) messageboxdelegate:(NSString*)string Delegate:(id<AlertDelegate>)dg{
	UIAlertView *ale = [[UIAlertView alloc] initWithTitle:@"" 
												  message:string 
												 delegate:self 
										cancelButtonTitle:@"好" 
										otherButtonTitles:nil ,
						nil];
	[ale show];
	[ale release];
	alertDelegate = dg;
}

/**
 alpha 从0到1
 */
+(void) AlphaToOne:(UIView*)targetView
{
	targetView.hidden = NO;
	CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeInAnimation.duration = 0.5f;
	fadeInAnimation.removedOnCompletion = NO;
	fadeInAnimation.fillMode = kCAFillModeForwards;
	fadeInAnimation.fromValue = [NSNumber numberWithFloat:0.1f];
	fadeInAnimation.toValue = [NSNumber numberWithFloat:0.9f];
	fadeInAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[targetView.layer addAnimation:fadeInAnimation forKey:@"animateOpacity"];
	
}

/**
 alpha 从1到0
 */
+(void) AlphaToZero:(UIView*)targetView
{
	CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	fadeOutAnimation.delegate = self;
	fadeOutAnimation.duration = 0.5f;
	fadeOutAnimation.removedOnCompletion = NO;
	fadeOutAnimation.fillMode = kCAFillModeForwards;
	fadeOutAnimation.fromValue = [NSNumber numberWithFloat:0.9f];
	fadeOutAnimation.toValue = [NSNumber numberWithFloat:0.0f];
	fadeOutAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	[targetView.layer addAnimation:fadeOutAnimation forKey:@"animateOpacity"];
}

#pragma mark CABasicAnimation delegate methods
+ (void)animationDidStart:(CAAnimation *)anim{
	
}
+ (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
	if ([Global GetInstance].targetView == nil) {
		return;
	}
	UIView *view = [[Global GetInstance].targetView viewWithTag:888];
	if (view != nil) {
		[view removeFromSuperview];
	}
}
#pragma mark CABasicAnimation delegate methods end

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//确定
	if (buttonIndex == 0) {
		if (alertDelegate!=nil) {
			[alertDelegate alertCallBack:nil];
		}
	}
}

+(NSString*)intToString:(int)value{
	return [NSString stringWithFormat:@"%d",value];
}
+(NSString*)doubleToString:(double)value{
	return [NSString stringWithFormat:@"%f",value];
}
+(NSString*)floatToString:(float)value{
	return [NSString stringWithFormat:@"%f",value];
}
+(NSString*)formatMoney:(float)value{
	return [NSString stringWithFormat:@"¥%.2f",(value/100)];
}
+(NSString*)formatZfb:(float)value{
	return [NSString stringWithFormat:@"%.2f指付币",(value/100)];
}

//保存图片
-(void) savingImage:(NSString*)fileName Image:(UIImage*)image Type:(Document)type
{
	NSString *documentsDirectory = @"";
	if (type == DocumentsUser) {
		documentsDirectory = USERIMAGE;  //CACHES;
	}
	if (type == DocumentsReview) {
		documentsDirectory = REVIEWIMAGE;  //CACHES;
	}
	if (type == DocumentsShanghu) {
		documentsDirectory = SHANGHUIMAGE;
	}
	if (type == DocumentsTyz) {
		documentsDirectory = TYZIMAGE;
	}
	if (type == DocumentsActive) {
		documentsDirectory = ACTIVEIMAGE;
	}
	
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	NSString *appFileName = [documentsDirectory stringByAppendingPathComponent:[self getSubFilePath:fileName]];
	if([[NSFileManager defaultManager] fileExistsAtPath:appFileName])
	{
		[[NSFileManager defaultManager] removeItemAtPath:appFileName error:nil];
	}
	
	NSString *sub = [[fileName copy] autorelease];
	if ([sub length]>4) {
		sub = [fileName substringFromIndex:[sub length]-4];
		if ([sub isEqualToString:@".jpg"]) {
			NSData *imagesmallData = UIImageJPEGRepresentation(image,1.0f);
			[imagesmallData writeToFile:appFileName atomically:YES];
		}
		else {
			NSData *imagesmallData = UIImagePNGRepresentation(image);
			[imagesmallData writeToFile:appFileName atomically:YES];
		}
	}
	NSData *imagesmallData = UIImageJPEGRepresentation(image,1.0f);
	[imagesmallData writeToFile:appFileName atomically:YES];
}

+(NSString*) getFileSize:(NSString*)folderPath{
	float fileSize = 0;
	NSArray *contents; 
    NSEnumerator *enumerator; 
    NSString *path; 
    contents = [[NSFileManager defaultManager] subpathsAtPath:folderPath]; 
    enumerator = [contents objectEnumerator]; 

    while (path = [enumerator nextObject]) { 
		NSError *err = nil;
		NSDictionary *fattrib = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:path] error:&err];
		fileSize +=[fattrib fileSize]; 
    } 
	fileSize = fileSize/1024;
	fileSize = fileSize/1024;
	return [@"" stringByAppendingFormat:@"%.2fM",fileSize];
}

+(NSString*) deleteFiles:(NSString*)folderPath{
	if([[NSFileManager defaultManager] fileExistsAtPath:folderPath])
	{
		[[NSFileManager defaultManager] removeItemAtPath:folderPath error:nil];
		return @"清理成功";
	}
	return @"已清理";
}

//-(void)getFileAttributes
//{
//	NSFileManager *fileManager = [NSFileManager defaultManager];
//	NSString *path = @"/1ct.rtf";
//	NSDictionary *fileAttributes = [fileManager fileAttributesAtPath:path traverseLink:YES];
//    NSLog(@"@@");
//	if (fileAttributes != nil) {
//		NSNumber *fileSize;
//		NSString *fileOwner, *creationDate;
//		NSDate *fileModDate;
//		//NSString *NSFileCreationDate
//		
//		//文件大小
//		if (fileSize = [fileAttributes objectForKey:NSFileSize]) {
//			NSLog(@"File size: %qi\n", [fileSize unsignedLongLongValue]);
//		}
//		
//		//文件创建日期
//		if (creationDate = [fileAttributes objectForKey:NSFileCreationDate]) {
//			NSLog(@"File creationDate: %@\n", creationDate);
//			//textField.text=NSFileCreationDate;
//		}
//		
//		//文件所有者
//		if (fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName]) {
//			NSLog(@"Owner: %@\n", fileOwner);
//		}
//		
//		//文件修改日期
//		if (fileModDate = [fileAttributes objectForKey:NSFileModificationDate]) {
//			NSLog(@"Modification date: %@\n", fileModDate);
//		}
//	}
//	else {
//		NSLog(@"Path (%@) is invalid.", path);
//	}
//}



//取得图片
-(UIImage*) getDiskImage:(NSString*)fileName Type:(Document)type
{
	NSString *documentsDirectory = @"";
	//说明是存用户的小图标
	if (type == DocumentsUser) {
		documentsDirectory = USERIMAGE;  //CACHES;
	}
	if (type == DocumentsReview) {
		documentsDirectory = REVIEWIMAGE;  //CACHES;
	}
	if (type == DocumentsShanghu) {
		documentsDirectory = SHANGHUIMAGE;
	}
	if (type == DocumentsTyz) {
		documentsDirectory = TYZIMAGE;
	}
	if (type == DocumentsActive) {
		documentsDirectory = ACTIVEIMAGE;
	}
	NSString *appFileName = [documentsDirectory stringByAppendingPathComponent:[self getSubFilePath:fileName]];
    if([[NSFileManager defaultManager] fileExistsAtPath:appFileName])
	{
		NSData *data = [[NSData alloc] initWithContentsOfFile:appFileName];
		UIImage *image = [[UIImage alloc] initWithData:data];
		[data release];
		return [image autorelease];
	} 
	return nil;
}
-(NSData*) getDiskNSData:(NSString*)fileName Type:(Document)type{
	NSString *documentsDirectory = @"";
	//说明是存用户的小图标
	if (type == DocumentsUser) {
		documentsDirectory = USERIMAGE;  //CACHES;
	}
	if (type == DocumentsReview) {
		documentsDirectory = REVIEWIMAGE;  //CACHES;
	}
	if (type == DocumentsShanghu) {
		documentsDirectory = SHANGHUIMAGE;
	}
	if (type == DocumentsTyz) {
		documentsDirectory = TYZIMAGE;
	}
	if (type == DocumentsActive) {
		documentsDirectory = ACTIVEIMAGE;
	}
	NSString *appFileName = [documentsDirectory stringByAppendingPathComponent:[self getSubFilePath:fileName]];
	if([[NSFileManager defaultManager] fileExistsAtPath:appFileName])
	{
		NSData *data = [[NSData alloc] initWithContentsOfFile:appFileName];
		return [data autorelease];
	} 
	return nil;	
}

//截取路径
-(NSString*) getSubFilePath:(NSString*)str{
	//Images/http:/192.168.1.17:9000/public/upload/2011/0812/599730_20110808_00493090.jpg
	NSString *url = [[str copy] autorelease];
//	int bb = [str hash];
//	NSString *aa = [url lastPathComponent];
//	NSRange strRange = [url rangeOfString:@"upload/"];
//	if (strRange.length>0) {
//		url = [url substringFromIndex:strRange.location];
//		url = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
//	}
	//url = [url stringByReplacingOccurrencesOfString:@"." withString:@"-"];
	url = [url stringByReplacingOccurrencesOfString:@":" withString:@"~"];
	url = [url stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return url;
}

+(NSString*) encodedUrlString:(NSString *)str{
	if (str == nil) {
		return @"";
	}
	return [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8) autorelease];
}

//执行失败
- (void)requestDidFailed:(ASIFormDataRequest *)request{
	if (request) 
	{
		//[request release];
	}
	[request.globalDelegate _requestFailed:request.processType];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//执行成功

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{	
	//关闭网络
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	if (request.globalDelegate) {
		[request.globalDelegate _requestSuccess:request.processType];
	}
	request.processType = -1;
}

//开始启动链接
-(void) requestDidStart:(ASIFormDataRequest*)request
{
	//设置网络活动
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	[request.globalDelegate _requestStart:request.processType];
}


-(void) requestGetDidStart:(ASIHTTPRequest*)request
{
	//设置网络活动
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	if (request.globalDelegate) {
		[request.globalDelegate _requestStart:request.processType];
	}
}

- (void)requestGetDidFailed:(ASIHTTPRequest *)request{
	
	//获取错误数据
	NSError *error = [request error];
	NSLog(@"!!!!!!!%@",error);
	if (request.globalDelegate) {
		[request.globalDelegate _requestFailed:request.processType];
	}
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//执行成功

- (void)requestGetDidSuccess:(ASIHTTPRequest *)request
{
	if (request.globalDelegate) {
		[request.globalDelegate _requestSuccess:request.processType];
	}
	//关闭网络
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


//执行成功函数

- (void)OARequestSuccessed:(NSString *)method withResponse:(NSString *)response WithData:(NSData *)data withHeaders:(NSDictionary *)headers
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];	
	NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
	//服务返回post后的数据
	NSLog(@"response:\n%@",responseStr);
}

//执行失败函数

- (void)OARequestFailed:(NSString *)method withError:(NSError *)error
{
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	NSLog(@"Error:%@",error);
	
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"网络连接失败, 请稍后重试." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
	[alert show];
	[alert release];
}


//根据文字大小来填充背景效果
- (UIView *)bubbleView:(NSString *)text Path:(NSString*)path{
	// build single chat bubble cell with given text
	UIView *returnView = [[UIView alloc] initWithFrame:CGRectZero];
	returnView.backgroundColor = [UIColor clearColor];	
	UIImage *bubble = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil]];
	UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:[bubble stretchableImageWithLeftCapWidth:0 topCapHeight:12]];
	UIFont *font = [UIFont systemFontOfSize:12];
	CGSize size = [text sizeWithFont:font constrainedToSize:CGSizeMake(247.0f, 1000.0f) lineBreakMode:UILineBreakModeCharacterWrap];
	UILabel *bubbleText = [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 20.0f, size.width, size.height)];
	bubbleText.backgroundColor = [UIColor clearColor];
	bubbleText.font = font;
	bubbleText.numberOfLines = 0;
	bubbleText.opaque = NO;
	bubbleText.lineBreakMode = UILineBreakModeCharacterWrap;
	bubbleText.text = text;
	bubbleImageView.frame = CGRectMake(0.0f, 0.0f, 262.0f, size.height+40.0f);
	returnView.frame = CGRectMake(20.0f, 10.0f, 262.0f, size.height+50.0f);
	[returnView addSubview:bubbleImageView];
	[bubbleImageView release];
	[returnView addSubview:bubbleText];
	[bubbleText release];
	return [returnView autorelease];
	
}
+ (UIImage*)resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize size = CGSizeMake(width, height);
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    else
        UIGraphicsBeginImageContext(size);
	
    CGContextRef context = UIGraphicsGetCurrentContext();
	
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
	
    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), image.CGImage);
	
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
	
    UIGraphicsEndImageContext();
	
    return imageOut;
}


+(UIImage*) getStaticImage:(NSString*)path{
	return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil]];;
}

-(void)drawRect:(CGRect)rect{
	CGContextRef ref=UIGraphicsGetCurrentContext();//拿到当前被准备好的画板。在这个画板上画就是在当前视图上画
	CGContextBeginPath(ref);//这里提到一个很重要的概念叫路径（path），其实就是告诉画板环境，我们要开始画了，你记下。
	CGContextMoveToPoint(ref, 160, 0);//画线需要我解释吗？不用了吧？就是两点确定一条直线了。
	CGContextAddLineToPoint(ref, 160,44);
	CGFloat redColor[4]={1.0,0,0,1.0};
	CGContextSetStrokeColor(ref, redColor);//设置了一下当前那个画笔的颜色。画笔啊！你记着我前面说的windows画图板吗？
	CGContextStrokePath(ref);//告诉画板，对我移动的路径用画笔画一下。
}

+(NSString *)md5:(NSString *)str { 
    const char *cStr = [str UTF8String]; 
    unsigned char result[32]; 
    CC_MD5( cStr, strlen(cStr), result ); 
    NSString *temp = [NSString stringWithFormat: 
                      @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                      result[0], result[1], result[2], result[3], 
                      result[4], result[5], result[6], result[7], 
                      result[8], result[9], result[10], result[11], 
                      result[12], result[13], result[14], result[15] 
                      ];
    return [temp lowercaseString]; 
}

@end

//
//  UploadData.m
//  LiveByTouch
//
//  Created by hao.li on 11-7-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UploadData.h"
#import "ASIFormDataRequest.h"
#import "Global.h"

@implementation UploadData

-(void) upload
{
	
	
//	//创建URL 请求  
//    NSURL *url = [NSURL URLWithString:@"aa"];  
//	
//    //发送上传请求  
//    ASIFormDataRequest   *  formRequset=[ASIFormDataRequest requestWithURL:url];  
//	
//    [formRequset setFile:[NSString  stringWithCString:"asdf"  encoding:NSUTF8StringEncoding]     
//                  forKey:@"face_file"];  
//	
//	
//    formRequset.delegate=self;  
//    [formRequset startSynchronous];  
//	
//    //提示是否上传成功  
//    if ([formRequset complete])   
//    {  
//        UIAlertView  *msgView=[[UIAlertView  alloc]   initWithTitle:@"系统提示" message:@"上传新头像成功" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];  
//        [msgView  autorelease];  
//        [msgView   show];  
//    }  
//    else   
//    {  
//        UIAlertView  *msgView=[[UIAlertView  alloc]   initWithTitle:@"系统提示" message:@"上传新头像失败，请稍后再试" delegate:nil cancelButtonTitle:@"关闭" otherButtonTitles:nil];  
//        [msgView  autorelease];  
//        [msgView   show];  
//    }  
	
	
	
	
	//开启iphone网络开关
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[NSURL URLWithString:@""]];
	//超时时间
	
	request.timeOutSeconds = 30;
	
	//定义异步方法
	
	[request setDelegate:self];
	[request setDidFailSelector:@selector(requestDidFailed:)];
	[request setDidFinishSelector:@selector(requestDidSuccess:)];
	
	
	//用户自定义数据   字典类型  （可选）
//	request.userInfo = [NSDictionary dictionaryWithObject:method forKey:@"Method"];
	//post的数据
	
//	[request appendPostData:[body dataUsingEncoding:NSUTF8StringEncoding]];
	
	//NSString *documentsDirectory = [DOCUMENTS_FOLDER stringByAppendingPathComponent:@"Downloads"];
	//NSString *appFileName = [documentsDirectory stringByAppendingPathComponent:HEADERNAME];
	
//	[request setFile:[NSString  stringWithCString:"asdf"  encoding:NSUTF8StringEncoding]     
//                  forKey:@"face_file"];  
	//[request setFile:appFileName  forKey:@"face_file"];  
	
	//开始执行
	
	[request startAsynchronous];
	
}


//执行成功

- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
	//获取头文件
//	NSDictionary *headers = [request responseHeaders];
	
	//获取http协议执行代码
	//NSLog(@"Code:%d",[request responseStatusCode]);
	
//	if ([delegate respondsToSelector:@selector(OARequestSuccessed:withResponse:WithData:withHeaders:)])
//	{
//		//执行委托操作  （架构设计   自选）
//		[delegate OARequestSuccessed:method withResponse:[request responseString] WithData:[request responseData] withHeaders:headers];
//		
//	}
	
	//清空
	if (request)
	{
		[request release];
	}
	
	//关闭网络
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}
	
	
	//执行失败
	
	- (void)requestDidFailed:(ASIFormDataRequest *)request{
		//获取的用户自定义内容
		//NSString *method = [request.userInfo objectForKey:@"Method"];
		//获取错误数据
		//NSError *error = [request error];
		
//		if ([delegate respondsToSelector:@selector(OARequestFailed:withError:)]) 
//		{
//			//执行委托 将错误数据传其他方式（架构设计   自选）
//			[delegate OARequestFailed:method withError:error];
//		}
//		
		if (request) 
		{
			[request release];
		}
		
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	
	//执行成功函数
	
	- (void)OARequestSuccessed:(NSString *)method withResponse:(NSString *)response WithData:(NSData *)data withHeaders:(NSDictionary *)headers
	{
		
		NSString *responseStr = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
		//服务返回post后的数据
		NSLog(@"response:\n%@",responseStr);
	}
	
	//执行失败函数
	
	- (void)OARequestFailed:(NSString *)method withError:(NSError *)error
	{
		
		NSLog(@"Error:%@",error);
		
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"出错了" message:@"网络连接失败, 请稍后重试." delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}

@end

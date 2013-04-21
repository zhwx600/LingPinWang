//
//  xmlparser.cpp
//  TinyXml
//
//  Created by user on 11-7-26.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#include "xmlparser.h"
#include "tinyxml.h"

#import "ProtocolDefine.h"
#import "Answer.h"
#import "RequestRegist.h"
#import "RequestLogin.h"

#import "ResultLogin.h"
#import "ResultLiPinDetail.h"
#import "ResultShangjiaDetail.h"

NSCondition             *_mutexEn = NULL;
NSCondition             *_mutexDe = NULL;



void xmlparser::Encode(S_Data *sData,string &xml)
{
	TTiXmlDocument doc; 
    if(!_mutexEn)
    {
       _mutexEn = [[NSCondition alloc] init];
    }
    [_mutexEn lock];
	TTiXmlDeclaration *decl = new TTiXmlDeclaration("1.0", "utf-8", ""); 
	doc.LinkEndChild( decl );
    
	TTiXmlElement *lmtRoot = new TTiXmlElement("command"); 
	doc.LinkEndChild(lmtRoot);
//    
//	TTiXmlElement *lmtId = new TTiXmlElement("id");
//	lmtRoot->LinkEndChild(lmtId);
//    if(sData->commandId.length() <= 0)
//    {
//        printf("sData->commandId.length() <= 0\n");
//        [_mutexEn unlock];
//        return;
//    }
//	TTiXmlText *txtId = new TTiXmlText(sData->commandId.c_str());
//	lmtId->LinkEndChild(txtId);
    
	TTiXmlElement *lmtName = new TTiXmlElement("name");
	lmtRoot->LinkEndChild(lmtName);
    if(sData->commandName.length() <= 0)
    {
        printf("sData->commandName.length() <= 0\n");
        [_mutexEn unlock];
        return;
    }
	TTiXmlText *txtName = new TTiXmlText(sData->commandName.c_str());
	lmtName->LinkEndChild(txtName);
//    
//	TTiXmlElement *lmtType = new TTiXmlElement("type");
//	lmtRoot->LinkEndChild(lmtType);
//    if(sData->type.length() <= 0)
//    {
//        printf("sData->type.length() <= 0\n");
//        [_mutexEn unlock];
//        return;
//    }    
//	TTiXmlText *txtType = new TTiXmlText(sData->type.c_str());
//	lmtType->LinkEndChild(txtType);
    
	TTiXmlElement *lmtParamRoot = new TTiXmlElement("params");
	lmtRoot->LinkEndChild(lmtParamRoot);
    
    map<string, string>::iterator iter;
    for(iter = sData->params.begin(); iter != sData->params.end(); iter++)
    {
		TTiXmlElement *lmtTmp = new TTiXmlElement("param");
		lmtParamRoot->LinkEndChild(lmtTmp);
        
		TTiXmlElement *lmtKey = new TTiXmlElement("key");
		lmtTmp->LinkEndChild(lmtKey);
		TTiXmlText *txtKey = new TTiXmlText(iter->first.c_str());
		lmtKey->LinkEndChild(txtKey);
        
		TTiXmlElement *lmtValue = new TTiXmlElement("value");
		lmtTmp->LinkEndChild(lmtValue);
		TTiXmlText *txtValue = new TTiXmlText(iter->second.c_str());
        
		lmtValue->LinkEndChild(txtValue);     
	}
	TiXmlPrinter printer;
    printer.SetStreamPrinting();
	doc.Accept(&printer);
    
	xml.assign(printer.CStr());
    [_mutexEn unlock];
    //	xml.a("%s",printer.CStr());
}

bool xmlparser::Decode(const char *xml,S_Data *sData)
{
	TTiXmlDocument doc;
    if(!_mutexDe)
    {
        _mutexDe = [[NSCondition alloc] init];
    }    
    [_mutexDe lock];
	if(doc.Parse(xml)==0)
	{
        printf("TTiXmlDocument parser error\n");
        [_mutexDe unlock];
		return false;
	}

	TTiXmlElement *lmtRoot = doc.RootElement();
	if(!lmtRoot)
    {
        [_mutexDe unlock];
		return false;
    }
	TTiXmlElement *lmtName = lmtRoot->FirstChildElement("name");
	if (lmtName)
	{
//		const char *id = lmtId->GetText();
//        //		sData->commandId = atoi(id);
//        sData->commandId.assign(id);
        
        const char *name = lmtName->GetText();
        sData->commandName.assign(name);

//		TTiXmlElement *lmtName = lmtId->NextSiblingElement("name");
//		if (lmtName)
//		{
//			const char *name = lmtName->GetText();
//			sData->commandName.assign(name);
//		}
        
//        
//		TTiXmlElement *lmtType = lmtName->NextSiblingElement("type");
//		if (lmtType)
//		{
//			const char *type = lmtType->GetText();
//			sData->type.assign(type);
//		}
        
		TTiXmlElement *lmtParamRoot = lmtName->NextSiblingElement("params");
		if (lmtParamRoot)
		{
            string strKey;
            string strValue;
			TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement();
			while (lmtTmp)
			{
				TTiXmlElement *lmtKey = lmtTmp->FirstChildElement("key");
				if (lmtKey)
				{
					TTiXmlElement *lmtValue = lmtKey->NextSiblingElement("value");
					if (lmtValue)
					{
						strKey.assign(lmtKey->GetText());
                        
						strValue.assign(lmtValue->GetText());
						strValue = strValue=="(null)"?"":strValue;
                        
                        sData->params[strKey]=strValue;
						//sData->params.insert(pair<string, string>(strKey,strValue));
                        
                        //NSLog(@"key=%s,value=%s",strKey.c_str(),strValue.c_str());
					}
				}
                
				lmtTmp = lmtTmp->NextSiblingElement();
//                printf("%s++++\n",sData->params.at(strKey).c_str());
//                NSLog(@"%s----size=%d",sData->params.at(strKey).c_str(),sData->params.size());
//                NSLog(@"%s****size=%d",sData->params[strKey.c_str()].c_str(),sData->params.size());
			}
		}
	}
    [_mutexDe unlock];
	return true;
}


@implementation MyXMLParser


+(void) encodeForRequestAnswer:(TTiXmlElement *) rootElement
{
//    TTiXmlElement *lmtParamRoot = new TTiXmlElement("234234234");
//    rootElement->LinkEndChild(lmtParamRoot);
    return;
}


+(void) encodeForRequestCode:(TTiXmlElement *) rootElement Obj:(NSObject*) requestObj
{
    TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestver");
    rootElement->LinkEndChild(lmtParamRoot);
    
    TTiXmlElement *lmtTmp = new TTiXmlElement("mobile");
    TTiXmlText *txtId = new TTiXmlText([(NSString*)requestObj UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    return;
}

+(void) encodeForRequestRegist:(TTiXmlElement *) rootElement Obj:(NSObject*) requestObj
{
    TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestver");
    rootElement->LinkEndChild(lmtParamRoot);
    
    RequestRegist*  registObj = (RequestRegist*) requestObj;
    
    TTiXmlElement *lmtTmp = new TTiXmlElement("mobile");
    TTiXmlText *txtId = new TTiXmlText([registObj.m_phone UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    lmtTmp = new TTiXmlElement("name");
    txtId = new TTiXmlText([registObj.m_name UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    lmtTmp = new TTiXmlElement("sex");
    txtId = new TTiXmlText([registObj.m_sex UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    lmtTmp = new TTiXmlElement("password");
    txtId = new TTiXmlText([registObj.m_password UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    
    for (NSString* key in [registObj.m_answerDic allKeys]) {
        
        lmtTmp = new TTiXmlElement("question");
        txtId = new TTiXmlText([key UTF8String]);
        lmtTmp->LinkEndChild(txtId);
        lmtParamRoot->LinkEndChild(lmtTmp);
        
        NSArray* valueArray = [registObj.m_answerDic valueForKey:key];
        NSString* valueStr = [valueArray componentsJoinedByString:OPTION_SPARETE_STR];
        
        lmtTmp = new TTiXmlElement("answer");
        if (valueStr && valueStr.length>0) {
        }else{
            valueStr = @"";
        }
        lmtTmp = new TTiXmlElement("answer");
        txtId = new TTiXmlText([valueStr UTF8String]);
        lmtTmp->LinkEndChild(txtId);
        lmtParamRoot->LinkEndChild(lmtTmp);
        
    }

    
    return;
}

+(void) encodeForRequestLogin:(TTiXmlElement *) rootElement Obj:(NSObject*) requestObj
{
    TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestver");
    rootElement->LinkEndChild(lmtParamRoot);
    
    RequestLogin* loginObj = (RequestLogin*)requestObj;
    
    TTiXmlElement *lmtTmp = new TTiXmlElement("logid");
    TTiXmlText *txtId = new TTiXmlText([loginObj.m_phone UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    
    lmtTmp = new TTiXmlElement("logpw");
    txtId = new TTiXmlText([loginObj.m_password UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    return;
}


+(void) encodeForRequestLiPinDetail:(TTiXmlElement *) rootElement Obj:(NSObject*) requestObj
{
    TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestver");
    rootElement->LinkEndChild(lmtParamRoot);
    
    NSString* proid = (NSString*)requestObj;
    
    TTiXmlElement *lmtTmp = new TTiXmlElement("productid");
    TTiXmlText *txtId = new TTiXmlText([proid UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);

    
    return;
}

+(void) encodeForRequestShangJiaDetail:(TTiXmlElement *) rootElement Obj:(NSObject*) requestObj
{
    TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestver");
    rootElement->LinkEndChild(lmtParamRoot);
    
    NSString* proid = (NSString*)requestObj;
    
    TTiXmlElement *lmtTmp = new TTiXmlElement("businesid");
    TTiXmlText *txtId = new TTiXmlText([proid UTF8String]);
    lmtTmp->LinkEndChild(txtId);
    lmtParamRoot->LinkEndChild(lmtTmp);
    
    
    return;
}


+(NSString*) EncodeToStr:(NSObject *)obj Type:(NSString *)type
{
    TTiXmlDocument doc; 
    if(!_mutexEn)
    {
        _mutexEn = [[NSCondition alloc] init];
    }
    [_mutexEn lock];
	TTiXmlDeclaration *decl = new TTiXmlDeclaration("1.0", "utf-8", ""); 
	doc.LinkEndChild( decl );
    
	TTiXmlElement *lmtRoot = new TTiXmlElement("command"); 
	doc.LinkEndChild(lmtRoot);
    
    TTiXmlElement *lmtName = new TTiXmlElement("commandid");
    lmtRoot->LinkEndChild(lmtName);
    if(type.length <= 0)
    {
        printf("type <= 0\n");
        [_mutexEn unlock];
        return nil;
    }
    TTiXmlText *txtId = new TTiXmlText([type UTF8String]);
    lmtName->LinkEndChild(txtId);
    
    //版本表
    if (0 == [type compare:REQUEST_FOR_ANSWER]) {
        
        [MyXMLParser encodeForRequestAnswer:lmtRoot];
    //获取验证码
    }else if(0 == [type compare:REQUEST_FOR_CODE]){
        
        [MyXMLParser encodeForRequestCode:lmtRoot Obj:obj];
    // 注册
    }else if(0 == [type compare:REQUEST_FOR_REGIST]){
        [MyXMLParser encodeForRequestRegist:lmtRoot Obj:obj];
        
    }else if(0 == [type compare:REQUEST_FOR_LOGIN]){
        [MyXMLParser encodeForRequestLogin:lmtRoot Obj:obj];
    }else if(0 == [type compare:REQUEST_FOR_PRODUCT_DETAIL]){
        [MyXMLParser encodeForRequestLiPinDetail:lmtRoot Obj:obj];
    }else if(0 == [type compare:REQUEST_FOR_BUSINESS_DETAIL]){
        [MyXMLParser encodeForRequestShangJiaDetail:lmtRoot Obj:obj];
    }
    
    
    //参展
//    else if(0 == [type compare:@"ihshow"]){
//        TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestshow");
//        lmtRoot->LinkEndChild(lmtParamRoot);
//        TTiXmlElement *lmtTmp = new TTiXmlElement("showid");
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        NSArray* temArr = (NSArray*)obj;
//        NSMutableString* temStr = [[NSMutableString alloc] init];
//        
//        if (!temArr || temArr.count <= 0) {
//            [temStr appendString:@"0=0"];
//        }
//        
//        for (int i=0; i<temArr.count; i++) {
//            
//            CanZhanTableObj* proobj = [temArr objectAtIndex:i];
//            
//            [temStr appendFormat:@"%@=%@",proobj.m_canzhanId,proobj.m_versionId];
//            if (i < temArr.count-1) {
//                [temStr appendString:@";"];
//            }
//        }
//        
//        TTiXmlText *txtId = new TTiXmlText([temStr UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        [temStr release];
//        //展位预约咨询
//    }else if(0 == [type compare:@"zwinquiry"]){
//        
//        ZiXunYuYueRequestObj* temObj = (ZiXunYuYueRequestObj*)obj;
//        
//        TTiXmlElement *lmtParamRoot = new TTiXmlElement("requestquiry");
//        lmtRoot->LinkEndChild(lmtParamRoot);
//        
//        TTiXmlElement *lmtTmp = new TTiXmlElement("zwid");
//        TTiXmlText *txtId = new TTiXmlText([temObj.m_proId UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("company");
//        txtId = new TTiXmlText([temObj.m_company UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("country");
//        txtId = new TTiXmlText([temObj.m_country UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("name");
//        txtId = new TTiXmlText([temObj.m_name UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("tel");
//        txtId = new TTiXmlText([temObj.m_tel UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("email");
//        txtId = new TTiXmlText([temObj.m_email UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("todate");
//        txtId = new TTiXmlText([temObj.m_todate UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        
//        lmtTmp = new TTiXmlElement("description");
//        txtId = new TTiXmlText([temObj.m_description UTF8String]);
//        lmtTmp->LinkEndChild(txtId);
//        lmtParamRoot->LinkEndChild(lmtTmp);
//        //调查 请求
//    }


    
   	TiXmlPrinter printer;
    printer.SetStreamPrinting();
	doc.Accept(&printer);

    NSString* returnstr = [[[NSString alloc] initWithCString:printer.CStr() encoding:NSUTF8StringEncoding] autorelease];
    
    [_mutexEn unlock];

    return returnstr;
}

#pragma mark - 解析xml 相关

//问题 请求返回
+(NSMutableArray*) decodeForRequestAnswer:(TTiXmlElement *) rootElement
{
    NSMutableArray* imageArr = [[[NSMutableArray alloc] init] autorelease];
    
    TTiXmlElement *lmtParamRoot = rootElement->NextSiblingElement("requestver");
    
    if (lmtParamRoot)
    {
        
        TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement();
        while (lmtTmp)
        {
            Answer* imageObj = [[Answer alloc] init];
            
            TTiXmlElement *lmtKey = lmtTmp->FirstChildElement("caption");
            
            @try {
                NSArray*  capArr = [[NSString stringWithUTF8String:lmtKey->GetText()] componentsSeparatedByString:ID_VALUE_SPARETE_STR];
                imageObj.m_questionId = [[NSString alloc] initWithString:(NSString*) [capArr objectAtIndex:0]];
                imageObj.m_question = [[NSString alloc] initWithString:(NSString*) [capArr objectAtIndex:1]];
                
                
            }
            @catch (NSException *exception) {
                NSLog(@"imageObj.m_questionId = %@",exception);
            }
            //------------
            lmtKey = lmtTmp->FirstChildElement("type");
            imageObj.m_type = [[NSString alloc] initWithCString:lmtKey->GetText() encoding:NSUTF8StringEncoding];
            
            //------------
            lmtKey = lmtTmp->FirstChildElement("item");
            @try {
                NSArray*  itemArr = [[NSString stringWithUTF8String:lmtKey->GetText()] componentsSeparatedByString:OPTION_SPARETE_STR];
                
                
                for (int i=0; i<itemArr.count; i++) {
                    
                    NSArray*  temArr = [(NSString*)([itemArr objectAtIndex:i]) componentsSeparatedByString:ID_VALUE_SPARETE_STR];
                    [imageObj.m_answer setObject:[temArr objectAtIndex:1] forKey:[temArr objectAtIndex:0]];
                    [imageObj.m_keyArr addObject:[temArr objectAtIndex:0]];
                    
                }
                
            }
            @catch (NSException *exception) {
                NSLog(@"imageObj.m_answer = %@",exception);
            }

            //进入下一个 param
            lmtTmp = lmtTmp->NextSiblingElement();
            
            [imageArr addObject:imageObj];
            [imageObj release];
            
        }
    }
    return imageArr;

}

//验证码 返回
+(NSString*) decodeForRequestCode:(TTiXmlElement *) rootElement
{

    TTiXmlElement *lmtParamRoot = rootElement->NextSiblingElement("requestver");
    NSString* codeStr = nil;
    if (lmtParamRoot)
    {
        
        TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement();
        codeStr = [[[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] autorelease];

    }
    return codeStr;
    
}

//注册 返回
+(NSString*) decodeForRequestRegist:(TTiXmlElement *) rootElement
{
    
    TTiXmlElement *lmtParamRoot = rootElement->NextSiblingElement("requestver");
    NSString* registStr = nil;
    if (lmtParamRoot)
    {
        
        TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement();
        registStr = [[[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] autorelease];
        
    }
    return registStr;
    
}

//注册 返回
+(ResultLogin*) decodeForRequestLogin:(TTiXmlElement *) rootElement
{
    
    ResultLogin* resultLogin = [[[ResultLogin alloc] init] autorelease];
    
    TTiXmlElement *lmtParamRoot = rootElement->NextSiblingElement("requestver");
    
    if (lmtParamRoot)
    {
        
        TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement("complete");
        
        resultLogin.m_result = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("sessionno");
        resultLogin.m_sessionId = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("username");
        resultLogin.m_userName = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("usernum");
        resultLogin.m_linpinCount = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("userstate");
        resultLogin.m_userState = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("captionurl");
        resultLogin.m_userState = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("otherurl");
        [resultLogin.m_adImageUrlArrary addObjectsFromArray:[[NSString stringWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] componentsSeparatedByString:OPTION_SPARETE_STR]];
        
        lmtTmp = lmtParamRoot->FirstChildElement("otherurl2");
        [resultLogin.m_adToUrlArrary addObjectsFromArray:[[NSString stringWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] componentsSeparatedByString:OPTION_SPARETE_STR]];
    }
    return resultLogin;

    
}

//注册 返回
+(ResultLiPinDetail*) decodeForRequestLiPinDetail:(TTiXmlElement *) rootElement
{
    
    ResultLiPinDetail* resultDetail = [[[ResultLiPinDetail alloc] init] autorelease];
    
    TTiXmlElement *lmtParamRoot = rootElement->NextSiblingElement("requestver");
    
    if (lmtParamRoot)
    {
        
        TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement("productmemo");
        
        resultDetail.m_description = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
                
        lmtTmp = lmtParamRoot->FirstChildElement("imageurl");
        [resultDetail.m_imageUrlArrary addObjectsFromArray:[[NSString stringWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] componentsSeparatedByString:OPTION_SPARETE_STR]];
    }
    return resultDetail;
    
    
}


//注册 返回
+(ResultShangjiaDetail*) decodeForRequestShangJiaDetail:(TTiXmlElement *) rootElement
{
    
    ResultShangjiaDetail* resultDetail = [[[ResultShangjiaDetail alloc] init] autorelease];
    
    TTiXmlElement *lmtParamRoot = rootElement->NextSiblingElement("requestver");
    
    if (lmtParamRoot)
    {
        
        TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement("imageurl");
        [resultDetail.m_imageUrlArrary addObjectsFromArray:[[NSString stringWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] componentsSeparatedByString:OPTION_SPARETE_STR]];
        
        lmtTmp = lmtParamRoot->FirstChildElement("businestel");
        resultDetail.m_telephone = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("businesfax");
        resultDetail.m_fax = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("businesaddress");
        resultDetail.m_address = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        lmtTmp = lmtParamRoot->FirstChildElement("businesmemo");
        resultDetail.m_description = [[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding];
        
        
    }
    return resultDetail;
    
    
}



+(NSObject*) DecodeToObj:(NSString *)str
{
    TTiXmlDocument doc;
    if(!_mutexDe)
    {
        _mutexDe = [[NSCondition alloc] init];
    }
    [_mutexDe lock];
	if(doc.Parse([str UTF8String])==0)
	{
        printf("TTiXmlDocument parser error\n");
        [_mutexDe unlock];
		return nil;
	}
    
	TTiXmlElement *lmtRoot = doc.RootElement();
	if(!lmtRoot)
    {
        [_mutexDe unlock];
		return nil;
    }
	TTiXmlElement *lmtName = lmtRoot->FirstChildElement("commandid");
	if (lmtName)
	{
        const char *name = lmtName->GetText();
        NSString* commid = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        
        if (0 == [commid compare:@"version3"]) {
            TTiXmlElement *lmtParamRoot = lmtName->NextSiblingElement("requestver");
            TTiXmlElement *lmtTmp = lmtParamRoot->FirstChildElement();
            NSString* ver = [[[NSString alloc] initWithCString:lmtTmp->GetText() encoding:NSUTF8StringEncoding] autorelease];
            [_mutexDe unlock];
            return ver;
            
            //参展请求 返回
        }else if(0 == [commid compare:REQUEST_FOR_ANSWER]){
            
            NSMutableArray* imageArr = [MyXMLParser decodeForRequestAnswer:lmtName];

            [_mutexDe unlock];
            return imageArr;
        }else if(0 == [commid compare:REQUEST_FOR_CODE]){
            
            NSString* codeArr = [MyXMLParser decodeForRequestCode:lmtName];
            
            [_mutexDe unlock];
            return codeArr;
        }else if(0 == [commid compare:REQUEST_FOR_REGIST]){
            
            NSString* registArr = [MyXMLParser decodeForRequestRegist:lmtName];
            
            [_mutexDe unlock];
            return registArr;
        }

        
    }

    
    [_mutexDe unlock];
    return  nil;
}

@end











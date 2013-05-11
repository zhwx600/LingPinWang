//
//  ZhwxDefine.h
//  LingPinWang
//
//  Created by zhwx on 13-4-22.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#ifndef LingPinWang_ZhwxDefine_h
#define LingPinWang_ZhwxDefine_h


//是否 iphone5
#define isRetina5inch (fabs(( double)[[ UIScreen mainScreen] bounds].size.height-( double )568) < DBL_EPSILON)

#define autoRetina5Frame(rect5,rect4) isRetina5inch ? rect5:rect4


//设备全屏
#define DEV_FULLSCREEN_FRAME [[ UIScreen mainScreen] bounds]
#pragma mark- 设备竖屏

//横屏竖屏
#define DEV_FULLSCREEN_Vertical_FOR_4_FRAME CGRectMake(0, 0, 320, 480)
#define DEV_FULLSCREEN_Vertical_FOR_5_FRAME CGRectMake(0, 0, 320, 568)

//无nav 和 无状态栏  frame
#define DEV_NO_NAV_VIEW_FRAME CGRectMake(0, 0, DEV_FULLSCREEN_FRAME.size.width, DEV_FULLSCREEN_FRAME.size.height-20)
//有nav 和 无状态栏  frame
#define DEV_HAVE_NAV_VIEW_FRAME CGRectMake(0, 0, 320, DEV_FULLSCREEN_FRAME.size.height-44-20)
//有nav 、有table、 无状态栏  frame
#define DEV_HAVE_TABLE_VIEW_FRAME CGRectMake(0, 0, 320, DEV_FULLSCREEN_FRAME.size.height-44-49-20)

#pragma mark- 设备横屏
//横屏全屏
#define DEV_FULLSCREEN_Horizontal_FOR_4_FRAME CGRectMake(0, 0, 480, 320)
#define DEV_FULLSCREEN_Horizontal_FOR_5_FRAME CGRectMake(0, 0, 568, 320)



//无nav 和 无状态栏  frame
#define DEV_NO_NAV_VIEW_Horizontal_FRAME CGRectMake(0, 0, DEV_FULLSCREEN_FRAME.size.width, DEV_FULLSCREEN_FRAME.size.height-20)
//有nav 和 无状态栏  frame
#define DEV_HAVE_NAV_VIEW_Horizontal_FRAME CGRectMake(0, 0, DEV_FULLSCREEN_FRAME.size.width, DEV_FULLSCREEN_FRAME.size.height-44-20)
//有nav 、有table、 无状态栏  frame
#define DEV_HAVE_TABLE_VIEW_Horizontal_FRAME CGRectMake(0, 0, DEV_FULLSCREEN_FRAME.size.width, DEV_FULLSCREEN_FRAME.size.height-44-49-20)





#endif

//
//  ZWXPageScrollView.h
//  LingPinWang
//
//  Created by zhwx on 13-5-5.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    INIT_SCROLL_PATH=0,//资源路径
    INIT_SCROLL_URL,//url 地址
} INIT_SCROLL_FLAG;

//按钮 点击委托
@protocol ZWXPageScrollDelegate <NSObject>


-(void) imageSelectWithButton:(UIButton*) button;

@end

@interface ZWXPageScrollView : UIView

@property (nonatomic,assign) BOOL m_buttonSelectEnable;//设置按钮 是否可以 点击。 默认为YES
@property (nonatomic,assign) BOOL m_autoScrollEnable;//设置 自动滑动

//****************初始化滑动翻页 view****************
//frame：view 大小
//list：图片资源 或 url 数组
//flag：加载方式
//deleagate：按钮选择的委托对象
//return:对象本身
- (id)initWithFrame:(CGRect) frame PathList:(NSArray*) list Flag:(INIT_SCROLL_FLAG) flag Delegate:(id<ZWXPageScrollDelegate>) deleagate;



@end



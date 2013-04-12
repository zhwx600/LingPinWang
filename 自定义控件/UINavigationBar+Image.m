//
//  UINavigationBar+Image.m
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "UINavigationBar+Image.h"

@implementation UINavigationBar (Image)

UIImageView *backgroundView;
-(void)setBackgroundImage:(UIImage*)image
{
    //self.tintColor = [UIColor clearColor];
    
    if(image == nil)
    {
        [backgroundView removeFromSuperview];
    }
    else
    {
        if (backgroundView != nil)
        {
            // 这里remove的原因是，解决tab页来回切换，navagationItem.left和right按钮被背景图片遮挡
            [backgroundView removeFromSuperview];
        }
        
        backgroundView = [[UIImageView alloc] initWithImage:image];
        backgroundView.tag = 10;
        backgroundView.frame = CGRectMake(0.f, 0.f, 320, 44);
        //backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:backgroundView];
        [self sendSubviewToBack:backgroundView];
        [backgroundView release];
    }
}

//for other views
- (void)insertSubview:(UIView *)view atIndex:(NSInteger)index
{
    [super insertSubview:view atIndex:index];
    [self sendSubviewToBack:backgroundView];
}

-(void) drawRect:(CGRect)rect
{
    UIImage* image = [UIImage imageNamed:@"bgCartNavi.png"];
    [image drawInRect:CGRectMake(0, 0, 320, 44)];
}

@end

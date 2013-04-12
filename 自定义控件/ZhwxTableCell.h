//
//  ZhwxTableCell.h
//  LingPinWang
//
//  Created by apple on 13-4-12.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "EGOImageView.h"

@interface ZhwxTableCell : UITableViewCell
{
    
}

@property (nonatomic,readonly)UIImageView* m_imageView;
@property (nonatomic,readonly)UILabel* m_titleLabel;
@property (nonatomic,readonly)UILabel* m_desLabel;
- (void)setFlickrPhoto:(NSString*)flickrPhoto;

@end

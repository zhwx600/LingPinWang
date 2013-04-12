//
//  ZhwxTableCell.m
//  LingPinWang
//
//  Created by apple on 13-4-12.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxTableCell.h"

@implementation ZhwxTableCell
@synthesize m_desLabel;
@synthesize m_titleLabel;
@synthesize m_imageView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		m_imageView = [[UIImageView alloc] init];
		m_imageView.frame = CGRectMake(5.0f, 5.0f, 60.0f, 60.0f);
		[self.contentView addSubview:m_imageView];
        
        UIFont* temfont = [UIFont boldSystemFontOfSize:18];
        m_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 220, 25)];
        m_titleLabel.font = temfont;
        
        UIFont* temfont1 = [UIFont systemFontOfSize:14];
        m_desLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 220, 25)];
        m_titleLabel.font = temfont1;
        
        [self.contentView addSubview:m_titleLabel];
        [self.contentView addSubview:m_desLabel];
        
	}
	
    return self;
}



- (void)dealloc {
	[m_imageView release];
    [m_desLabel release];
    [m_titleLabel release];
    
    [super dealloc];
}


@end

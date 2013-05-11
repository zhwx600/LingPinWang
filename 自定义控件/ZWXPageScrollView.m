//
//  ZWXPageScrollView.m
//  LingPinWang
//
//  Created by zhwx on 13-5-5.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZWXPageScrollView.h"
#import "UIImageView+WebCache.h"

@interface ZWXPageScrollView()<UIScrollViewDelegate>

@property (retain,nonatomic) UIScrollView* m_scrollView;
@property (retain,nonatomic) UIPageControl* m_pageControl;

@property (retain,nonatomic) NSArray* m_imagePathList;
@property (assign,nonatomic) int m_initFlag;

@property (nonatomic,retain) NSMutableArray* m_imageViewList;
@property (nonatomic,retain) NSMutableArray* m_buttonList;

@property (nonatomic,assign) BOOL pageControlUsed;


@property (nonatomic,assign) id<ZWXPageScrollDelegate> m_delegate;

@end


@implementation ZWXPageScrollView


- (id)initWithFrame:(CGRect) frame PathList:(NSArray*) list Flag:(INIT_SCROLL_FLAG) flag Delegate:(id<ZWXPageScrollDelegate>) deleagate
{

    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.m_buttonSelectEnable = YES;
        
        CGRect tframe = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        //滑动控件
        self.m_scrollView = [[[UIScrollView alloc] initWithFrame:tframe] autorelease];
        [self.m_scrollView setBounces:NO];
        [self addSubview:self.m_scrollView];
        //翻页控件
        self.m_pageControl = [[[UIPageControl alloc] initWithFrame:CGRectMake(0, tframe.size.height-26, tframe.size.width, 36)] autorelease];
        [self.m_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.m_pageControl];
        
        //初始化参数
        self.m_imagePathList = [[[NSArray alloc] initWithArray:list] autorelease];
        self.m_initFlag = flag;
        self.m_delegate = deleagate;
        
        //初始化 imageview 和 button
        [self initButtonImageVieWithFrame:tframe];


    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


-(void) initButtonImageVieWithFrame:(CGRect)frame
{
    
    self.m_imageViewList = [[[NSMutableArray alloc] init] autorelease];
    self.m_buttonList = [[[NSMutableArray alloc] init] autorelease];

    for (int i=0; i<self.m_imagePathList.count; i++) {
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:frame];
        
        if (self.m_initFlag == INIT_SCROLL_PATH) {
            [imageView setImage:[UIImage imageNamed:[self.m_imagePathList objectAtIndex:i]]];
        }else{
            [imageView setImageWithURL:[NSURL URLWithString:[self.m_imagePathList objectAtIndex:i]]
                      placeholderImage:[UIImage imageNamed:@"Default"]
                               options:(SDWebImageOptions)SDWebImageCacheMemoryOnly];
        }
        

        
        
//        if (i == 0) {
//            imageView.image = [UIImage imageNamed:@"领品网app_130225_07"];
//        }else
//        imageView.image = [UIImage imageNamed:@"领品网app_130225_27"];
        
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:frame];
        button.tag = i;
        [button addTarget:self.m_delegate action:@selector(imageSelectWithButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.m_buttonList addObject:button];
        [self.m_imageViewList addObject:imageView];
        [imageView release];
    }
    
    //初始化 加载
    
    self.m_scrollView.pagingEnabled = YES;
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * [self.m_imagePathList count], self.m_scrollView.frame.size.height);
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_scrollView.showsVerticalScrollIndicator = NO;
    self.m_scrollView.scrollsToTop = NO;
    self.m_scrollView.delegate = self;
    
    self.m_pageControl.numberOfPages = [self.m_imagePathList count];
    self.m_pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
}


- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= self.m_imagePathList.count)
        return;
    UIImageView* imageView = [self.m_imageViewList objectAtIndex:page];
    UIButton* button = [self.m_buttonList objectAtIndex:page];
    
    // add the controller's view to the scroll view
    if (imageView.superview == nil)
    {
        CGRect frame = self.m_scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        imageView.frame = frame;
        [self.m_scrollView addSubview:imageView];
        
        if (self.m_buttonSelectEnable) {
            [button setEnabled:YES];
        }else{
            [button setEnabled:NO];
        }
        
        [button setFrame:frame];
        [self.m_scrollView addSubview:button];

    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (self.pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.m_scrollView.frame.size.width;
    int page = floor((self.m_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.m_pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.pageControlUsed = NO;
}



- (IBAction)changePage:(id)sender
{
    
    int page = self.m_pageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = self.m_scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [self.m_scrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    self.pageControlUsed = YES;
    
}

-(void) setM_buttonSelectEnable:(BOOL)m_buttonSelectEnable
{
    _m_buttonSelectEnable = m_buttonSelectEnable;
    if (m_buttonSelectEnable) {
        for (int i=0;i<self.m_buttonList.count; i++) {
            UIButton* button = [self.m_buttonList objectAtIndex:i];
            [button setEnabled:YES];
        }
    }else{
        
        for (int i=0; i<self.m_buttonList.count; i++) {
            UIButton* button = [self.m_buttonList objectAtIndex:i];
            [button setEnabled:NO];
        }
    }
}


-(void) dealloc
{
    self.m_scrollView = nil;
    [self.m_buttonList removeAllObjects];
    self.m_buttonList = nil;
    [self.m_imageViewList removeAllObjects];
    self.m_imagePathList = nil;
    self.m_imagePathList = nil;
    self.m_pageControl = nil;
    
    [super dealloc];
}




@end

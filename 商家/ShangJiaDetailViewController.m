//
//  ShangJiaDetailViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ShangJiaDetailViewController.h"
#import "UIImageView+WebCache.h"

#import "Utilities.h"

@interface ShangJiaDetailViewController ()

@end

@implementation ShangJiaDetailViewController
@synthesize m_imageUrlList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        m_imageUrlList = [[NSMutableArray alloc] initWithObjects:
                    @"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120509154705",
                    @"http://static2.dmcdn.net/static/video/629/228/44822926:jpeg_preview_small.jpg?20120509181018",
                    @"http://static2.dmcdn.net/static/video/116/367/44763611:jpeg_preview_small.jpg?20120509101749",
                    @"http://static2.dmcdn.net/static/video/666/645/43546666:jpeg_preview_small.jpg?20120412153140",
                    @"http://static2.dmcdn.net/static/video/771/577/44775177:jpeg_preview_small.jpg?20120509183230",
                          nil];
        imageCount = m_imageUrlList.count;
        [self initImageViewForShangJia];
        
        self.navigationItem.leftBarButtonItem = [Utilities createNavItemByTarget:self Sel:@selector(closeBtnAction:) Imgage:[UIImage imageNamed:@"item_back.png"]];

       // [self initParamScrollView:m_imageUrlList];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // a page is the width of the scroll view
    self.m_scrollView.pagingEnabled = YES;
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * imageCount, self.m_scrollView.frame.size.height);
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_scrollView.showsVerticalScrollIndicator = NO;
    self.m_scrollView.scrollsToTop = NO;
    self.m_scrollView.delegate = self;
    
    self.m_pageControl.numberOfPages = imageCount;
    self.m_pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    [self initParamScrollView:m_imageUrlList];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_m_scrollView release];
    [_m_pageControl release];
    [_m_desTextView release];
    
    [m_imageUrlList release];
    
    [_m_moreScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [self setM_pageControl:nil];
    [self setM_desTextView:nil];
    [self setM_moreScrollView:nil];
    [super viewDidUnload];
}

-(void) closeBtnAction:(id) sender
{
    
    
    [super closeBtnAction:sender];
}


-(void) initImageViewForLiPin
{
    viewArr = [[NSMutableArray alloc] init];
    
    @try {
        imageCount = m_imageUrlList.count;
        
        for (unsigned i = 0; i < imageCount; i++)
        {
            
            UIImageView* wwView = [[UIImageView alloc] initWithFrame:self.m_scrollView.frame];
            
            [wwView setImageWithURL:[NSURL URLWithString:[m_imageUrlList objectAtIndex:i]]
                   placeholderImage:[UIImage imageNamed:@"Default"] options:SDWebImageRefreshCached];
            wwView.tag = i;
            [viewArr addObject:wwView];
            [wwView release];
            
            // self.m_desTextView.text = imageobj.m_imageDescription;
            
        }
        
        
    }
    @catch (NSException *exception) {
        imageCount = 0;
        NSLog(@"加载 异常 发布");
    }
    @finally {
        
    }

}

-(void) initImageViewForShangJia
{
    viewArr = [[NSMutableArray alloc] init];
    
    @try {
        imageCount = m_imageUrlList.count;
        
        for (unsigned i = 0; i < imageCount; i++)
        {

            UIImageView* wwView = [[UIImageView alloc] initWithFrame:self.m_scrollView.frame];
            
            [wwView setImageWithURL:[NSURL URLWithString:[m_imageUrlList objectAtIndex:i]]
                   placeholderImage:[UIImage imageNamed:@"Default"] options:SDWebImageRefreshCached];
            wwView.tag = i;
            [viewArr addObject:wwView];
            [wwView release];
            
            // self.m_desTextView.text = imageobj.m_imageDescription;
            
        }
        
        
    }
    @catch (NSException *exception) {
        imageCount = 0;
        NSLog(@"加载 异常 发布");
    }
    @finally {
        
    }
    
}


-(void) initParamScrollView:(NSArray*) arr
{
    
    int startVerOff = 220;
    
    for (int i=0; i<arr.count; i++) {
        
        NSString* textstr = [arr objectAtIndex:i];
        UIFont *font =  [UIFont fontWithName:@"Helvetica" size:15.0f];
        CGSize size = [textstr sizeWithFont:font constrainedToSize:CGSizeMake(278, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(21, startVerOff, size.width, size.height)];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentLeft;
        label.font = [UIFont fontWithName:@"Helvetica" size:15.0f];
        label.textColor = [UIColor blackColor];
        [label setNumberOfLines:0];
        [label setLineBreakMode:UILineBreakModeWordWrap];
        
        label.text = textstr;
        [self.m_moreScrollView addSubview:label];
        [label release];
        
        startVerOff += size.height + 9;
        
        NSLog(@"nitParamScrollView: %@",[arr objectAtIndex:i]);
    }
    [self.m_moreScrollView setContentSize:CGSizeMake(0, startVerOff)];
    [self.m_moreScrollView setFrame:DEV_HAVE_TABLE_VIEW_FRAME];

    
}




#pragma mark - 加载滑动图片 相关
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= imageCount)
        return;
    
    // replace the placeholder if necessary
    UIImageView* temview = [viewArr objectAtIndex:page];
    // add the controller's view to the scroll view
    if (temview.superview == nil)
    {
        CGRect frame = self.m_scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        temview.frame = frame;
        [self.m_scrollView addSubview:temview];
        //
        //        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        //        controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
        //        controller.numberTitle.text = [numberItem valueForKey:NameKey];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.m_scrollView.frame.size.width;
    
    
    //下取整
    int page = floor((self.m_scrollView.contentOffset.x + pageWidth / 2) / pageWidth);
    self.m_pageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    NSLog(@"contentOffset = %f, page = %d",self.m_scrollView.contentOffset.x,page);
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}


@end

//
//  RegistViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistCommitViewController.h"

#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"

@interface RegistViewController ()

@end

@implementation RegistViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"注册";
        [self addMyNavBar];
        [self addRightButton:@selector(tiaoguoButton:) Title:@"跳过"];
        [self setNavTitle:@"注册"];
        
        viewArr = [[NSMutableArray alloc] init];
        m_tableViewCount = 6;
        [self inittableView];
        
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self requestQuestion];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
    // a page is the width of the scroll view
    self.m_scrollView.pagingEnabled = YES;
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * m_tableViewCount, self.m_scrollView.frame.size.height);
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_scrollView.showsVerticalScrollIndicator = NO;
    self.m_scrollView.scrollsToTop = NO;
    self.m_scrollView.delegate = self;
    
    self.m_pageControl.numberOfPages = m_tableViewCount;
    self.m_pageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    self.m_pageLabel.text = [NSString stringWithFormat:@"%d/%d",1,m_tableViewCount];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) closeBtnAction:(id)sender
{
    [super closeBtnAction:sender];

}

-(void) tiaoguoButton:(id) sender
{
    RegistCommitViewController* commitView = [[RegistCommitViewController alloc] init];
    [self.navigationController pushViewController:commitView animated:YES];
    [commitView release];
}


- (void)dealloc {
    [_m_scrollView release];
    [_m_pageControl release];
    [viewArr release];
    [m_questionArrDic release];
    [m_questionArrDic release];
    
    [_m_pageLabel release];
    [_previousButtonAct release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [self setM_pageControl:nil];
    [self setM_pageLabel:nil];
    [self setPreviousButtonAct:nil];
    [super viewDidUnload];
}
- (IBAction)pageChangeAct:(id)sender
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
    pageControlUsed = YES;
}

-(void) inittableView
{
    
    for (int i=0; i<m_tableViewCount; i++) {
        UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, 285)];
        table.dataSource = self;
        table.delegate = self;
        
        [viewArr addObject:table];
        
        [table release];
        
    }
    
    
}


#pragma mark 加载
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= m_tableViewCount)
        return;
    
    // replace the placeholder if necessary
    UITableView* temview = [viewArr objectAtIndex:page];
    // add the controller's view to the scroll view
    if (temview.superview == nil)
    {
        CGRect frame = self.m_scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        temview.frame = frame;
        [self.m_scrollView addSubview:temview];
        [temview reloadData];
        //
        //        NSDictionary *numberItem = [self.contentList objectAtIndex:page];
        //        controller.numberImage.image = [UIImage imageNamed:[numberItem valueForKey:ImageKey]];
        //        controller.numberTitle.text = [numberItem valueForKey:NameKey];
    }
}

#pragma mark 滑动事件
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
//    if (sender != self.m_scrollView) {
//        return;
//    }
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
    self.m_pageLabel.text = [NSString stringWithFormat:@"%d/%d",page+1,m_tableViewCount];
    
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


#pragma mark tableView 事件
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"zhucecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%d 问题是？",arc4random()];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"%d  答案。",arc4random()];
    }

    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row > 0) {
        NSLog(@"选择了 答案");
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else{
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        
    }
    
    
}

- (IBAction)previousButtonAct:(id)sender
{
    int page = self.m_pageControl.currentPage-1;
	
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

}

- (IBAction)nextButtonAct:(id)sender {
    int page = self.m_pageControl.currentPage+1;
	
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

}



#pragma mark- 请求问题

//升级请求
-(void) requestQuestion
{

    NSString* str = [MyXMLParser EncodeToStr:nil Type:REQUEST_FOR_ANSWER];
    NSData* data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    HttpProcessor* http = [[HttpProcessor alloc] initWithBody:data main:self Sel:@selector(receiveDataByRequstQuestion:)];
    [http threadFunStart];
    
    [http release];
}

-(void) receiveDataByRequstQuestion:(NSData*) data
{
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

        NSMutableArray* registArr = [[NSMutableArray alloc] initWithArray:(NSArray*)[MyXMLParser DecodeToObj:str]];
        [str release];
        
        NSLog(@" regist arr count = %d",registArr.count);
        
    }else{
        NSLog(@"receiveDataByRequstQuestion 接收到 数据 异常");

        
    }

}

@end

//
//  RegistViewController.m
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "RegistViewController.h"
#import "RegistCommitViewController.h"

#import "Utilities.h"
#import "HttpProcessor.h"
#import "xmlparser.h"
#import "ProtocolDefine.h"

#import "Answer.h"

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
        //[self addRightButton:@selector(tiaoguoButton:) Title:@"跳过"];
        [self setNavTitle:@"注册"];
        
        [self.m_checkButton setHidden:YES];
        [self.m_nextButton setHidden:NO];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // a page is the width of the scroll view
    self.m_scrollView.pagingEnabled = YES;
    self.m_scrollView.showsHorizontalScrollIndicator = NO;
    self.m_scrollView.showsVerticalScrollIndicator = NO;
    self.m_scrollView.scrollsToTop = NO;
    self.m_scrollView.delegate = self;
    
    //    self.m_pageControl.numberOfPages = m_tableViewCount;
    //    self.m_pageControl.currentPage = 0;
    //
    //    // pages are created on demand
    //    // load the visible page
    //    // load the page on either side to avoid flashes when the user starts scrolling
    //    //
    //    [self loadScrollViewWithPage:0];
    //    [self loadScrollViewWithPage:1];
    //    self.m_pageLabel.text = [NSString stringWithFormat:@"%d/%d",1,m_tableViewCount];
    
    if (m_requestDataArray) {
        [m_requestDataArray release];
    }
    m_requestDataArray = nil;
    
    [self requestQuestion];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    
    
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
    if (![self checkSelectCount]) {
        return ;
    }
    
    RegistCommitViewController* commitView = [[RegistCommitViewController alloc] init];
    commitView.m_requestDataArray = m_requestDataArray;
    
    [self.navigationController pushViewController:commitView animated:YES];
    [commitView release];
}


- (void)dealloc {
    [_m_scrollView release];
    [_m_pageControl release];
    [viewArr release];
    [m_questionArrDic release];

    [_m_pageLabel release];
    [_previousButtonAct release];
    
    [m_requestDataArray release];
    
    [_m_checkButton release];
    [_m_nextButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_scrollView:nil];
    [self setM_pageControl:nil];
    [self setM_pageLabel:nil];
    [self setPreviousButtonAct:nil];
    [self setM_checkButton:nil];
    [self setM_nextButton:nil];
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
    
    if (viewArr) {
        [viewArr removeAllObjects];
        [viewArr release];
    }
    viewArr = nil;
    
    viewArr = [[NSMutableArray alloc] init];
    m_tableViewCount = m_requestDataArray.count;
    
    for (int i=0; i<m_tableViewCount; i++) {
        UITableView* table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 280, 285)];
        table.dataSource = self;
        table.delegate = self;
        
        [viewArr addObject:table];
        
        [table release];
        
    }
    
    self.m_scrollView.contentSize = CGSizeMake(self.m_scrollView.frame.size.width * m_tableViewCount, self.m_scrollView.frame.size.height);
    self.m_pageControl.numberOfPages = m_tableViewCount;
    self.m_pageControl.currentPage = 0;
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    self.m_pageLabel.text = [NSString stringWithFormat:@"%d/%d",1,m_tableViewCount];

    
}

-(BOOL) checkSelectCount
{
    
    for (int page=0; page<m_requestDataArray.count; page++) {
        
        Answer* temAnswer = (Answer*)[m_requestDataArray objectAtIndex:page];
        
        int minCount = temAnswer.m_min<=0 ?1:temAnswer.m_min;
        // int maxCount = temAnswer.m_max<=0 ?9999:temAnswer.m_max;
        int selectCount = 0;
        
        for (NSString* temKey in [temAnswer.m_answerSelect allKeys]) {
            
            NSString* selectValue = [temAnswer.m_answerSelect valueForKey:temKey];
            // 选中 答案
            if (0 == [selectValue compare:@"1"]) {
                selectCount ++;
            }
            
        }
        
        if (selectCount < minCount) {
            
            [Utilities ShowAlert:[NSString stringWithFormat:@"第【%d】题至少选择【%d】项！",page+1,minCount]];
            return NO;
            
        }
        

    }
    return YES;
        //
//    //多选题
//    if (0 == [temAnswer.m_type compare:@"1"]) {
//
//        
//        
//        
//        if (selectCount >= maxCount) {
//            
//            [Utilities ShowAlert:[NSString stringWithFormat:@"超过最大选项个数(%d)！",maxCount]];
//            return NO;
//        }
//        return YES;
//    }else{
//        
//        if (selectCount <= minCount) {
//            
//            [Utilities ShowAlert:[NSString stringWithFormat:@"至少选择%d项！",minCount]];
//            return NO;
//            
//        }
//    }

}


#pragma mark 加载
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= m_tableViewCount)
        return;
    
    if (self.m_pageControl.currentPage+1 >= m_requestDataArray.count) {
        
        [self.m_nextButton setHidden:YES];
        [self.m_checkButton setHidden:NO];
        
        //return;
    }else{
        [self.m_nextButton setHidden:NO];
        [self.m_checkButton setHidden:YES];
    }
    
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
    if (sender != self.m_scrollView) {
        return;
    }
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
    int index = [viewArr indexOfObject:tableView];
    if (m_requestDataArray && m_requestDataArray.count>0) {
        
        return ((Answer*)[m_requestDataArray objectAtIndex:index]).m_keyArr.count + 1;
        
    }
    
    return 0;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"zhucecell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    //table 的index
    int index = [viewArr indexOfObject:tableView];
    
    @try {
        if (indexPath.row == 0) {
            cell.textLabel.text = ((Answer*)[m_requestDataArray objectAtIndex:index]).m_question;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [cell.textLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [cell.textLabel setNumberOfLines:10];
            [cell.textLabel setFont:[UIFont boldSystemFontOfSize:17]];
        }else{
            
            NSString* key = [((Answer*)[m_requestDataArray objectAtIndex:index]).m_keyArr objectAtIndex:indexPath.row - 1];
            
            NSString* selectValue = [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect valueForKey:key];
            
            if (0 == [selectValue compare:@"1"]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }

            cell.textLabel.text = [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answer valueForKey:key];
            
            [cell.textLabel setLineBreakMode:NSLineBreakByCharWrapping];
            [cell.textLabel setNumberOfLines:10];
            
            [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
            
        }
    }
    @catch (NSException *exception) {
        cell.textLabel.text = @"";
    }


    

    return cell;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = [viewArr indexOfObject:tableView];
    NSString* type = ((Answer*)[m_requestDataArray objectAtIndex:index]).m_type;
    
    if (indexPath.row > 0) {
        NSLog(@"选择了 答案");

        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        
        NSString* key = [((Answer*)[m_requestDataArray objectAtIndex:index]).m_keyArr objectAtIndex:indexPath.row - 1];
        
        
        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        //已经选中的 再次点击
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect setValue:@"0" forKey:key];
            
        // 从未选中到 选中
        }else{
            
            
            
            //多选题
            if (0 == [type compare:@"1"]) {
                
                int maxCount = ((Answer*)[m_requestDataArray objectAtIndex:index]).m_max<=0 ?9999:((Answer*)[m_requestDataArray objectAtIndex:index]).m_max;
                int selectCount = 0;
                
                for (NSString* temKey in [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect allKeys]) {
                    
                    NSString* selectValue = [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect valueForKey:temKey];
                    // 选中 答案
                    if (0 == [selectValue compare:@"1"]) {
                        selectCount ++;
                    }

                }
                
                if (selectCount >= maxCount) {
                    
                    [Utilities ShowAlert:[NSString stringWithFormat:@"超过最大选项个数(%d)！",maxCount]];
                    
                }else{
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect setValue:@"1" forKey:key];
                }
                
            }else{
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                for (NSString* temKey in [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect allKeys]) {
                    
                    [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect setValue:@"0" forKey:temKey];
                    
                }
                
                [((Answer*)[m_requestDataArray objectAtIndex:index]).m_answerSelect setValue:@"1" forKey:key];
            }
            
        
            
        }
        
        [tableView reloadData];
        
        
    }else{
        
    }
    
    
}

- (IBAction)previousButtonAct:(id)sender
{
    [self.m_nextButton setHidden:NO];
    [self.m_checkButton setHidden:YES];
    
    
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
    
    if (self.m_pageControl.currentPage+1 >= m_requestDataArray.count) {
        
        [self.m_nextButton setHidden:YES];
        [self.m_checkButton setHidden:NO];
        
        //return;
    }
    
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
    
    if (m_requestDataArray) {
        [m_requestDataArray release];
    }
    m_requestDataArray = nil;
    
    if (data && data.length>0) {
        NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        m_requestDataArray = [[NSMutableArray alloc] initWithArray:(NSArray*)[MyXMLParser DecodeToObj:str]];
        [str release];
        
        NSLog(@" regist arr count = %d",m_requestDataArray.count);
        
    }else{
        NSLog(@"receiveDataByRequstQuestion 接收到 数据 异常");

        
    }
    
    [self performSelectorOnMainThread:@selector(inittableView) withObject:nil waitUntilDone:NO];

}

@end

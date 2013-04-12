//
//  ShangJiaViewController.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ShangJiaViewController.h"
#import "PullingRefreshTableView.h"
#import "ZhwxTableCell.h"
#import "UIImageView+WebCache.h"


@interface ShangJiaViewController () <
PullingRefreshTableViewDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property (retain,nonatomic) PullingRefreshTableView *tableView;
@property (retain,nonatomic) NSMutableArray *all_list;
@property (retain,nonatomic) NSMutableArray *list;
@property (nonatomic) BOOL refreshing;
@property (assign,nonatomic) NSInteger page;
@end

@implementation ShangJiaViewController
@synthesize tableView = _tableView;
@synthesize list = _list;
@synthesize refreshing = _refreshing;
@synthesize page = _page;
@synthesize all_list;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"商家";
        self.tabBarItem.image = [UIImage imageNamed:@"third"];
        
        
        CGRect bounds = self.view.bounds;
        bounds.size.height = [UIScreen mainScreen].bounds.size.height - 44-20-49;
        _tableView = [[PullingRefreshTableView alloc] initWithFrame:bounds pullingDelegate:self];
        _tableView.rowHeight = 70.0f;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.headerOnly = NO;
        [self.view addSubview:_tableView];
        self.page = 0;
        
        all_list = [[NSMutableArray alloc] initWithObjects:
                    @"http://static2.dmcdn.net/static/video/656/177/44771656:jpeg_preview_small.jpg?20120509154705",
                    @"http://static2.dmcdn.net/static/video/629/228/44822926:jpeg_preview_small.jpg?20120509181018",
                    @"http://static2.dmcdn.net/static/video/116/367/44763611:jpeg_preview_small.jpg?20120509101749",
                    @"http://static2.dmcdn.net/static/video/666/645/43546666:jpeg_preview_small.jpg?20120412153140",
                    @"http://static2.dmcdn.net/static/video/771/577/44775177:jpeg_preview_small.jpg?20120509183230",
                    @"http://static2.dmcdn.net/static/video/810/508/44805018:jpeg_preview_small.jpg?20120508125339",
                    @"http://static2.dmcdn.net/static/video/152/008/44800251:jpeg_preview_small.jpg?20120508103336",
                    @"http://static2.dmcdn.net/static/video/694/741/35147496:jpeg_preview_small.jpg?20120508111445",
                    @"http://static2.dmcdn.net/static/video/274/848/51848472:jpeg_preview_small.jpg?20121105222644",
                    @"http://static2.dmcdn.net/static/video/954/848/51848459:jpeg_preview_small.jpg?20121105222637",
                    @"http://static2.dmcdn.net/static/video/554/848/51848455:jpeg_preview_small.jpg?20121105222615",
                    @"http://static2.dmcdn.net/static/video/944/848/51848449:jpeg_preview_small.jpg?20121105222558",
                    @"http://static2.dmcdn.net/static/video/144/848/51848441:jpeg_preview_small.jpg?20121105222556",
                    @"http://static2.dmcdn.net/static/video/134/848/51848431:jpeg_preview_small.jpg?20121105222539",
                    @"http://static2.dmcdn.net/static/video/624/848/51848426:jpeg_preview_small.jpg?20121105222523",
                    @"http://static2.dmcdn.net/static/video/281/448/51844182:jpeg_preview_small.jpg?20121105222502",
                    @"http://static2.dmcdn.net/static/video/414/848/51848414:jpeg_preview_small.jpg?20121105222516",
                    @"http://static2.dmcdn.net/static/video/171/848/51848171:jpeg_preview_small.jpg?20121105223449",
                    @"http://static2.dmcdn.net/static/video/904/848/51848409:jpeg_preview_small.jpg?20121105222514",
                    @"http://static2.dmcdn.net/static/video/004/848/51848400:jpeg_preview_small.jpg?20121105222443",
                    @"http://static2.dmcdn.net/static/video/693/848/51848396:jpeg_preview_small.jpg?20121105222439",
                    @"http://static2.dmcdn.net/static/video/401/848/51848104:jpeg_preview_small.jpg?20121105222832",
                    @"http://static2.dmcdn.net/static/video/957/648/51846759:jpeg_preview_small.jpg?20121105223109",
                    @"http://static2.dmcdn.net/static/video/603/848/51848306:jpeg_preview_small.jpg?20121105222324",
                    @"http://static2.dmcdn.net/static/video/990/848/51848099:jpeg_preview_small.jpg?20121105222807",
                    @"http://static2.dmcdn.net/static/video/929/448/51844929:jpeg_preview_small.jpg?20121105222216",
                    @"http://static2.dmcdn.net/static/video/320/548/51845023:jpeg_preview_small.jpg?20121105222214",
                    nil];
        _list = [[NSMutableArray alloc] init];
        [SDWebImageManager.sharedManager.imageDownloader setValue:@"SDWebImage Demo" forHTTPHeaderField:@"AppName"];
        SDWebImageManager.sharedManager.imageDownloader.executionOrder = SDWebImageDownloaderLIFOExecutionOrder;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.page == 0) {
        [self.tableView launchRefreshing];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Your actions

- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

- (void)loadData{
    self.page++;
    if (self.refreshing) {
        self.page = 1;
        self.refreshing = NO;
        [self.list removeAllObjects];
    }
    
    int tatolcount = (all_list.count+10)/10;
    
    
    for (int i = (self.page-1)*10; i < (self.page)*10 && i<all_list.count; i++) {
        [self.list addObject:[all_list objectAtIndex:i]];
    }
    if (self.page > tatolcount) {
        [self.tableView tableViewDidFinishedLoadingWithMessage:@"全部加载完毕!"];
        self.tableView.reachedTheEnd  = YES;
    } else {
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd  = NO;
        [self.tableView reloadData];
    }
}

- (IBAction)segChanged:(UISegmentedControl *)sender{
    if (sender.selectedSegmentIndex == 1) {
        self.tableView.headerOnly = YES;
    } else {
        self.tableView.headerOnly = NO;
    }
}

#pragma mark - TableView*

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"_zhwxcell";
    ZhwxTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        cell = [[[ZhwxTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    
    cell.m_desLabel.text = [NSString stringWithFormat:@" des row =%d",indexPath.row];
    cell.m_titleLabel.text = [NSString stringWithFormat:@" m_titleLabel row =%d",indexPath.row];
    
    [cell.m_imageView setImageWithURL:[NSURL URLWithString:[self.list objectAtIndex:indexPath.row]]
                     placeholderImage:[UIImage imageNamed:@"Default"] options:indexPath.row == 0 ? SDWebImageRefreshCached : 0];
    
    return cell;
}

#pragma mark - PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    self.refreshing = YES;
    [self flushCache];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

- (NSDate *)pullingTableViewRefreshingFinishedDate{
    return [NSDate date];
}

- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [self performSelector:@selector(loadData) withObject:nil afterDelay:1.f];
}

#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}


@end

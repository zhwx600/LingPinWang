//
//  SheZhiViewController.m
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "SheZhiViewController.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"

#import "AboutMeViewController.h"
#import "ReplyViewController.h"

@interface SheZhiViewController ()

@end

@implementation SheZhiViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"设置";
        self.tabBarItem.image = [UIImage imageNamed:@"four"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerLogin:(id)sender
{
    AppDelegate* del = [[UIApplication sharedApplication] delegate];
    [del entryLoginControllerView];
}

- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDisk];
}

- (IBAction)clearImageLocalAct:(id)sender
{
    [self flushCache];
}


- (void)dealloc {
    [_m_cell0 release];
    [_m_cell1 release];
    [_m_cell2 release];
    [_m_cell3 release];
    [_m_cell4 release];
    [_m_cell5 release];
    [_m_tableView release];
    [_m_cell6 release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setM_cell0:nil];
    [self setM_cell1:nil];
    [self setM_cell2:nil];
    [self setM_cell3:nil];
    [self setM_cell4:nil];
    [self setM_cell5:nil];
    [self setM_tableView:nil];
    [self setM_cell6:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
//    switch (section) {
//        case 0:
//            return @"摄像头选择";
//            break;
//        case 1:
//            return @"画面设置";
//            break;
//        case 2:
//            return @"语音设置";
//            break;
//        case 3:
//            return @"节点信息";
//            break;
//        default:
//            break;
//    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    switch (section) {
        case 10:
            return 2;
            break;
        case 0:
            return 2;
            break;
            
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
            
        default:
            return 0;
            break;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
 	static NSString *kCellIdentifier = @"cellID";
	
    UITableViewCell *cell = nil;
    
    int section = indexPath.section;
    int row = indexPath.row;
/*    if (0 == section) {
        switch (row) {
            case 0:
                cell = self.m_cell0;
                cell.textLabel.text = @"绑定微博账号";
                break;
            case 1:
                cell = self.m_cell1;
                cell.textLabel.text = @"推送通知";
                break;
            default:
                break;
        }
    }else */if(0 == section){
        switch (row) {
            case 0:
                cell = self.m_cell2;
                cell.textLabel.text = @"关于我们";

                break;
//            case 1:
//                cell = self.m_cell3;
//                cell.textLabel.text = @"给我们一个好评";
//                //cell.selectedBackgroundView = [[UIImageView alloc] initWithFrame:cell.frame];
//                //cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
//                break;
            case 1:
                cell = self.m_cell4;
                cell.textLabel.text = @"意见反馈";
                //cell.selectedBackgroundView = [[UIImageView alloc] initWithFrame:cell.frame];
                //cell.selectedBackgroundView.backgroundColor = [UIColor redColor];
                break;
                
            default:
                break;
        }
        
    }else if(1 == section){
        
        switch (row) {
            case 0:
                cell = self.m_cell6;
                //cell.textLabel.text = @"注销登录";
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
            default:
                break;
        }
        cell.backgroundView = [[[UIImageView alloc] initWithFrame:cell.frame] autorelease];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        
        
    }else if(2 == section){
        
        switch (row) {
            case 0:
                cell = self.m_cell5;
                //cell.textLabel.text = @"注销登录";
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
            default:
                break;
        }
        //        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCartNavi.png"]];
        //        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCartNavi.png"]];
        
        cell.backgroundView = [[[UIImageView alloc] initWithFrame:cell.frame] autorelease];
        cell.backgroundView.backgroundColor = [UIColor clearColor];
        
        
        
    }
    
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    
	return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    int temsection = indexPath.section;
    int row = indexPath.row;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (temsection == 0) {
        
        if (0 == row) {
            AboutMeViewController* about = [[AboutMeViewController alloc] initWithNibName:SwitchWith(@"AboutMeViewController5",@"AboutMeViewController") bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
            [about release];
        }/*else if(1 == row){
            NSString* appstoreUrl=@"http://itunes.apple.com/us/app/shen-zhou-ying/id433835596?mt=8&uo=4";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrl]];
        }*/else{
            ReplyViewController* about = [[ReplyViewController alloc] initWithNibName:SwitchWith(@"ReplyViewController5",@"ReplyViewController") bundle:nil];
            [self.navigationController pushViewController:about animated:YES];
            [about release];
        }
        
        
        
    }else if(temsection == 1){
        
        
    }else if(temsection == 2){

    }else if(temsection == 3){
        
    }else if(temsection == 4){
        
    }
    
    
    
    
}



@end

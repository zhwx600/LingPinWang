//
//  SheZhiViewController.h
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

@interface SheZhiViewController : ZhwxBaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UITableView *m_tableView;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell0;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell1;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell2;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell3;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell4;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell5;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell6;

- (IBAction)registerLogin:(id)sender;
- (IBAction)clearImageLocalAct:(id)sender;
@end

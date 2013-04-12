//
//  SheZhiViewController.h
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SheZhiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UITableView *m_tableView;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell0;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell1;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell2;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell3;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell4;
@property (retain, nonatomic) IBOutlet UITableViewCell *m_cell5;

- (IBAction)registerLogin:(id)sender;
@end

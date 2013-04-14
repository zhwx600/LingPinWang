//
//  RegistCommitViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-14.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

@interface RegistCommitViewController : ZhwxBaseViewController<UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UITextField *m_phoneNumberField;
@property (retain, nonatomic) IBOutlet UITextField *m_codeField;
@property (retain, nonatomic) IBOutlet UITextField *m_passwordField;
@property (retain, nonatomic) IBOutlet UITextField *m_passwordSureField;
- (IBAction)m_passwordField:(id)sender;

- (IBAction)getCodeAct:(id)sender;
- (IBAction)registerButtonAct:(id)sender;

- (IBAction)closeInputView:(id)sender;
@end

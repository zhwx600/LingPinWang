//
//  ForgotPassViewController.h
//  LingPinWang
//
//  Created by zhwx on 13-4-13.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import "ZhwxBaseViewController.h"

@interface ForgotPassViewController : ZhwxBaseViewController<UITextFieldDelegate,UIAlertViewDelegate>


@property (retain, nonatomic) IBOutlet UITextField *m_phoneNumberField;
@property (retain, nonatomic) IBOutlet UITextField *m_codeField;


- (IBAction)close:(id)sender;
- (IBAction)getNewPassword:(id)sender;
- (IBAction)getCode:(id)sender;
- (IBAction)closeInput:(id)sender;
@end

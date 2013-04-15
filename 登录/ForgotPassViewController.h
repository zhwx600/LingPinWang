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

- (IBAction)close:(id)sender;
- (IBAction)getNewPassword:(id)sender;
@end

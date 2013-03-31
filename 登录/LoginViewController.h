//
//  LoginViewController.h
//  LingPinWang
//
//  Created by apple on 13-3-30.
//  Copyright (c) 2013年 领品网. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LoginViewController : UIViewController<UITextFieldDelegate>
{
    
}

@property (retain, nonatomic) IBOutlet UITextField *m_userNameField;
@property (retain, nonatomic) IBOutlet UITextField *m_passwordField;

- (IBAction)login:(id)sender;
- (IBAction)registerAct:(id)sender;
- (IBAction)getPasswordAct:(id)sender;
- (IBAction)savePasswordAct:(id)sender;

- (IBAction)cancelInputView:(id)sender;


@end

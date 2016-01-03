//
//  LoginPage.h
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"

@protocol MJSecondPopupDelegate;

@interface LoginPage : UIViewController <UITextFieldDelegate>

@property IBOutlet UIButton *login_btn;
@property IBOutlet UIButton *register_btn;
@property IBOutlet UIView *strok;
@property IBOutlet UIView *container;
@property IBOutlet UITextField *username;
@property UINavigationController *nv;
@property(weak, nonatomic) IBOutlet UITextField *Username_Input;

- (IBAction)send:(UIButton *)sender;
- (IBAction)Register:(UIButton *)sender;

@property NSUserDefaults *setting;
@property(assign, nonatomic) id <MJSecondPopupDelegate> delegate;

@end


@protocol MJSecondPopupDelegate <NSObject>
@optional
- (void)cancelButtonClicked:(LoginPage *)secondDetailViewController;
@end

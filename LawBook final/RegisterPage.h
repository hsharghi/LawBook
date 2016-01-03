//
//  RegisterPage.h
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+MJPopupViewController.h"
#import "ASIHTTPRequest.h"

#define iOSVersion UIDevice.currentDevice.systemVersion.floatValue

@class TPKeyboardAvoidingScrollView;


@interface RegisterPage : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate, ASIHTTPRequestDelegate, UITextFieldDelegate>
@property(weak, nonatomic) IBOutlet UITextField *Username;
@property(weak, nonatomic) IBOutlet UITextField *Email;
@property(weak, nonatomic) IBOutlet UITextField *Name;
@property(weak, nonatomic) IBOutlet UITextField *Family;
@property(weak, nonatomic) IBOutlet UITextField *Mobile;
@property(weak, nonatomic) IBOutlet UITextField *Field;
@property(weak, nonatomic) IBOutlet UITextField *Degree;
@property(weak, nonatomic) IBOutlet UITextField *City;
@property(weak, nonatomic) IBOutlet UITextField *Job;
@property(weak, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property(strong, nonatomic) UIImage *avatar;
@property(strong, nonatomic) UIPopoverController *popover;
@property(strong, nonatomic) UIImagePickerController *imagePicker;
@property(assign, nonatomic) BOOL viewProfile;
@property(assign, nonatomic) BOOL changingPhoto;


@property(nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scroll;

- (IBAction)Register:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;
- (IBAction)familyChanged:(id)sender;

@property NSUserDefaults *setting;

- (IBAction)selectProfilePicture:(id)sender;

@end


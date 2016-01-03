//
//  ViewProfile.h
//  LawBook
//
//  Created by Hadi Sharghi on ۱۳۹۴/۴/۱ .
//  Copyright (c) ۱۳۹۴ ه‍.ش. MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TPKeyboardAvoidingScrollView;

@interface ViewProfile : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, NSURLConnectionDataDelegate, NSURLConnectionDelegate>

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
@property(strong, nonatomic) UIImage *avatar;

@property(nonatomic, retain) IBOutlet TPKeyboardAvoidingScrollView *scroll;

- (IBAction)Register:(UIButton *)sender;

- (IBAction)back:(UIButton *)sender;

@property NSUserDefaults *setting;

- (IBAction)selectProfilePicture:(id)sender;


@end

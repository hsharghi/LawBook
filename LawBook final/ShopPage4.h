//
//  ShopPage4.h
//  LawBook final
//
//  Created by saeid1 on 12/4/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface ShopPage4 : UIViewController <UIAlertViewDelegate, MFMailComposeViewControllerDelegate>


@property(strong) IBOutlet UILabel *name2;
@property(strong) IBOutlet UIImageView *img;
@property(retain) IBOutlet UIImageView *actionbar;
@property(strong) IBOutlet UILabel *price;

@property int main_id_s4;
@property NSString *cost4;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

- (IBAction)payment:(UIButton *)sender;

@property IBOutlet UILabel *header;
@property NSString *hdr;
//
//- (void)payment_true;
//
//- (void)payment_back;
@end

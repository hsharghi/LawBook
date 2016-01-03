//
//  AboutPage.h
//  LawBook final
//
//  Created by saeid1 on 8/29/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutPage : UIViewController

// navigation button function

@property(weak, nonatomic) IBOutlet UIWebView *theWebView;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

- (IBAction)help:(UIButton *)sender;

- (IBAction)helplandscape:(UIButton *)sender;

- (IBAction)help_ipad:(UIButton *)sender;

- (IBAction)helplandscape_ipad:(UIButton *)sender;


@property(retain) IBOutlet UITextView *txt;
@property(retain) IBOutlet UIImageView *actionbar;
@end

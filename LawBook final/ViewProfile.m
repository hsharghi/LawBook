//
//  ViewProfile.m
//  LawBook
//
//  Created by Hadi Sharghi on ۱۳۹۴/۴/۱ .
//  Copyright (c) ۱۳۹۴ ه‍.ش. MultiPlatform. All rights reserved.
//

#import "ViewProfile.h"
#import "UIViewController+MJPopupViewController.h"
#import "MBProgressHUD.h"


@implementation ViewProfile


MBProgressHUD *hud;
NSString *loading_str;
NSString *error_str;

- (void)viewDidLoad {
    [super viewDidLoad];

    _setting = [NSUserDefaults standardUserDefaults];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];
}
@end

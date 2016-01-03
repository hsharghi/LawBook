//
//  HomePage.m
//  low book
//
//  Created by saeid1 on 8/26/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//
#import "ViewController.h"
#import "ChatPage1.h"
#import "AboutPage.h"
#import "ShopPage1.h"
#import "SearchPage.h"
#import "LibraryPage1.h"
#import "LoginPage.h"


#define IS_IPAD (( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) ? YES : NO)
#define IS_IPHONE_5 (([UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568)?YES:NO)
#define IS_RETINA_DISPLAY_DEVICE (([UIScreen mainScreen].scale == 2.f)?YES:NO)


@interface ViewController ()
@property NSInteger first;
@end

@implementation ViewController
NSUserDefaults *setting;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];



    // set kardane tanzimate font va mizane gerd shodane kenare haie action bar
    setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:@"20" forKey:@"fontsize"];
    [setting setObject:@"21" forKey:@"fontspace"];
    [setting setObject:@"5" forKey:@"actionbar"];

    _is_registered = [setting stringForKey:@"register"];


}

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
//-----------------------------------------------------------------------------

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------------------------------------------------------
- (IBAction)Chat:(UIButton *)sender {
    _is_registered = [setting stringForKey:@"register"];
    ChatPage1 *page;
    if ([_is_registered isEqualToString:@"1"]) {

        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            page = [[ChatPage1 alloc] initWithNibName:@"ChatPage1_Portrait" bundle:nil];
        }
        else {
            page = [[ChatPage1 alloc] initWithNibName:@"ChatPage1_Landscape" bundle:nil];
        }


        [self.navigationController pushViewController:page animated:YES];
    }
    else {

        LoginPage *detailViewController = [[LoginPage alloc] initWithNibName:@"LoginPage" bundle:nil];
        detailViewController.nv = self.navigationController;

        detailViewController.delegate = self;
        [self presentPopupViewController:detailViewController animationType:0];
    }
}


- (IBAction)Shop:(UIButton *)sender {
    ShopPage1 *page;
    _is_registered = [setting stringForKey:@"register"];
    if ([_is_registered isEqualToString:@"1"]) {
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            page = [[ShopPage1 alloc] initWithNibName:@"ShopPage1_Portrait" bundle:nil];
        }
        else {
            page = [[ShopPage1 alloc] initWithNibName:@"ShopPage1_Landscape" bundle:nil];
        }


        [self.navigationController pushViewController:page animated:YES];
    }
    else {
        LoginPage *detailViewController = [[LoginPage alloc] initWithNibName:@"LoginPage" bundle:nil];
        detailViewController.nv = self.navigationController;
        detailViewController.delegate = self;
        [self presentPopupViewController:detailViewController animationType:0];
    }


}


- (IBAction)About:(UIButton *)sender {


    AboutPage *page;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[AboutPage alloc] initWithNibName:@"AboutPage_Portrait" bundle:nil];
    }
    else {
        page = [[AboutPage alloc] initWithNibName:@"AboutPage_Landscape" bundle:nil];
    }

    [self.navigationController pushViewController:page animated:YES];
}


- (IBAction)Search:(UIButton *)sender {
    SearchPage *page;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[SearchPage alloc] initWithNibName:@"SearchPage_Portrait" bundle:nil];
    }
    else {
        page = [[SearchPage alloc] initWithNibName:@"SearchPage_Landscape" bundle:nil];
    }

    [self.navigationController pushViewController:page animated:YES];
}


- (IBAction)Library:(UIButton *)sender {
    LibraryPage1 *page;
    _is_registered = [setting stringForKey:@"register"];
    if ([_is_registered isEqualToString:@"1"]) {


        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            page = [[LibraryPage1 alloc] initWithNibName:@"LibraryPage1_Portrait" bundle:nil];
        }
        else {
            page = [[LibraryPage1 alloc] initWithNibName:@"LibraryPage1_Landscape" bundle:nil];
        }

        [self.navigationController pushViewController:page animated:YES];
    }
    else {

        LoginPage *detailViewController = [[LoginPage alloc] initWithNibName:@"LoginPage" bundle:nil];
        detailViewController.nv = self.navigationController;
        detailViewController.delegate = self;
        [self presentPopupViewController:detailViewController animationType:0];
    }

}


- (void)cancelButtonClicked:(LoginPage *)aSecondDetailViewController {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // avaz kardane halate portrait va lanscape
    [self updateLayoutForNewOrientation:self.interfaceOrientation];
}


// update kardane view dar zamane charkhesh
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {

    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}


// name xib e k baiad load shavad ra barmigardanad
- (NSString *)nibNameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // name xib landscape ya portrait o midahad
    NSString *postfix = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? @"Landscape" : @"Portrait";
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), postfix];
}

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation {

    
    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
}


@end

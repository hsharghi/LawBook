//
//  LoginPage.m
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "LoginPage.h"
#import "RegisterPage.h"
#import "MBProgressHUD.h"

@interface LoginPage ()

@end

@implementation LoginPage

@synthesize delegate;

MBProgressHUD *hud;
NSString *loading_str;
NSString *error_str;
NSString *ms;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    self.username.returnKeyType = UIReturnKeyDone;
    _setting = [NSUserDefaults standardUserDefaults];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


// raftan b safeie sabte nam
- (IBAction)Register:(UIButton *)sender {

    int movementDistance = -210; // tweak as needed

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    RegisterPage *page;
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown || orientation == UIDeviceOrientationUnknown || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationFaceUp) {
        page = [[RegisterPage alloc] initWithNibName:@"RegisterPage_Portrait" bundle:nil];
    }
    else {
        page = [[RegisterPage alloc] initWithNibName:@"RegisterPage_Landscape" bundle:nil];
    }

    [self.nv pushViewController:page animated:YES];


}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


// validate kardane field ha va ersale darkhast
- (IBAction)send:(UIButton *)sender {


    if ([self.Username_Input.text isEqual:@""]) {

        dispatch_async(dispatch_get_main_queue(), ^{


            NSString *message = @"فیلد خالی میباشد";
            UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:nil, nil];
            [toast show];

            int duration = 2; // duration in seconds

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                [toast dismissWithClickedButtonIndex:0 animated:YES];
            });
        });


    } else {


        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.labelText = loading_str;

        [self PostRequest];
    }
}


// ersale darkhast baraie login kardan
- (void)PostRequest {

    
    NSString *imei = [_setting valueForKey:@"imei"];
//    imei = @"iphonetest";
    NSString *temp = @"http://intelligent-book.ir/Account/CheckUsername1?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", _username.text];
//    NSString *temp2=[NSString stringWithFormat:@"%@%@%@%@%@", temp, @"IMEI=", @"iphonetest", @"&Username=", _username.text];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *url = [NSURL URLWithString:temp3];
    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   [self Error:@""];
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];

                                   [hud hide:YES];
                                   [hud removeFromSuperview];

                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   id imagePath = [[object objectForKey:@"Info"] objectForKey:@"image"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"104"]) {
                                       // vorod ba movafaqiat
                                       NSString *value = @"1";
                                       NSString *key = @"register";
                                       [_setting setObject:value forKey:key];
                                       [_setting synchronize];

                                       value = _username.text;
                                       key = @"username";
                                       [_setting setObject:value forKey:key];
                                       [_setting synchronize];

                                       value = imei;
                                       key = @"imei";

                                       [_setting setObject:value forKey:key];
                                       [_setting synchronize];
                                       
                                       // storing profile picture url into settings
                                       NSURL *imageURL;
                                       if (imagePath != [NSNull null]) {
                                           imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"http://intelligent-book.ir/%@",
                                                                             [(NSString *)imagePath substringFromIndex:6]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; }
                                       key = @"imageURL";
                                       [_setting setURL:imageURL forKey:key];
                                       [_setting synchronize];
                                       


                                       dispatch_async(dispatch_get_main_queue(), ^{


                                           NSString *message = @"وارد شدید";
                                           UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                           message:message
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:nil
                                                                                 otherButtonTitles:nil, nil];


                                           int duration = 1; // duration in seconds





                                           [toast show];

                                           [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [toast dismissWithClickedButtonIndex:0 animated:YES];

                                               [hud hide:YES];
                                               [hud removeFromSuperview];


                                               if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
                                                   [self.delegate cancelButtonClicked:self];
                                               }


                                           });
                                       });


                                       [hud hide:YES];
                                       [hud removeFromSuperview];
                                       dispatch_async(dispatch_get_main_queue(), ^{


                                           [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
                                       });


                                   }
                                   else
                                       [self Error:msg];
                               }
                           }
    ];
}

// agar karbar qablan sabtenam karde dobare baiad imei begirad

- (void)SendFirst {
//    NSString *imei = @"iphonetest";
//  this section is commented out for testing and should be remvoed before publish
    NSString *imei = _username.text;
    NSString *device = [[UIDevice currentDevice] model];
    NSString *sdk = [[UIDevice currentDevice] systemVersion];
    NSString *brand = @"Apple";
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    NSString *language = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSMutableString *resoulation = [[NSMutableString alloc] init];
    NSString *t1 = [@(screenSize.width) stringValue];
    NSString *t2 = [@(screenSize.height) stringValue];
    [resoulation appendString:t1];
    [resoulation appendString:@"*"];
    [resoulation appendString:t2];
    NSString *dencity = @"";
    NSString *densityDpi = @"";
    NSString *NetworkOperatorName = @"";
    //--------------------------------

    NSOperationQueue *queue = [[NSOperationQueue alloc] init];


    NSURL *url = [NSURL URLWithString:@"http://intelligent-book.ir/Account/FirstUsing"];
    NSDictionary *input = [[NSDictionary alloc] initWithObjectsAndKeys:
            NetworkOperatorName, @"NetworkOperatorName",
            dencity, @"density",
            densityDpi, @"densityDpi",
            resoulation, @"resoulation",
            brand, @"brand",
            device, @"device",
            sdk, @"sdk",
            imei, @"IMEI",
            language, @"language",
                    nil];

    NSError *error;
    NSData *jsonInput = [NSJSONSerialization dataWithJSONObject:input options:0 error:&error];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    [request setHTTPBody:jsonInput];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {

                                   [self Error:@""];

                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:NULL];
                                   [hud hide:YES];
                                   [hud removeFromSuperview];

                                   id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"] || [msg isEqualToString:@"102"]) {
                                       NSString *value = @"1";
                                       NSString *key = @"first"; // the key for the data
                                       [_setting setObject:value forKey:key];
                                       [_setting synchronize];
                                       [self PostRequest];
                                   }
                                   else {
                                       [self Error:msg];
                                   }
                               }
                           }
    ];
}


///------------------------------------------------------

- (void)Error:(NSString *)msg {


    ms = error_str;
    if ([msg isEqualToString:@"103"]) {
        ms = @"نام کاربری نا معتبر میباشد";
    }
    else if ([msg isEqualToString:@"102"]) {
        ms = @"کاربری با این مشخصه وجود دارد اما ثبت نام نکرده";
    }
    else if ([msg isEqualToString:@"101"]) {
        ms = @"کاربر مسدود میباشد";
    }
    else if ([msg isEqualToString:@"100"]) {
        ms = @"کاربری با این کد مشخصه وجود ندارد . ابتدا کد مشخصه دریافت نمایید";
    }
    else if ([msg isEqualToString:@"105"]) {

        ms = @"نام کاربری تکراری میباشد";
    }
    dispatch_async(dispatch_get_main_queue(), ^{


        [hud hide:YES];
        [hud removeFromSuperview];


        [hud hide:YES];
        [hud removeFromSuperview];


        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:ms
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];

        int duration = 2; // duration in seconds
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
            [hud hide:YES];
            [hud removeFromSuperview];
            if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked:)]) {
                [self.delegate cancelButtonClicked:self];
            }
        });
    });


}


@end

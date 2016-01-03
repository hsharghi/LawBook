//
//  RegisterPage.m
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "RegisterPage.h"
#import "UIViewController+MJPopupViewController.h"
#import "MBProgressHUD.h"

@interface RegisterPage ()
@property NSInteger o;
@property NSInteger first;


@end

@implementation RegisterPage
@synthesize scroll;


NSString *IMEI_R;
NSString *Username_R;
NSString *Email_R;
NSString *Name_R;
NSString *Family_R;
NSString *Mobile_R;
NSString *Field_R;
NSString *Degree_R;
NSString *City_R;
NSString *Job_R;
UIImage *avatar_R;
bool flag_keyboard;
int faceup2 = 2;

MBProgressHUD *hud;
MBProgressHUD *hud2;
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

// set kardane fokos roie text field ha
- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    if (textField == self.Username) {
        [self.Name becomeFirstResponder];
    }
    else if (textField == self.Name) {
        [self.Family becomeFirstResponder];
    }


    else if (textField == self.Family) {
        [self.Mobile becomeFirstResponder];
    }


    else if (textField == self.Mobile) {
        [self.Job becomeFirstResponder];
    }


    else if (textField == self.Job) {
        [self.Field becomeFirstResponder];
    }
    else if (textField == self.Field) {
        [self.Degree becomeFirstResponder];
    }
    else if (textField == self.Degree) {
        [self.City becomeFirstResponder];
    }
    else if (textField == self.City) {
        [self.Email becomeFirstResponder];
    }


    else {
        [textField resignFirstResponder];
    }
    return YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    _setting = [NSUserDefaults standardUserDefaults];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];

//    if (self.viewProfile)
//        [self postRequest];
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

-(void)removeHUDFromView:(UIView *)view
{
    for (UIView *subView in view.subviews)
        if ([subView isKindOfClass:[MBProgressHUD class]]) {
            subView.hidden = YES;
            [subView removeFromSuperview];
        }
}

// dokmeie bazgasht
- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];

}


- (void)textFieldDidBeginEditing:(UITextField *)textField {


}


// validate kardane field ha
- (void)textFieldDidEndEditing:(UITextField *)textField {

    if (textField == self.Email) {

        NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
        NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
        //Valid email address
        if ([emailTest evaluateWithObject:self.Email.text] == YES) {} else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا ایمیل صحیح وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
            [alert show];

        }


    }


    if (textField == self.Mobile) {
        if ([self.Mobile.text length] < 11) {
            [self.Mobile setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا شماره صحیح وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
            [alert show];
        }
    }

    float y = textField.frame.origin.y;

    if (y > 200.0) {
        [self animateTextField:textField up:NO];
    }
    flag_keyboard = false;

}

- (void)animateTextField:(UITextField *)textField up:(BOOL)up {

}


- (void)reset_keyboard {


}

- (void)postRequest {

    NSString *imei = [_setting valueForKey:@"imei"];
    NSString *username = [_setting valueForKey:@"username"];
    NSString *temp = @"http://intelligent-book.ir/Account/CheckUsername1?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", username];
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
    
    
    if (self.viewProfile)
    {
        hud = nil;
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.labelText = loading_str;
    }

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   NSLog(@"error getting data: %@", error);
                               } else {
                                   
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];
                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"104"]) {
                                       // vorod ba movafaqiat
                                       NSDictionary *userInfo = [object objectForKey:@"Info"];
                                       
                                       [hud hide:YES];
                                       [hud removeFromSuperview];

                                       id imagePath = [userInfo objectForKey:@"image"];
                                       dispatch_sync(dispatch_get_main_queue(), ^{
                                           self.Username.text = [userInfo objectForKey:@"username"];
                                           self.Username.enabled = false;
                                           self.Name.text = [userInfo objectForKey:@"name"];
                                           self.Family.text = [userInfo objectForKey:@"family"];
                                           self.Mobile.text = [userInfo objectForKey:@"mobile"];
                                           self.Job.text = [userInfo objectForKey:@"job"];
                                           self.Field.text = [userInfo objectForKey:@"field"];
                                           self.Degree.text = [userInfo objectForKey:@"degree"];
                                           self.City.text = [userInfo objectForKey:@"city"];
                                           self.Email.text = [userInfo objectForKey:@"email"];
                                       });


//                                       [self updateLayoutForNewOrientation:self.interfaceOrientation];

                                       NSURL *imageURL;
                                       if (((NSString *)imagePath).length > 0) {
                                           imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"http://intelligent-book.ir/%@",
                                                                           [(NSString *)imagePath substringFromIndex:6]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]; }
                                       ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURL];
                                       __weak ASIHTTPRequest *wrequest = request;
                                       [request setCompletionBlock:^{
                                           // successfully downloaded the user photo, set it as user's avatar
                                           NSData *responseData = [wrequest responseData];
                                           UIImage *avatarImage = [UIImage imageWithData:responseData];
                                           [self.profilePictureButton.imageView setContentMode: UIViewContentModeScaleAspectFit];
                                           [self.profilePictureButton setImage:avatarImage forState:UIControlStateNormal];
//                                           _avatar = avatarImage;
//                                           [self updateLayoutForNewOrientation:self.interfaceOrientation];

                                       }];
                                       [request setFailedBlock:^{
                                           // couldn't get the image, set unknown.jpg as default avatar
                                           NSError *error = [wrequest error];
                                       }];

                                       [request startAsynchronous];
                                       
                                   }
                                   else
                                       NSLog(@"error getting user info from web: %@", error);
                               }
                           }
     ];
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    return YES;
}



-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}


- (IBAction)familyChanged:(id)sender {
    
    UITextField *textField = (UITextField *)sender;
    NSLog(@"sender: %@\n", textField.text);
    NSLog(@"textfield: %@", self.Family.text);
}

-(NSString *)convertDigitsToEngligh:(NSString *)phoneNumber
{
    NSArray *arabicNumbers  = @[@"١", @"٢", @"٣", @"٤", @"٥", @"٦", @"٧", @"٨", @"٩", @"٠"];
    NSArray *persianNumbers = @[@"۱", @"۲", @"۳", @"۴", @"۵", @"۶", @"۷", @"۸", @"۹", @"۰"];
    NSArray *englishNumbers = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    
    NSString *newPhoneNumber = phoneNumber;
    
    for (int i = 0; i < 10; i++)
    {
        newPhoneNumber = [newPhoneNumber stringByReplacingOccurrencesOfString:arabicNumbers[i] withString:englishNumbers[i]];
        newPhoneNumber = [newPhoneNumber stringByReplacingOccurrencesOfString:persianNumbers[i] withString:englishNumbers[i]];
    }
    
    return newPhoneNumber;
}

// validate kardane hengame zadane dokmeie sabte nam va ersale dar khaste sabte nam

- (IBAction)Register:(UIButton *)sender {

    IMEI_R = self.Username.text;
    Email_R = self.Email.text;
    Username_R = self.Username.text;
    Name_R = self.Name.text;
    Family_R = self.Family.text;
    Mobile_R = [self convertDigitsToEngligh:self.Mobile.text];
    Field_R = self.Field.text;
    Degree_R = self.Degree.text;
    City_R = self.City.text;
    Job_R = self.Job.text;
    avatar_R = _avatar;


    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address


    if ([Email_R isEqual:@""]) {


        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا ایمیل صحیح وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];

    }
    else if ([Username_R isEqual:@""]) {


        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا نام کاربری وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
    }
    else if ([Name_R isEqual:@""]) {


        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا نام را وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];


    }
    else if ([Family_R isEqual:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا نام خانوادگی را وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
    }
    else if ([Mobile_R isEqual:@""]) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا شماره همراه را وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
    }
    else if (([self.Mobile.text length] < 11) || ([emailTest evaluateWithObject:self.Email.text] != YES)) {

        if ([emailTest evaluateWithObject:self.Email.text] == YES) {


            dispatch_async(dispatch_get_main_queue(), ^{


                NSString *message = @"لطفا شماره همراه را وارد کنید";
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا ایمیل صحیح وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
            [alert show];

        }
    }
    else {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.labelText = loading_str;

        // tabeie ersale dar khaste aval baraie dariafte imei k tavasote server generate mishavad
        if (self.viewProfile) {
            [self registering];
        } else {
            [self SendFirst];
        }
    }
}


-(void)saveProfile
{
    IMEI_R = self.Username.text;
    Email_R = self.Email.text;
    Username_R = self.Username.text;
    Name_R = self.Name.text;
    Family_R = self.Family.text;
    Mobile_R = self.Mobile.text;
    Field_R = self.Field.text;
    Degree_R = self.Degree.text;
    City_R = self.City.text;
    Job_R = self.Job.text;
    avatar_R = _avatar;
    
    
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    //Valid email address
    
    
    if ([Email_R isEqual:@""]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا ایمیل صحیح وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
        
    }
    else if ([Username_R isEqual:@""]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا نام کاربری وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
    }
    else if ([Name_R isEqual:@""]) {
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا نام را وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
        
        
    }
    else if ([Family_R isEqual:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا نام خانوادگی را وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
    }
    else if ([Mobile_R isEqual:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا شماره همراه را وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
        [alert show];
    }
    else if (([self.Mobile.text length] < 11) || ([emailTest evaluateWithObject:self.Email.text] != YES)) {
        
        if ([emailTest evaluateWithObject:self.Email.text] == YES) {
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                NSString *message = @"لطفا شماره همراه را وارد کنید";
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خطا" message:@"لطفا ایمیل صحیح وارد کنید" delegate:self cancelButtonTitle:@"باشه" otherButtonTitles:nil];
            [alert show];
            
        }
        
        
    }
    else {
        
        
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.labelText = loading_str;
        
        
        
        // tabeie ersale dar khaste aval baraie dariafte imei k tavasote server generate mishavad
        if (self.viewProfile) {
            
        } else {
            [self SendFirst];
        }
        
        
    }

}

// tabeie ersale dar khaste aval baraie dariafte imei k tavasote server generate mishavad
- (void)SendFirst {


    NSString *imei = _Username.text;
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


    NSString *temp = @"http://intelligent-book.ir/Account/FirstUsing1?";
    // set kardane parametr ha
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", temp, @"IMEI=iPhone", @"&density=", dencity, @"&NetworkOperatorName=", NetworkOperatorName, @"&densityDpi=", densityDpi, @"&resoulation=", resoulation, @"&brand=", brand, @"&device=", device, @"&sdk=", sdk, @"&language=", language];
//    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", temp, @"IMEI=iphonetest", @"&density=", dencity, @"&NetworkOperatorName=", NetworkOperatorName, @"&densityDpi=", densityDpi, @"&resoulation=", resoulation, @"&brand=", brand, @"&device=", device, @"&sdk=", sdk, @"&language=", language];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];


    NSURL *url = [NSURL URLWithString:temp3];


    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    //[request setHTTPBody: jsonInput];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {

                                   [self Error];

                               } else {

                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:NULL];
                                   [hud hide:YES];
                                   [hud removeFromSuperview];

                                   // dariafte javab az server
                                   id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"] || [msg isEqualToString:@"102"]) {

                                       NSString *value = @"1";
                                       NSString *key = @"first"; // the key for the data
                                       [_setting setObject:value forKey:key];
                                       [_setting synchronize];

                                       NSString *imei = [object objectForKey:@"IMEI"];
                                       imei = [NSString stringWithFormat:@"%@", imei];

// user & password for test, restore before publish
                                       value = imei;
//                                       value = @"iphonetest";
                                       key = @"imei";
                                       [_setting setObject:value forKey:key];
                                       [_setting synchronize];

                                       // bad az dariafte imei ersale darkhast b server baraie sabtenam
                                       [self registering];
                                   }
                                   else {
                                       [self Error];
                                   }
                               }
                           }
    ];
}


- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

// tabe ersale dar khast baraie sabte nam
- (void)registering {
    {
        NSString *imei = [_setting stringForKey:@"imei"];

        BOOL ok;

        NSString *jpgImage = [UIImageJPEGRepresentation(_avatar, 0.5) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        jpgImage = [jpgImage stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jpgImage = [jpgImage stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        NSString *postString = [[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@", @"IMEI=", imei, @"&Email=", Email_R, @"&Username=", Username_R, @"&Name=", Name_R, @"&Family=", Family_R, @"&Mobile=", Mobile_R, @"&Field=", Field_R, @"&Degree=", Degree_R, @"&City=", City_R, @"&Job=", Job_R, @"&image=", (jpgImage == nil ? @"" : jpgImage)] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *postURL = [NSURL URLWithString:(self.viewProfile ? @"http://intelligent-book.ir/Account/EditProfile" : @"http://intelligent-book.ir/Account/Register2")];
        
        
        NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:postURL
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                           timeoutInterval:10.0];

        [postRequest setHTTPMethod:@"POST"];
        [postRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        [postRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:postRequest
                                           queue:queue
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                   if (error || !data) {
                                       NSString *stringdata = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                       dispatch_async(dispatch_get_main_queue(), ^{

                                           [hud hide:YES];
                                           [hud removeFromSuperview];


                                           NSString *message = error_str;
                                           UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                           message:message
                                                                                          delegate:nil
                                                                                 cancelButtonTitle:nil
                                                                                 otherButtonTitles:nil, nil];
                                           [toast show];

                                           int duration = 4; // duration in seconds

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [toast dismissWithClickedButtonIndex:0 animated:YES];
                                           });
                                       });
                                   } else {
                                       [hud hide:YES];
                                       [hud removeFromSuperview];

                                       NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:NSJSONReadingMutableContainers
                                                                                                           error:NULL];
                                       
                                       NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

                                       NSString *res;

                                       id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                       NSString *msg1 = [object objectForKey:@"Error"];
                                       NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                       id imagePath = [object objectForKey:@"image"];
                                       NSLog(@"%@",msg1);
                                       // dariafte etelaat az server va namaiesh paiame marbote
                                       if ([msg isEqualToString:@"0"]) {
                                           dispatch_async(dispatch_get_main_queue(), ^{

                                               NSString *profileMessage = @"تغییرات پروفایل با موفقیت ثبت شد";
                                               NSString *registerMessage = @"ثبت نام با موفقیت انجام گردید";
                                               NSString *message = (self.viewProfile ? profileMessage : registerMessage);

                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 4; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                                   
                                               });
                                           });

                                           int duration = 5; // duration in seconds

                                           NSString *value = @"1";
                                           NSString *key = @"register";
                                           [_setting setObject:value forKey:key];
                                           [_setting synchronize];

                                           value = _Username.text;
                                           key = @"username";
                                           [_setting setObject:value forKey:key];
                                           [_setting synchronize];

                                           NSURL *imageURL;
                                           if (imagePath != [NSNull null]) {
                                           imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"http://intelligent-book.ir/%@",
                                                                               [(NSString *)imagePath substringFromIndex:6]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                                               key = @"imageURL";
                                               [_setting setURL:imageURL forKey:key];
                                               [_setting synchronize];
                                           }

                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });


                                       } else if ([msg isEqualToString:@"103"]) {
                                           //na motabar


                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"نام کاربری نا معتبر میباشد";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 4; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                           NSString *value = @"0";
                                           NSString *key = @"first"; // the key for the data
                                           [_setting setObject:value forKey:key];


                                       } else if ([msg isEqualToString:@"102"]) {
                                           // karabar ba imei hast ama reg nakarde

                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"کاربری با این مشخصه وجود دارد اما ثبت نام نکرده";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 4; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });

                                           NSString *value = @"0";
                                           NSString *key = @"first"; // the key for the data
                                           [_setting setObject:value forKey:key];


                                       } else if ([msg isEqualToString:@"101"]) {
                                           //masdod

                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"کاربر مسدود میباشد";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 4; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                           int duration = 5; // duration in seconds
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });

                                           NSString *value = @"0";
                                           NSString *key = @"first"; // the key for the data
                                           [_setting setObject:value forKey:key];

                                       } else if ([msg isEqualToString:@"100"]) {
                                           //karbari ba in kode imei nist


                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"کاربری با این کد مشخصه وجود ندارد . ابتدا کد مشخصه دریافت نمایید";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 4; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                           int duration = 6; // duration in seconds
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });


                                           NSString *value = @"0";
                                           NSString *key = @"first"; // the key for the data
                                           [_setting setObject:value forKey:key];


                                       } else if ([msg isEqualToString:@"105"]) {
                                           //tekrari boodan name karbari


                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"نام کاربری تکراری میباشد";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 4; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                           NSString *value = @"0";
                                           NSString *key = @"first"; // the key for the data
                                           [_setting setObject:value forKey:key];

                                       } else {

                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = error_str;
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 6; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                       }


                                   }


                                   hud = nil;

                               }
        ];


    }
}


- (void)Error {
    dispatch_async(dispatch_get_main_queue(), ^{


        [hud hide:YES];
        [hud removeFromSuperview];
        hud = nil;
        NSString *message = error_str;
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];

        int duration = 4; // duration in seconds

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    });


}




//----------------------------
//----------------------------------------------------






- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************


- (void)dismissKeyboard {

    [self.Username resignFirstResponder];
    [self.Email resignFirstResponder];
    [self.Name resignFirstResponder];
    [self.Family resignFirstResponder];
    [self.Mobile resignFirstResponder];
    [self.Field resignFirstResponder];
    [self.Degree resignFirstResponder];
    [self.City resignFirstResponder];
    [self.Job resignFirstResponder];
}

// avaz kardane view be landscape ya portrait

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self updateLayoutForNewOrientation:self.interfaceOrientation];
    
    if (self.viewProfile && !self.changingPhoto)   // user is viewing profile, load the properties from webservice and assign them into properties.
    {
        [self postRequest]; // request for user info to fill the textfields
    }

}


// update kardane view dar zamane charkhesh
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}


// name xib e k baiad load shavad ra barmigardanad
- (NSString *)nibNameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSString *postfix = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? @"Landscape" : @"Portrait";
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), postfix];
}


/* avaz kardane view be landscape ya portrait - tanzimati k bad az avaz kardane view baiad anjam  shavad ta vaziate
qablie narm afzar hefz shavad mesle raftane tableview b makani k qablan bode ya set kardane matne header haie ketabkhane k b sorate dynamic va dar ejraie app baiad set shavad va ... */
- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation {

    NSString *Username = self.Username.text;
    NSString *Email = self.Email.text;
    NSString *Name = self.Name.text;
    NSString *Family = self.Family.text;
    NSString *Mobile = self.Mobile.text;
    NSString *Field = self.Field.text;
    NSString *Degree = self.Degree.text;
    NSString *City = self.City.text;
    NSString *Job = self.Job.text;
    UIImage *avatarButtonImage = self.profilePictureButton.imageView.image;
    UIImage *avatarImage = self.avatar;
    if (flag_keyboard == true)
        [self reset_keyboard];
    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    self.Username.text = Username;
    self.Email.text = Email;
    self.Name.text = Name;
    self.Family.text = Family;
    self.Mobile.text = Mobile;
    self.Field.text = Field;
    self.Degree.text = Degree;
    self.City.text = City;
    self.Job.text = Job;
    [self.profilePictureButton setImage:avatarButtonImage forState:UIControlStateNormal];
    self.avatar = avatarImage;
    self.saveButton.hidden = (self.viewProfile ? NO : YES);
    self.registerButton.hidden = (self.viewProfile ? YES : NO);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
            initWithTarget:self
                    action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
}
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************

- (void)selectProfilePicture:(id)sender {
    
//    [self openPhotoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
    

    [self dismissKeyboard];
    
    self.changingPhoto = YES;
    NSString *cameraButtonText;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        cameraButtonText = @"دوربین";

    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"عکس پروفایل" delegate:self cancelButtonTitle:@"لغو" destructiveButtonTitle:nil otherButtonTitles:@"انتخاب از گالری", cameraButtonText, nil];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [actionSheet showFromRect:_profilePictureButton.frame inView:self.view animated:YES];
    }
    else
    {
        [actionSheet showInView:self.view];
    }
}


#pragma mark - UIActionSheet  Delegate Mehtods


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.cancelButtonIndex)
        return;
    
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    if (buttonIndex == 0)   // select from gallery
    {
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        self.imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self openPhotoPicker:UIImagePickerControllerSourceTypePhotoLibrary];
        } else {
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
        }
    } else {                // camera
        self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            if (iOSVersion >= 8.0) {[[NSOperationQueue mainQueue] addOperationWithBlock:^{[self openPhotoPicker:UIImagePickerControllerSourceTypeCamera];}];
            } else {[self openPhotoPicker:UIImagePickerControllerSourceTypeCamera];}
        } else {
            [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
        }
    }
}

- (void)openPhotoPicker:(UIImagePickerControllerSourceType)sourceType
{
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
            self.imagePicker.modalPresentationStyle = UIModalPresentationPopover;
            self.imagePicker.allowsEditing = YES;
            self.imagePicker.sourceType = sourceType;
            self.imagePicker.delegate = self;
            
            if (sourceType == UIImagePickerControllerSourceTypeCamera) {
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } else {
                if (self.popover) {
                    [self.popover dismissPopoverAnimated:YES];
                    self.popover = nil;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    self.popover = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker];
                    [self.popover presentPopoverFromRect:_profilePictureButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
                });
            }
        } else if (sourceType == UIImagePickerControllerSourceTypeCamera) {
            self.imagePicker.modalPresentationStyle = UIModalPresentationFullScreen;
            self.imagePicker.allowsEditing = YES;
            self.imagePicker.sourceType = sourceType;
            self.imagePicker.delegate = self;
            
            if (sourceType == UIImagePickerControllerSourceTypeCamera) {
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } else {
                if (self.popover) {
                    [self.popover dismissPopoverAnimated:YES];
                    self.popover = nil;
                }
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.8 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                    [self.navigationController presentViewController:self.imagePicker animated:YES completion:nil];
                });
            }
        }
    }
}

#pragma mark - UIImagePicker Delegate Mehtods

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    _profilePictureButton.layer.cornerRadius = 5;
    UIImage *selectedImage = [info valueForKey:@"UIImagePickerControllerEditedImage"];
    [_profilePictureButton setImage:[info valueForKey:@"UIImagePickerControllerEditedImage"] forState:UIControlStateNormal];
    _avatar = [self imageWithImage:[info valueForKey:@"UIImagePickerControllerEditedImage"] scaledToSize:CGSizeMake(100, 100)];
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.popover dismissPopoverAnimated:YES];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end

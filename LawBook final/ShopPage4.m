//
//  ShopPage4.m
//  LawBook final
//
//  Created by saeid1 on 12/4/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//


#import "LibraryPage1.h"//;
#import "ShopPage4.h"
#import "CirclesIAPHelper.h"
#import "UIImageView+WebCache.h"


#import "MBProgressHUD.h"

@interface ShopPage4 ()
@property NSString *i;

@end

@implementation ShopPage4
NSString *get_main_id;
NSArray *_products;

MBProgressHUD *hud;
NSString *loading_str;


NSString *imei2;
NSString *username2;


NSMutableString *UrlFile2;
NSMutableString *UrlImage2;

NSMutableArray *pics3s2;
NSString *error_str;
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



    // tanzimate avalie

    _header.text = _hdr;
    username2 = [setting stringForKey:@"username"];
    imei2 = [setting stringForKey:@"imei"];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSString *price_title = [dict objectForKey:@"price_title"];
    NSString *price = [NSString stringWithFormat:@"%@%@", [NSString stringWithFormat:@"%@", _cost4], price_title];
    self.price.text = price;


    // Do any additional setup after loading the view.
    get_main_id = [NSString stringWithFormat:@"%i", _main_id_s4];
    NSLog(@"%@", get_main_id);

    [self PostRequest];
    _products = nil;


    dispatch_async(dispatch_get_main_queue(), ^{

        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDAnimationFade;
        hud.labelText = @"لطفا منتظر بمانید...";


    });




    //darkhaste mahsol az sibche
//    [[CirclesIAPHelper sharedInstance:get_main_id] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
//        // dariafte pasokh az sibche  k mahsoli hast ya na
//        if (success) {
//            _products = products;
//        }
//        [hud hide:YES];
//        [hud removeFromSuperview];
//        hud = nil;
//    }];


}








// tabeie pardakht-- amaliate pardakht dar class IAPHelper(clasess->payment) piade sazi shode ast


- (IBAction)payment:(UIButton *)sender {

 
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"خرید کتاب" message:@"در حال حاضر خرید صرفا از طریق سایت datta.ir امکان‌پذیر می‌باشد.\nپس از خرید از طریق سایت،‌ کتابها برای شما افزوده خواهد شد.\nشماره تماس: ۳۲۷۳۰۷۷۰-۰۳۴\nایمیل: info@datta.ir" delegate:self cancelButtonTitle:@"انصراف" otherButtonTitles:@"ورود به سایت", @"ارسال ایمیل",@"تماس با شرکت",nil];
    
    [alert show];
/*

 // Sibche Store Kit Payment Section
 // Comment out by Hadi
 
 
 
    // call buying method +++++++++++++++++++++++++++++++++++++++++++
    SKProduct *product = _products[0];
    NSLog(@"Buying %@... buyButtonTapped in StoreTableViewController", product.productIdentifier);
    [[CirclesIAPHelper sharedInstance:get_main_id] buyProduct:product];


    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"لطفا منتظر بمانید...";
*/

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0: //cancel
            
            break;

        case 1: //visit website
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://datta.ir"]];
            break;
            
        case 2: //send email
            [self composeEmail];
            break;
            
        case 3: //call
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://+983432730770"]];
            break;
            
        default:
            break;
    }
}

-(void)composeEmail
{
    NSString *emailTitle = @"سامانه هوشمند قوانین";
    // Email Content
    
    NSString *messageBody = @"\n\n\n\n\n_____________\nسامانه هوشمند قوانین\n";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"info@datta.ir"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}


- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)Error {
    [hud hide:YES];
    [hud removeFromSuperview];
    dispatch_async(dispatch_get_main_queue(), ^{


        NSString *message = error_str;
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


}


//darkhast etelaate mahsol
- (void)PostRequest {


    NSString *temp = @"http://intelligent-book.ir/home/MobBookDetail?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei2, @"&Username=", username2, @"&id=", get_main_id];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
                                   [self Error];
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];


                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];

                                   if ([msg isEqualToString:@"0"]) {

                                       NSMutableDictionary *DataArray = ParsedData[@"Book"];
                                       NSString *tmp = [DataArray objectForKey:@"UrlImage"];
                                       NSString *n = [DataArray objectForKey:@"Name"];
                                       NSString *d = [DataArray objectForKey:@"Description"];
                                       //NSString *d ;
                                       //NSString *n ;

                                       NSRange range = NSMakeRange(5, tmp.length - 5);
                                       UrlImage2 = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir", [tmp substringWithRange:range]];

                                       NSString *tmp2 = [DataArray objectForKey:@"UrlFile"];
                                       NSRange range2 = NSMakeRange(5, tmp2.length - 5);
                                       UrlFile2 = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir", [tmp2 substringWithRange:range2]];
                                       _i = UrlImage2;
                                       NSArray *DataArray2 = ParsedData[@"Gallereis"];


                                       [hud hide:YES];
                                       [hud removeFromSuperview];


                                       for (int i = 0; i < [DataArray2 count]; i++) {

                                           NSString *tmp = [DataArray2 objectAtIndex:i];
                                           NSRange range = NSMakeRange(5, tmp.length - 5);
                                           [pics3s2 addObject:[NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir/", [tmp substringWithRange:range]]];
                                       }


                                       [self.img sd_setImageWithURL:[NSURL URLWithString:UrlImage2]
                                                   placeholderImage:[UIImage imageNamed:@"def_img.png"]];


                                       //[self.scroll setContentSize:(CGSizeMake(320, (size.height+167)))];

                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           self.name2.text = n;

                                       });


                                   }
                                   else {

                                       [hud hide:YES];
                                       [hud removeFromSuperview];
                                       [self Error];
                                   }


                               }
                           }
    ];


}


- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForNewOrientation:self.interfaceOrientation];

    // zamani k view load mishavad in mavared ro baraie radgirie tarakonesh add mikonad
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchaseFailed:) name:IAPHelperProductPurchaseFailedNotification object:nil];
}


// view ra hengame charkhesh update mikonad
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}


// name xib e k baiad load shavad ra barmigardanad
- (NSString *)nibNameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSString *postfix = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? @"Landscape" : @"Portrait";
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), postfix];
}


/* avaz kardane view be landscape ya portrait----tanzimati k bad az avaz kardane view baiad anjam  shavad ta vaziate
 qablie narm afzar hefz shavad mesle raftane tableview b makani k qablan bode ya set kardane matne  haie  k
 b sorate dynamic va dar ejraie app baiad set shavad va ... */

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation {


    NSString *p = _price.text;
    NSString *n = _name2.text;
    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    _price.text = p;
    _name2.text = n;
    [self.img sd_setImageWithURL:[NSURL URLWithString:_i]
                placeholderImage:[UIImage imageNamed:@"def_img.png"]];
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;

}


- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


// zamani k pardakht anjam shavad in tabe ejra mishavad
- (void)productPurchased:(id *)sender {
    [hud hide:YES];
    [hud removeFromSuperview];
    hud = nil;

    LibraryPage1 *page;

    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[LibraryPage1 alloc] initWithNibName:@"LibraryPage1_Portrait" bundle:nil];
    }
    else {
        page = [[LibraryPage1 alloc] initWithNibName:@"LibraryPage1_Landscape" bundle:nil];
    }


    page.from_shop = 2;
    [self.navigationController pushViewController:page animated:YES];

}


// zamani k pardakht anjam nashavad in tabe ejra mishavad
- (void)productPurchaseFailed:(id *)sender {
    dispatch_async(dispatch_get_main_queue(), ^{


        [hud hide:YES];
        [hud removeFromSuperview];
        hud = nil;


    });

}

@end

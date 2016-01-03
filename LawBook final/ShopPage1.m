//
//  ChatPage1.m
//  low book
//
//  Created by saeid1 on 8/27/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "ShopPage1.h"
#import "MBProgressHUD.h"
#import "CellImg.h"
#import "ShopPage2.h"
#import "UIImageView+WebCache.h"


@interface ShopPage1 ()
@property NSInteger row_num;
@property NSInteger ad_time;
@property NSString *ad_img;
@property NSString *ad_link;
@property NSString *ad_desc;
@property UIImageView *ad_imageView;
@property UIButton *ad_delete;
@property UILabel *ad_label;
@property Boolean ad_show;
@property NSTimer *timer;
@property Boolean appear;
@property Boolean run;
@property Boolean ad_show2;
@end

@implementation ShopPage1

NSUserDefaults *setting;
NSString *imei;
NSString *username;
NSMutableArray *title1s;
NSMutableArray *ids1s;
NSMutableArray *pics1s;
MBProgressHUD *hud;
NSString *loading_str;
NSString *error_str;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // in safe b manand chatpage mibashad va faqat darkhaste ersale etelaat b servere an farq karde
    username = [setting stringForKey:@"username"];
    imei = [setting stringForKey:@"imei"];


    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];


    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];

    title1s = [[NSMutableArray alloc] init];
    ids1s = [[NSMutableArray alloc] init];
    pics1s = [[NSMutableArray alloc] init];


    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;


    [self PostRequest];
    _ad_show2 = true;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)Error:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *message = error_str;


        if ([msg isEqualToString:@"103"]) {
            message = @"نام کاربری نا معتبر میباشد";
        }
        else if ([msg isEqualToString:@"102"]) {
            message = @"کاربری با این مشخصه وجود دارد اما ثبت نام نکرده";
        }
        else if ([msg isEqualToString:@"101"]) {
            message = @"کاربر مسدود میباشد";
        }
        else if ([msg isEqualToString:@"100"]) {
            message = @"کاربری با این کد مشخصه وجود ندارد . ابتدا کد مشخصه دریافت نمایید";
        }
        else if ([msg isEqualToString:@"105"]) {

            message = @"نام کاربری تکراری میباشد";
        }


        [hud hide:YES];
        [hud removeFromSuperview];


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

//===============================================================================





- (void)PostRequest {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSString *temp = @"http://intelligent-book.ir/home/MobGroupList?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", username];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:temp3];

    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
    //[request setHTTPBody: jsonInput];

    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {
                                   [self Error:@""];
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:0
                                                                                                       error:NULL];


                                   id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"]) {


                                       NSArray *DataArray = ParsedData[@"Grops"];
                                       for (NSDictionary *temp in DataArray) {

                                           [ids1s addObject:temp[@"Id"]];
                                           [title1s addObject:temp[@"Name"]];
                                           NSString *tmp = temp[@"UrlImage"];
                                           NSRange range = NSMakeRange(5, tmp.length - 5);
                                           NSString *link = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir/", [tmp substringWithRange:range]];
                                           [pics1s addObject:link];

                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [tableView reloadData];
                                           tableView.hidden = NO;
                                           [hud hide:YES];
                                           [hud removeFromSuperview];
                                       });
                                   }
                                   else
                                       [self Error:msg];
                               }
                           }
    ];
}








//-------------------------------------              ----------------------------
//-------------------------------------              ----------------------------
//------------------------------------- AD FUNCTION  ----------------------------
//-------------------------------------              ----------------------------
//-------------------------------------              ----------------------------


- (void)PostRequest3 {


    //NSUserDefaults *setting;
    _run = true;
    NSString *username = [setting stringForKey:@"username"];
    NSString *imei = [setting stringForKey:@"imei"];
    if (username == nil)
        return;

    NSString *temp = @"http://intelligent-book.ir/home/MobPublicity?";
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


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {

                                   NSLog(@"errrrrooooooor: %@", error);
                                   NSLog(@"Background fetch error...");
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];

                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"]) {

                                       NSDictionary *DataArray = ParsedData[@"Publicity"];

                                       _ad_time = [DataArray[@"TimeOfPlay"] intValue];


                                       if (DataArray[@"UrlImage"] != [NSNull null]) {
                                           NSString *tmp = DataArray[@"UrlImage"];
                                           NSRange range = NSMakeRange(5, tmp.length - 5);
                                           _ad_img = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir/", [tmp substringWithRange:range]];
                                       }

                                       if (DataArray[@"Url"] != [NSNull null]) {

                                           NSString *tmp = DataArray[@"Url"];
                                           NSRange range2 = NSMakeRange(5, tmp.length - 5);
                                           _ad_link = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir/", [tmp substringWithRange:range2]];

                                       }
                                       
                                       if (DataArray[@"Description"] != [NSNull null])
                                           _ad_desc = DataArray[@"Description"];


                                       if (_ad_time != 0) {
                                           _ad_show = true;
                                           dispatch_async(dispatch_get_main_queue(), ^{

                                               NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:_ad_time target:self
                                                                                                 selector:@selector(ad_timer:) userInfo:nil repeats:YES];
                                               [self makeAd];
                                           });

                                       }


                                   }
                                   else
                                       NSLog(@"errrrrooooooor: %@", error);
                                   _run = false;

                               }
                           }

    ];
}

- (void)makeAd {
    _ad_imageView = [[UIImageView alloc] init];
    int h = self.view.frame.size.height;
    int w = self.view.frame.size.width;
    CGRect myFrame = CGRectMake(0, h - (h / 10), w, h / 10);
    _ad_imageView.frame = myFrame;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ad_clicked:)];
    singleTap.numberOfTapsRequired = 1;
    [_ad_imageView setUserInteractionEnabled:YES];
    [_ad_imageView addGestureRecognizer:singleTap];
    [_ad_imageView sd_setImageWithURL:[NSURL URLWithString:_ad_img]];
    _ad_imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.ad_imageView setBackgroundColor:[self colorWithHexString:@"943100"]];

    _ad_delete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _ad_delete.frame = CGRectMake(w - (h / 10), h - (h / 10) + (h / 100), 8 * (h / 100), 8 * (h / 100));
    [_ad_delete setBackgroundImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [_ad_delete addTarget:self action:@selector(ad_delete:)
         forControlEvents:UIControlEventTouchUpInside];


    _ad_label = [[UILabel alloc] initWithFrame:CGRectMake(5, h - (h / 10) + 5, w - (h / 10), (h / 10) - 10)];
    _ad_label.backgroundColor = [UIColor clearColor];
    _ad_label.textColor = [UIColor whiteColor];
    _ad_label.font = [UIFont fontWithName:@"BYekan" size:18.0];
    _ad_label.textAlignment = NSTextAlignmentCenter;
    _ad_label.text = _ad_desc;


    dispatch_async(dispatch_get_main_queue(), ^{


        [self.view addSubview:_ad_imageView];
        [self.view addSubview:_ad_delete];
        [self.view addSubview:_ad_label];
    });

}


- (IBAction)ad_clicked:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_ad_link]];
}


- (IBAction)ad_delete:(UIButton *)sender {

    dispatch_async(dispatch_get_main_queue(), ^{


        [_ad_label removeFromSuperview];
        [_ad_imageView removeFromSuperview];
        [_ad_delete removeFromSuperview];
    });
    _ad_show = false;
    _ad_show2 = false;


}

- (void)ad_timer:(NSTimer *)sender {
    Boolean temp = _ad_show;
    _ad_show = false;
    [self del];
    [sender invalidate];
    sender = nil;
    [self ad_delete];
    if (temp && _appear && _run == false)
        [self PostRequest3];

}

- (void)del {
    dispatch_async(dispatch_get_main_queue(), ^{


        [_ad_label removeFromSuperview];
        [_ad_imageView removeFromSuperview];
        [_ad_delete removeFromSuperview];
    });


}


- (UIColor *)colorWithHexString:(NSString *)hex {
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];

    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];

    if ([cString length] != 6) return [UIColor grayColor];

    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];

    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

//-----------------------------------------------------------------------------

















//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [title1s count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CellImg";

    CellImg *cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];


    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellImg" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }

    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    cell.bg.layer.cornerRadius = 10;
    cell.bg.clipsToBounds = YES;
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[title1s objectAtIndex:indexPath.row]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [attrString length])];
    cell.txt.attributedText = attrString;
    cell.txt.textAlignment = NSTextAlignmentRight;
    cell.txt.font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];


    [cell.img sd_setImageWithURL:[NSURL URLWithString:[pics1s objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"def_img.png"]];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    ShopPage2 *page;


    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[ShopPage2 alloc] initWithNibName:@"ShopPage2_Portrait" bundle:nil];
    }
    else {
        page = [[ShopPage2 alloc] initWithNibName:@"ShopPage2_Landscape" bundle:nil];
    }


    int idbook = [[ids1s objectAtIndex:indexPath.row] intValue];
    page.main_id2 = idbook;
    page.hdr = [title1s objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:page animated:YES];


}


//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForNewOrientation:self.interfaceOrientation];
}


// view ra hengame charkhesh update mikonad
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}

- (NSString *)nibNameForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSString *postfix = (UIInterfaceOrientationIsLandscape(interfaceOrientation)) ? @"Landscape" : @"Portrait";
    return [NSString stringWithFormat:@"%@_%@", NSStringFromClass([self class]), postfix];
}


/* avaz kardane view be landscape ya portrait----tanzimati k bad az avaz kardane view baiad anjam  shavad ta vaziate
 qablie narm afzar hefz shavad mesle raftane tableview b makani k qablan bode ya set kardane matne  haie  k
 b sorate dynamic va dar ejraie app baiad set shavad va ... */

- (void)updateLayoutForNewOrientation:(UIInterfaceOrientation)orientation {

    NSArray *visible = [tableView indexPathsForVisibleRows];

    NSIndexPath *indexpath;
    if ([visible count] != 0)
        indexpath = (NSIndexPath *) [visible objectAtIndex:0];
    _row_num = indexpath.row;

    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        tableView.hidden = NO;

    });


    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    if ([visible count] != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }
    if (_ad_show) {
        [self del];
        [self makeAd];
    }
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_row_num != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:NO];
    }
    if (_ad_show) {
        [self del];
        [self makeAd];
    }
    _appear = true;
    if (_appear && _run == false && _ad_show2)
        [self PostRequest3];

}

- (void)viewDidDisappear:(BOOL)animated {
    _ad_show2 = _ad_show;
    _appear = false;
}
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************




@end

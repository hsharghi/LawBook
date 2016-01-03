//
//  ShopPage1.m
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "ShopPage2.h"
#import "ShopPage3.h"
#import "ShopPage4.h"
#import "CollectionCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "LibraryPage1.h"
#import "LibraryPage2.h"
#import "DBManager.h"

@interface ShopPage2 ()


@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;


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

@implementation ShopPage2


NSString *get_id_book;


NSUserDefaults *setting;
NSString *imei;
NSString *username;


int idx2s = 1;
int has_data2s = 1;


NSMutableArray *name2s;
NSMutableArray *price2s;
NSMutableArray *ids2s;
NSMutableArray *pics2s;
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
    // tanzimate avalie
    _header.adjustsFontSizeToFitWidth = YES;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    _header.text = _hdr;

    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];

    username = [setting stringForKey:@"username"];
    imei = [setting stringForKey:@"imei"];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];


    ids2s = [[NSMutableArray alloc] init];
    pics2s = [[NSMutableArray alloc] init];
    name2s = [[NSMutableArray alloc] init];
    price2s = [[NSMutableArray alloc] init];
    _isBuy = [[NSMutableArray alloc] init];


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



// tavabee collectionview
//--------------------------------------- Collection View Functions ---------------------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ids2s count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    cell.container.layer.cornerRadius = 10;
    cell.container.clipsToBounds = YES;
    cell.btn.layer.cornerRadius = 5;
    cell.btn.clipsToBounds = YES;
    cell.btn.tag = indexPath.row;


    [cell.btn addTarget:self action:@selector(BtnClicked :) forControlEvents:UIControlEventTouchUpInside];
    cell.name.text = [name2s objectAtIndex:indexPath.row];

    [cell.img sd_setImageWithURL:[NSURL URLWithString:[pics2s objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"def_img.png"]];


    //check mikonad k raiegan hast ya na ya inke kharidari shode ya nava ya download shode ya na
    if ([[price2s objectAtIndex:indexPath.row] intValue] == 0 && ![[_isBuy objectAtIndex:indexPath.row] boolValue]) {
        cell.price.text = @"رایگان";
        [cell.btn setTitle:@"رایگان" forState:UIControlStateNormal];
    }
    else if ([[_isBuy objectAtIndex:indexPath.row] boolValue]) {
        if ([[price2s objectAtIndex:indexPath.row] intValue] == 0)
            cell.price.text = @"رایگان";
        else
            cell.price.text = [NSString stringWithFormat:@"%@", [price2s objectAtIndex:indexPath.row]];


        [cell.btn setTitle:@"دانلود" forState:UIControlStateNormal];
        NSString *query = [NSString stringWithFormat:@"select * from books where id='%d' ", [[ids2s objectAtIndex:indexPath.row] intValue]];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        if ([results count] != 0) {
            int dl = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"download"]] intValue];
            int copy = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue];

            if (dl != 0 && copy != 0) {
                [cell.btn setTitle:@"مطالعه" forState:UIControlStateNormal];

            }
            else {
                [cell.btn setTitle:@"دانلود" forState:UIControlStateNormal];
            }
        }


    }
    else {
        [cell.btn setTitle:@"پرداخت" forState:UIControlStateNormal];
        cell.price.text = [NSString stringWithFormat:@"%@", [price2s objectAtIndex:indexPath.row]];

    }


    return cell;


}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    bool prt = false;
    ShopPage3 *page;

    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[ShopPage3 alloc] initWithNibName:@"ShopPage3_Portrait" bundle:nil];
        prt = true;
    }
    else {
        page = [[ShopPage3 alloc] initWithNibName:@"ShopPage3_Landscape" bundle:nil];
        prt = false;
    }


    page.cost = [NSString stringWithFormat:@"%i", [[price2s objectAtIndex:indexPath.row] intValue]];
    page.isBuy = [[_isBuy objectAtIndex:indexPath.row] boolValue];
    page.prt = prt;

    int idbook = [[ids2s objectAtIndex:indexPath.row] intValue];
    page.main_id_s3 = idbook;

    [self.navigationController pushViewController:page animated:YES];


}


//tabe ee k agar raiegan bashad an ra b library ezafe mikona va agar nabashad b safeie pardakht
// hamchenin agar b liste library ezafe shode bashad b safeie motalee ketab miravad
- (void)BtnClicked:(UIButton *)sender {


    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    if ([[price2s objectAtIndex:sender.tag] intValue] == 0 && ![[_isBuy objectAtIndex:sender.tag] boolValue]) {
        [self AddToLibrary:sender.tag];
    }
    else if ([[_isBuy objectAtIndex:sender.tag] boolValue]) {


        NSString *query = [NSString stringWithFormat:@"select * from books where id='%d' ", [[ids2s objectAtIndex:sender.tag] intValue]];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        if ([results count] != 0) {
            int dl = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"download"]] intValue];
            int copy = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue];


            // agar download shode bashad va dar database etelaate an copy shode bashad
            if (copy != 0) {
                query = [NSString stringWithFormat:@"select type , name from tbl_f_book_law where _id='%d' ", [[ids2s objectAtIndex:sender.tag] intValue]];
                NSArray *r = [self.dbManager loadDataFromDB:query];
                int type = [[[r objectAtIndex:0] objectAtIndex:0] intValue];
                NSString *name = [[r objectAtIndex:0] objectAtIndex:1];

                UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
                LibraryPage2 *page;


                if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
                    page = [[LibraryPage2 alloc] initWithNibName:@"LibraryPage2_Portrait" bundle:nil];
                }
                else {
                    page = [[LibraryPage2 alloc] initWithNibName:@"LibraryPage2_Landscape" bundle:nil];
                }


                page.book_id = [[ids2s objectAtIndex:sender.tag] intValue];
                page.parent = (-1);
                page.type = type;
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:name];
                page.hdr = attString;


                [self.navigationController pushViewController:page animated:YES];

            }


            else {
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

        }
        else {
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


    }
    else {
        ShopPage4 *page;

        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            page = [[ShopPage4 alloc] initWithNibName:@"ShopPage4_Portrait" bundle:nil];
        }
        else {
            page = [[ShopPage4 alloc] initWithNibName:@"ShopPage4_Landscape" bundle:nil];
        }


        int num = sender.tag;
        page.main_id_s4 = [[ids2s objectAtIndex:num] intValue];
        page.cost4 = [NSString stringWithFormat:@"%i", [[price2s objectAtIndex:num] intValue]];
        [self.navigationController pushViewController:page animated:YES];

    }















    // NSLog([NSString stringWithFormat:@"%i", idbook]);
}


//--------------------------------------------------------------------------


//===============================================================================





- (void)PostRequest {

    NSString *idxx = [@(idx2s) stringValue];
    get_id_book = [NSString stringWithFormat:@"%i", _main_id2];
    NSString *temp = @"http://intelligent-book.ir/home/MobBookGroup?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", @"prince2", @"&gid=", get_id_book, @"&pageidx=", idxx];
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
                                   [self Error:@""];
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];


                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"]) {

                                       has_data2s = 0;
                                       int i = 0;
                                       NSArray *DataArray = ParsedData[@"Books"];
                                       for (NSDictionary *temp in DataArray) {
                                           //if(i==10)
                                           if (i == 145) {
                                               has_data2s = 1;
                                           }
                                           else {

                                               [ids2s addObject:temp[@"Id"]];
                                               [_isBuy addObject:temp[@"IsBuy"]];
                                               [name2s addObject:temp[@"Name"]];
                                               [price2s addObject:temp[@"Cost"]];

                                               NSString *tmp = temp[@"UrlImage"];
                                               NSRange range = NSMakeRange(5, tmp.length - 5);
                                               NSString *link = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir/", [tmp substringWithRange:range]];
                                               [pics2s addObject:link];
                                           }

                                           i++;


                                       }


                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [collectionView reloadData];
                                           collectionView.hidden = NO;
                                           [hud hide:YES];
                                           [hud removeFromSuperview];
                                           [activityIndicator stopAnimating];
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

                                   NSLog(@"errrrrooooooor", error);
                                   //[self  Error:@""];
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


                                           //[myTimer fire];
                                           dispatch_async(dispatch_get_main_queue(), ^{

                                               NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:_ad_time target:self
                                                                                                 selector:@selector(ad_timer:) userInfo:nil repeats:YES];
                                               [self makeAd];
                                           });

                                       }


                                   }
                                   else
                                       NSLog(@"errrrrooooooor", error);
                                   //[self Error:msg];
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
































// ersal darkhast baraie afzodane ketabe raiegan b library

- (void)AddToLibrary:(int)index {


    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;


    NSString *idxx = [@(idx2s) stringValue];
    get_id_book = [NSString stringWithFormat:@"%i", _main_id2];
    NSString *temp = @"http://intelligent-book.ir/home/MobAddFreeBookBough?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", username, @"&id=", [ids2s objectAtIndex:index]];
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


                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"]) {


                                       [_isBuy replaceObjectAtIndex:index withObject:@"1"];

                                       dispatch_async(dispatch_get_main_queue(), ^{


                                           [activityIndicator stopAnimating];
                                           [hud hide:YES];
                                           [hud removeFromSuperview];

                                           NSString *message = @"کتاب با موفقیت افزوده شد";
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
                                           [collectionView reloadData];
                                       });


                                   }
                                   else
                                       [self Error:msg];


                               }
                           }
    ];
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
        [activityIndicator stopAnimating];

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

    NSArray *visible = [collectionView indexPathsForVisibleItems];


    NSIndexPath *indexpath;
    if ([visible count] != 0)
        indexpath = (NSIndexPath *) [visible objectAtIndex:0];
    _row_num = indexpath.row;


    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    if ([visible count] != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionTop
                                       animated:YES];
    }
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil] forCellWithReuseIdentifier:@"CollectionCell"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [collectionView reloadData];
        collectionView.hidden = NO;
        [hud hide:YES];
        [hud removeFromSuperview];
        [activityIndicator stopAnimating];
    });
    _header.text = _hdr;
    _header.adjustsFontSizeToFitWidth = YES;
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_row_num inSection:0];
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionTop
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

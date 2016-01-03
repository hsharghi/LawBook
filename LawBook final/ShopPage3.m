//
//  ShopPage1.m
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "ShopPage3.h"
#import "ShopPage4.h"

#import "CollectionCell.h"
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "UILabel+dynamicSizeMe.h"
#import "LibraryPage1.h"
#import "LibraryPage2.h"
#import "DBManager.h"

@interface ShopPage3 ()

@property NSInteger row_num;
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;


@end

@implementation ShopPage3
NSString *get_id_book;


NSUserDefaults *setting;
NSString *imei;
NSString *username;

int id3s = 1;
NSMutableString *name3s;
NSMutableString *UrlFile;
NSMutableString *UrlImage;
NSMutableString *price3s;
NSMutableArray *pics3s;
MBProgressHUD *hud;
NSString *loading_str;
NSString *error_str;
NSString *price_title;

NSInteger width3s = 0;

int open_close = 0;
int h;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _header.adjustsFontSizeToFitWidth = YES;
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];




    // tanzimat
    _header.text = _hdr;

    self.name2.text = _txt_name;

    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCellDetail" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellDetail"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];

    username = [setting stringForKey:@"username"];
    imei = [setting stringForKey:@"imei"];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];

    [_price setTitle:[NSString stringWithFormat:@"%@", _cost] forState:UIControlStateNormal];


    self.container.layer.cornerRadius = 10;
    self.container.clipsToBounds = YES;

    self.price.layer.cornerRadius = 5;
    self.price.clipsToBounds = YES;

    self.price.layer.cornerRadius = 5;
    self.price.clipsToBounds = YES;

    self.download.layer.cornerRadius = 5;
    self.download.clipsToBounds = YES;


    self.desc_btn.layer.cornerRadius = 5;
    self.desc_btn.clipsToBounds = YES;

    self.desc_btn_border.layer.cornerRadius = 5;
    self.desc_btn_border.clipsToBounds = YES;

    pics3s = [[NSMutableArray alloc] init];


    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];


    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;
    [self PostRequest];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



// tavabe collectionview marbot b gallery
//--------------------------------------- Collection View Functions ---------------------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [pics3s count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellDetail" forIndexPath:indexPath];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[pics3s objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"def_img.png"]];


    return cell;


}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {


    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide:)];
    singleTap.numberOfTapsRequired = 1;
    [_image_btn setUserInteractionEnabled:YES];
    [_image_btn addGestureRecognizer:singleTap];

    [_image_btn sd_setImageWithURL:[NSURL URLWithString:[pics3s objectAtIndex:indexPath.row]]
                  placeholderImage:[UIImage imageNamed:@"black_bg.png"]];
    _image_btn.hidden = NO;
    //_temp_index=indexPath.row;
    _image_btn.contentMode = UIViewContentModeScaleAspectFit;
    _image_btn.backgroundColor = [UIColor blackColor];


}


- (void)hide:(UIButton *)sender {
    _image_btn.hidden = YES;
}




//--------------------------------------------------------------------------


//===============================================================================





- (void)PostRequest {


    get_id_book = [NSString stringWithFormat:@"%i", _main_id_s3];

    NSString *temp = @"http://intelligent-book.ir/home/MobBookDetail?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", username, @"&id=", get_id_book];
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

                                       NSMutableDictionary *DataArray = ParsedData[@"Book"];
                                       NSString *tmp = [DataArray objectForKey:@"UrlImage"];
                                       _txt_name = [DataArray objectForKey:@"Name"];


                                       _txt_desc = [DataArray objectForKey:@"Description"];


                                       _desc.numberOfLines = 0;
                                       NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                                       paragraphStyle.alignment = NSTextAlignmentJustified;
                                       [paragraphStyle setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue] - 1];

                                       [paragraphStyle setBaseWritingDirection:NSWritingDirectionRightToLeft];
                                       NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]],
                                               NSBaselineOffsetAttributeName : @0,
                                               NSParagraphStyleAttributeName : paragraphStyle};
                                       NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:_txt_desc
                                                                                                            attributes:attributes];
                                       _desc.attributedText = attributedText;


                                       NSRange range = NSMakeRange(5, tmp.length - 5);
                                       UrlImage = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir", [tmp substringWithRange:range]];

                                       NSString *tmp2 = [DataArray objectForKey:@"UrlFile"];
                                       NSRange range2 = NSMakeRange(5, tmp2.length - 5);
                                       UrlFile = [NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir", [tmp2 substringWithRange:range2]];

                                       NSArray *DataArray2 = ParsedData[@"Gallereis"];
                                       for (int i = 0; i < [DataArray2 count]; i++) {

                                           NSString *tmp = [DataArray2 objectAtIndex:i];
                                           NSRange range = NSMakeRange(5, tmp.length - 5);
                                           [pics3s addObject:[NSString stringWithFormat:@"%@%@", @"http://intelligent-book.ir/", [tmp substringWithRange:range]]];
                                       }


                                       [self.img sd_setImageWithURL:[NSURL URLWithString:UrlImage]
                                                   placeholderImage:[UIImage imageNamed:@"def_img.png"]];


                                       h = [_desc expectedHeight] + 20;
                                       [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, h + 161)];


                                       //--------------------------------------


                                       //---------------------------------------------
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [collectionView reloadData];
                                           collectionView.hidden = NO;
                                           [hud hide:YES];
                                           [hud removeFromSuperview];
                                           self.name.text = _txt_name;
                                           self.name2.text = _txt_name;
                                           CGRect frame = self.desc.frame;
                                           frame.size.height = [_desc expectedHeight];
                                           self.desc.frame = frame;
                                           //self.desc.text=_txt_desc;


                                           if ([_cost intValue] == 0 && !_isBuy) {

                                               [_price setTitle:@"رایگان" forState:UIControlStateNormal];
                                               [_download setTitle:@"رایگان" forState:UIControlStateNormal];
                                           }
                                           else if (_isBuy) {


                                               [_download setTitle:@"دانلود" forState:UIControlStateNormal];
                                               if ([_cost intValue] == 0)
                                                   [_price setTitle:@"رایگان" forState:UIControlStateNormal];
                                               else {
                                                   NSString *c = [NSString stringWithFormat:@"%@ %@", _cost, @"تومان"];
                                                   [_price setTitle:c forState:UIControlStateNormal];
                                               }


                                               NSString *query = [NSString stringWithFormat:@"select * from books where id='%d' ", _main_id_s3];
                                               NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
                                               if ([results count] != 0) {
                                                   int dl = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"download"]] intValue];
                                                   int copy = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue];

                                                   if (dl != 0 && copy != 0) {
                                                       [_download setTitle:@"مطالعه" forState:UIControlStateNormal];

                                                   }
                                                   else {
                                                       [_download setTitle:@"دانلود" forState:UIControlStateNormal];
                                                   }
                                               }


                                           }
                                           else {
                                               [_download setTitle:@"پرداخت" forState:UIControlStateNormal];
                                               NSString *c = [NSString stringWithFormat:@"%@ %@", _cost, @"تومان"];
                                               [_price setTitle:c forState:UIControlStateNormal];

                                           }
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

//-----------------------------------------------------


// baz va baste kardane qesmate tozihat
- (IBAction)open_close_desc:(UIButton *)sender {
    if (open_close == 0) {
        open_close = 1;
        h = _scroll.contentSize.height;
        [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, 350 + 80)];
        self.temp.text = @"+";
        self.desc.hidden = YES;
        CGRect frame = self.desc.frame;
        //frame.size.height =0;
    }
    else {
        open_close = 0;
        [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, h)];
        self.temp.text = @"-";
        self.desc.hidden = NO;
        CGRect frame = self.desc.frame;
        frame.size.height = h;

    }

}



//-----------------------------------------------------


// dokmeie pardakht dar sorati k nakharide bashad
// ya afzodan b library dar sorati k kharide bashad ya raiegan bashad
// motalee dar sorati k download karde bashad
- (IBAction)BtnClicked:(id)sender {


    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;

    if ([_cost intValue] == 0 && !_isBuy) {
        [self AddToLibrary];
    }
    else if (_isBuy) {


        NSString *query = [NSString stringWithFormat:@"select * from books where id='%d' ", _main_id_s3];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        if ([results count] != 0) {
            int dl = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"download"]] intValue];
            int copy = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue];

            if (copy != 0) {
                query = [NSString stringWithFormat:@"select type , name from tbl_f_book_law where _id='%d' ", _main_id_s3];
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


                page.book_id = _main_id_s3;
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

        page.main_id_s4 = _main_id_s3;
        page.cost4 = _cost;
        [self.navigationController pushViewController:page animated:YES];

    }


}


// tabe ezafe kardane ketab b library agar kharide bashad ya raiegan bashad
- (void)AddToLibrary {


    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;

    NSString *temp = @"http://intelligent-book.ir/home/MobAddFreeBookBough?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%d", temp, @"IMEI=", imei, @"&Username=", username, @"&id=", _main_id_s3];
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


                                       dispatch_async(dispatch_get_main_queue(), ^{


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

                                       });
                                       [_download setTitle:@"دانلود" forState:UIControlStateNormal];
                                       _isBuy = true;


                                   }
                                   else
                                       [self Error:msg];


                               }
                           }
    ];
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


    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    if (self.interfaceOrientation == UIDeviceOrientationPortrait)
        _prt = true;
    else
        _prt = false;


    _header.adjustsFontSizeToFitWidth = YES;


    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCellDetail" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellDetail"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [collectionView reloadData];
        collectionView.hidden = NO;
        [hud hide:YES];
        [hud removeFromSuperview];
    });
    _header.text = _txt_name;
    _name.text = _txt_name;
    _name2.text = _txt_name;

    if (_txt_desc != nil) {


        _desc.numberOfLines = 0;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        [paragraphStyle setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue] - 1];

        [paragraphStyle setBaseWritingDirection:NSWritingDirectionRightToLeft];
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]],
                NSBaselineOffsetAttributeName : @0,
                NSParagraphStyleAttributeName : paragraphStyle};
        NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:_txt_desc
                                                                             attributes:attributes];
        _desc.attributedText = attributedText;


    }


    [self.img sd_setImageWithURL:[NSURL URLWithString:UrlImage]
                placeholderImage:[UIImage imageNamed:@"def_img.png"]];


    self.container.layer.cornerRadius = 10;
    self.container.clipsToBounds = YES;

    self.price.layer.cornerRadius = 5;
    self.price.clipsToBounds = YES;

    self.price.layer.cornerRadius = 5;
    self.price.clipsToBounds = YES;

    self.download.layer.cornerRadius = 5;
    self.download.clipsToBounds = YES;


    self.desc_btn.layer.cornerRadius = 5;
    self.desc_btn.clipsToBounds = YES;

    self.desc_btn_border.layer.cornerRadius = 5;
    self.desc_btn_border.clipsToBounds = YES;


    if ([_cost intValue] == 0 && !_isBuy) {

        [_price setTitle:@"رایگان" forState:UIControlStateNormal];
        [_download setTitle:@"رایگان" forState:UIControlStateNormal];
    }
    else if (_isBuy) {

        [_download setTitle:@"دانلود" forState:UIControlStateNormal];
        if ([_cost intValue] == 0)
            [_price setTitle:@"رایگان" forState:UIControlStateNormal];
        else {
            NSString *c = [NSString stringWithFormat:@"%@ %@", _cost, @"تومان"];
            [_price setTitle:c forState:UIControlStateNormal];
        }


        NSString *query = [NSString stringWithFormat:@"select * from books where id='%d' ", _main_id_s3];
        NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
        if ([results count] != 0) {
            int dl = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"download"]] intValue];
            int copy = [[[results objectAtIndex:0] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"copy"]] intValue];

            if (dl != 0 && copy != 0) {
                [_download setTitle:@"مطالعه" forState:UIControlStateNormal];

            }
            else {
                [_download setTitle:@"دانلود" forState:UIControlStateNormal];
            }
        }


    }
    else {
        [_download setTitle:@"پرداخت" forState:UIControlStateNormal];
        NSString *c = [NSString stringWithFormat:@"%@ %@", _cost, @"تومان"];
        [_price setTitle:c forState:UIControlStateNormal];

    }
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;

}




//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************



@end

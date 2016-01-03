//
//  ChatPage3.m
//  LawBook final
//
//  Created by saeid1 on 8/29/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "ChatPage3.h"
#import "MBProgressHUD.h"
#import "CellImg.h"
#import "UIImageView+WebCache.h"

#define FONT_SIZE 17.0f
#define CELL_CONTENT_MARGIN 20.0f


@interface ChatPage3 ()
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

@implementation ChatPage3


int faceupcp3 = 2;


NSUserDefaults *setting;
NSString *imei;
NSString *username;
NSInteger width = 0;
int idx = 1;
int has_data = 1;
int font = 20;


NSCache *_thumbnailCache;
NSMutableArray *like3;
NSMutableArray *dislike3;
NSMutableArray *typic_ids3;
NSMutableArray *senderName3;
NSMutableArray *senderImage3;
NSMutableArray *date3;
NSMutableArray *ids3;
NSMutableArray *body3;
bool flag_keyboard;
NSMutableArray *pics3;
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

- (void)initThumbnailsCache {
    _thumbnailCache = [[NSCache alloc] init];
    _thumbnailCache.name = @"Contacts Thumbnails Cache";
    _thumbnailCache.countLimit = 30;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    [self initThumbnailsCache];

    // tanzimate avalie
    self.comment_txt.delegate = self;
    self.comment_txt.returnKeyType = UIReturnKeyDone;

    _header.text = _hdr;
    _header.adjustsFontSizeToFitWidth = YES;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        font = 22;
    }
    else {
        font = 26;
    }

    idx = 1;
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    CGSize screenSize = CGSizeMake(screenBounds.size.width * screenScale, screenBounds.size.height * screenScale);
    width = screenSize.width;
    NSString *first = [setting stringForKey:@"first"];
    username = [setting stringForKey:@"username"];
    imei = [setting stringForKey:@"imei"];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];

    like3 = [[NSMutableArray alloc] init];
    dislike3 = [[NSMutableArray alloc] init];
    ids3 = [[NSMutableArray alloc] init];
    pics3 = [[NSMutableArray alloc] init];
    date3 = [[NSMutableArray alloc] init];
    senderName3 = [[NSMutableArray alloc] init];
    senderImage3 = [[NSMutableArray alloc] init];
    typic_ids3 = [[NSMutableArray alloc] init];
    body3 = [[NSMutableArray alloc] init];

    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];

    [self PostRequest];  //[self grabURLInBackground:nil];
    _ad_show2 = true;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)Error {
    dispatch_async(dispatch_get_main_queue(), ^{

        [activityIndicator stopAnimating];
        [hud hide:YES];
        [hud removeFromSuperview];
        NSString *message = error_str;
        UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:nil, nil];
        [toast show];

        int duration = 2;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [toast dismissWithClickedButtonIndex:0 animated:YES];
        });
    });


}
//===============================================================================



// ersale dar khast

- (void)PostRequest {


    NSString *idxx = [@(idx) stringValue];
    NSString *temp = @"http://intelligent-book.ir/Typic/Detail?";
    NSString *get_main_id = [NSString stringWithFormat:@"%i", _main_id];
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", @"prince2", @"&id=", get_main_id, @"&pageidx=", idxx];
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
                                   [self Error];
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];
                                   
                                   
                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"]) {
                                       
                                       has_data = 0;
                                       NSArray *DataArray = ParsedData[@"Comments"];
                                       for (NSDictionary *temp in DataArray) {
                                           has_data = 1;
                                           [ids3 addObject:temp[@"id"]];
                                           [body3 addObject:temp[@"body"]];
                                           [senderName3 addObject:temp[@"senderName"]];
                                           [senderImage3 addObject:temp[@"senderImage"]];
                                           [date3 addObject:temp[@"datetime"]];
                                           [like3 addObject:temp[@"like"]];
                                           
                                           [dislike3 addObject:temp[@"unlike"]];
                                           [typic_ids3 addObject:temp[@"typicid"]];
                                           
                                       }
                                       dispatch_async(dispatch_get_main_queue(), ^{
                                           [tableView reloadData];
                                           tableView.hidden = NO;
                                           [hud hide:YES];
                                           [hud removeFromSuperview];
                                           [activityIndicator stopAnimating];
                                       });
                                   }
                                   else
                                       [self Error];
                               }
                           }
     ];
}
//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ids3 count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CellComment";

    CellImg *cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];


    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellComment" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }


    cell.bg.layer.cornerRadius         = 10;
    cell.bg.clipsToBounds              = YES;
    cell.img_header.layer.cornerRadius = 10;
    cell.img_header.clipsToBounds      = YES;

    // Euphrates-Media
    // set user photo id

    cell.avatar.layer.cornerRadius  = 25;
    cell.avatar.layer.masksToBounds = YES;
    cell.avatar.layer.borderColor   = [UIColor grayColor].CGColor;
    cell.avatar.layer.borderWidth   = 2.0f;
    UIImage *image                  = [_thumbnailCache objectForKey:senderName3[indexPath.row]];

    if (image) {
        cell.avatar.image = image;
    } else {
        cell.avatar.image = [UIImage imageNamed:@"unknown.jpg"];
        NSURL *imageURL;
        NSString *imagePath = senderImage3[indexPath.row];
        if (imagePath.length > 0) {
            imageURL = [NSURL URLWithString:[[NSString stringWithFormat:@"http://intelligent-book.ir/%@",
                                              [(NSString *)imagePath substringFromIndex:6]] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:imageURL];
        __weak ASIHTTPRequest *wrequest = request;

        [request setCompletionBlock:^{
            // successfully downloaded the user photo, add it to cache then set it as user's avatar
            NSData *responseData = [wrequest responseData];
            UIImage *avatarImage = [UIImage imageWithData:responseData];
            [_thumbnailCache setObject:avatarImage forKey:senderName3[indexPath.row]];
            // check if cell is still visible, then set the image as avatar
            CellImg *cell = (CellImg *) [tableView cellForRowAtIndexPath:indexPath];
            if (cell)
                cell.avatar.image = avatarImage;
        }];
        [request setFailedBlock:^{
            // couldn't get the image, set unknown.jpg as default avatar
            NSError *error = [wrequest error];
        }];
        [request startAsynchronous];
    }

    cell.dislike.tag = indexPath.row;
    [cell.dislike addTarget:self action:@selector(UnlikeClicked:) forControlEvents:UIControlEventTouchUpInside];

    cell.like.tag = indexPath.row;
    [cell.like addTarget:self action:@selector(LikeClicked :) forControlEvents:UIControlEventTouchUpInside];

    if (indexPath.row == [ids3 count] - 1 && has_data == 1) {
        idx++;
        [activityIndicator startAnimating];
        [self PostRequest];
    }

    [cell setBackgroundColor:[UIColor clearColor]];


    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.txt.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue] - 16];

    [paragraphStyle setBaseWritingDirection:NSWritingDirectionRightToLeft];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]],
            NSBaselineOffsetAttributeName : @0,
            NSParagraphStyleAttributeName : paragraphStyle};
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:[body3 objectAtIndex:indexPath.row]
                                                                         attributes:attributes];
    cell.txt.attributedText = attributedText;


    cell.txt_header.text = [senderName3 objectAtIndex:indexPath.row];
    cell.date.text = [date3 objectAtIndex:indexPath.row];

    cell.like_num.text = [NSString stringWithFormat:@"%@", [like3 objectAtIndex:indexPath.row]];
    cell.dislike_num.text = [NSString stringWithFormat:@"%@", [dislike3 objectAtIndex:indexPath.row]];
    //cell.num.text = [title objectAtIndex:indexPath.row];


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {


    NSString *str = [body3 objectAtIndex:indexPath.row];


    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];

    [paragraphStyle setBaseWritingDirection:NSWritingDirectionRightToLeft];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]],
            NSBaselineOffsetAttributeName : @0,
            NSParagraphStyleAttributeName : paragraphStyle};

    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:str];
    [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];


    CGSize size = [str sizeWithFont:[UIFont fontWithName:@"BYekan" size:font] constrainedToSize:CGSizeMake(280, 999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"%f", size.height);
    return size.height + 120;

}


// in tabe bar asase meqdar matn size morede nazar(yani ertefa ro b ma mide)
- (float)getSize:(NSAttributedString *)str {

    CGFloat width = tableView.frame.size.width - 40;  //tableView width - left border width - accessory indicator - right border width
    UIFont *font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];
    CGRect rect = [str boundingRectWithSize:(CGSize) {width, CGFLOAT_MAX}
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    CGSize size = rect.size;
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);
    return size.height + 15;


}
//-------------------------------------------------------------------


// tabee like // sender.tag makane dokmeie like ra moshakhas mikonad
- (void)LikeClicked:(UIButton *)sender {

    [self like_req:sender.tag like:@"like"];

}


- (void)UnlikeClicked:(UIButton *)sender {

    [self like_req:sender.tag like:@"dislike"];
    NSLog([NSString stringWithFormat:@"%ld", (long) sender.tag]);

}


//////---------------------------- Like Request -------------------------------------
- (void)like_req:(int)index like:(NSString *)like {

    NSString *Username_Like = username;
    NSString *Status_Like = @"0";
    NSString *Like_Like = like;
    NSString *Id_Like = [NSString stringWithFormat:@"%@", [ids3 objectAtIndex:index]];


    NSString *temp = @"http://intelligent-book.ir/Typic/LikeComment?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", username, @"&Status=", Like_Like, @"&id=", Id_Like];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *url = [NSURL URLWithString:temp3];

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

                                   dispatch_async(dispatch_get_main_queue(), ^{


                                       [self Error];
                                   });


                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];
                                   NSString *res;
                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   NSLog(msg);
                                   if ([msg isEqualToString:@"0"]) {
                                       if ([like isEqualToString:@"like"]) {
                                           NSString *t = [NSString stringWithFormat:@"%d", ([[like3 objectAtIndex:index] intValue] + 1)];
                                           [like3 replaceObjectAtIndex:index withObject:t];


                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               [tableView reloadData];
                                               NSString *message = @"ثبت نظر مثبت";
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
                                       else {
                                           NSString *t = [NSString stringWithFormat:@"%d", ([[dislike3 objectAtIndex:index] intValue] + 1)];
                                           [dislike3 replaceObjectAtIndex:index withObject:t];


                                           dispatch_async(dispatch_get_main_queue(), ^{

                                               [tableView reloadData];
                                               NSString *message = @"ثبت نظر منفی";
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


                                   } else if ([msg isEqualToString:@"106"]) {

                                       dispatch_async(dispatch_get_main_queue(), ^{


                                           NSString *message = @"شما قبلا رای داده اید";
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


                               }


                           }];
}

//-------------------------------- pop up windows -----------------------------------


// tabe validate va ersale nazar

- (IBAction)send:(UIButton *)sender {


    if ([self.comment_txt.text isEqual:@""]) {

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
        // send web service



        NSString *message_comment;
        NSString *Id_comment = [NSString stringWithFormat:@"%i", _main_id];
        message_comment = self.comment_txt.text;
        NSString *temp = @"http://intelligent-book.ir/Typic/InsertComment?";

        NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%d%@%@%@%@", temp, @"IMEI=", imei, @"&id=", _main_id, @"&message=", message_comment, @"&Username=", username];
        NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        NSURL *url = [NSURL URLWithString:temp3];
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

                                       dispatch_async(dispatch_get_main_queue(), ^{


                                           NSString *message = @"خطا در برقراری ارتباط";
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
                                       NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                         options:NSJSONReadingMutableContainers
                                                                                                           error:NULL];


                                       NSString *res;

                                       id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                       NSString *msg1 = [object objectForKey:@"Error"];
                                       NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                       NSLog(msg);
                                       if ([msg isEqualToString:@"0"]) {


                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"ارسال با موفقیت انجام گردید";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 3;

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });
//
//                                           int duration = 5; // duration in seconds
//                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//                                               [self.navigationController popViewControllerAnimated:YES];
//                                           });
//
                                           
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               self.comment_txt.text = @"";
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

                                               int duration = 3; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


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

                                               int duration = 3; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


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

                                               int duration = 3; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                           int duration = 5; // duration in seconds
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                               [self.navigationController popViewControllerAnimated:YES];
                                           });


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

                                               int duration = 3; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                       } else {

                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"خطا در ثبت داده ها";
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


                                   }


                               }
        ];


    }

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    NSInteger nextTag = textField.tag + 1;
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
        [nextResponder resignFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {

    float y = textField.frame.origin.y;

    if (y > 200.0) {
        [self animateTextField:textField up:YES];
    }
    flag_keyboard = true;

}

- (void)textFieldDidEndEditing:(UITextField *)textField {


    float y = textField.frame.origin.y;

    if (y > 200.0) {
        [self animateTextField:textField up:NO];
    }
    flag_keyboard = false;

}


// reset kardane keyboard vaqti halate safhe avaz mishavad
- (void)reset_keyboard {
    bool up = YES;

    int movementDistance = -210; // tweak as needed

    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (orientation == UIDeviceOrientationPortrait) {


        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {


            movementDistance = -250; // tweak as needed

        } else {

            movementDistance = -210; // tweak as needed


        }


    }
    else {


        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {


            movementDistance = -350; // tweak as needed

        } else {

            movementDistance = -150; // tweak as needed


        }


    }


    const float movementDuration = 0.3f; // tweak as needed

    int movement = (up ? movementDistance : -movementDistance);

    [UIView beginAnimations:@"animateTextField" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];


}


- (void)animateTextField:(UITextField *)textField up:(BOOL)up {

    int movementDistance = -210; // tweak as needed

    UIDeviceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

    if (orientation == UIDeviceOrientationPortrait) {


        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {


            movementDistance = -250; // tweak as needed

        } else {

            movementDistance = -210; // tweak as needed


        }


    }
    else {


        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {


            movementDistance = -350; // tweak as needed

        } else {

            movementDistance = -150; // tweak as needed


        }


    }


    const float movementDuration = 0.3f; // tweak as needed

    int movement = (up ? movementDistance : -movementDistance);

    [UIView beginAnimations:@"animateTextField" context:nil];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
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
    //[_ad_imageView setBackgroundColor:[UIColor blackColor]];





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


// update kardane view dar zamane charkhesh
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
    if (flag_keyboard == true)
        [self reset_keyboard];
    NSString *comment = self.comment_txt.text;
    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    _header.adjustsFontSizeToFitWidth = YES;


    self.comment_txt.text = comment;
    if (self.interfaceOrientation == UIDeviceOrientationPortrait)
        font = 23;
    else
        font = 26;


    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
        tableView.hidden = NO;

    });
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    _header.text = _hdr;
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

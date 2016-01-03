//
//  UpdatePage1.m
//  LawBook
//
//  Created by saeid1 on 12/24/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import "UpdatePage1.h"
#import "UIImageView+WebCache.h"
#import "CollectionCell.h"
#import "MBProgressHUD.h"
#import "DBManager.h"
#import "DataClass.h"


@interface UpdatePage1 () {
}
@property DataClass *obj;
@property UIProgressView *pg;
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;
@property(nonatomic, strong) DBManager *dbManager3;
@property NSURLSessionDownloadTask *downloadTask;

@property Boolean show_btn;


//@property ASIHTTPRequest *Request;


@end

@implementation UpdatePage1

CollectionCell *dl_cell;
NSUserDefaults *setting;
NSString *imei;
NSString *username;


int idx1u = 1;
int has_data1u = 1;
int dl_indexu = -1;
CGFloat progu = 0;

NSMutableArray *name1u;
NSMutableArray *ids1u;
NSMutableArray *pics1u;
MBProgressHUD *hud;
NSString *loading_str;
NSString *error_str;

NSTimer *timeru;
NSMutableArray *show1u;
NSMutableArray *show2u;
NSMutableString *temp_path;

Boolean error_enableu = true;
Boolean dl_runningu = false;
Boolean dl_erroru = false;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    // Initialize the progress view



    // tanzimate avalie
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCellLibrary" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellLibrary"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];





    //-----------








    username = [setting stringForKey:@"username"];
    imei = [setting stringForKey:@"imei"];


    NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    error_str = [dict objectForKey:@"connection_error"];
    loading_str = [dict objectForKey:@"loading"];


    temp_path = [[NSMutableString alloc] init];

    if (dl_indexu == -1) {

        ids1u = [[NSMutableArray alloc] init];
        pics1u = [[NSMutableArray alloc] init];
        name1u = [[NSMutableArray alloc] init];
        show1u = [[NSMutableArray alloc] init];
        show2u = [[NSMutableArray alloc] init];
        [self GetFromDatabase];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [collectionView reloadData];
        collectionView.hidden = NO;

    });


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// namaieshe loading
- (void)show_loading {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = loading_str;
}



//--------------------------------------- Collection View Functions ---------------------------


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ids1u count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {


    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCellLibrary" forIndexPath:indexPath];
    cell.container.layer.cornerRadius = 5;
    cell.container.clipsToBounds = YES;
    cell.name.text = [name1u objectAtIndex:indexPath.row];
    [cell.img sd_setImageWithURL:[NSURL URLWithString:[pics1u objectAtIndex:indexPath.row]]
                placeholderImage:[UIImage imageNamed:@"black_bg.png"]];


    if ([[show1u objectAtIndex:indexPath.row] intValue] == 0) {
        cell.labeledProgressView.hidden = YES;
        cell.dl.image = [UIImage imageNamed:@"download.png"];
    }
    else {
        cell.labeledProgressView.hidden = NO;
        cell.dl.image = [UIImage imageNamed:@"pause.png"];
        dl_cell = cell;
    }

    //--------------------------
    if ([[show2u objectAtIndex:indexPath.row] intValue] == 0) {
        cell.tempProgressView.hidden = YES;
        cell.dl.hidden = YES;
    }
    else {
        cell.tempProgressView.hidden = NO;
        cell.dl.hidden = NO;

    }


    return cell;


}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (!dl_runningu) {
        if (_obj.Request1 == nil) {
            dl_runningu = true;
            dl_indexu = indexPath.row;
            dl_cell = [collectionView cellForItemAtIndexPath:indexPath];
            [self download_book:[ids1u objectAtIndex:indexPath.row]];
            [collectionView reloadData];
        }

    }
    else {

        if (dl_indexu == indexPath.row) {
            [timeru invalidate];
            timeru = nil;
            [_obj.Request2 cancel];
            [_obj.Request2 clearDelegatesAndCancel];
            [show1u replaceObjectAtIndex:dl_indexu withObject:@"0"];
            dl_indexu = -1;
            progu = 0;
            dl_runningu = false;

            [_obj.Request2 cancel];
            [_obj.Request2 clearDelegatesAndCancel];
            _obj.Request2 = nil;
            [collectionView reloadData];
        }


    }


}



//--------------------------------------------------------------------------

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}






//===============================================================================


/* in tabe bad az download seda zade mishe va file database qabli k b name id haman ketab
 mibashad ra pak mikonad va file database ketabe jadid k ba name idid download shode ra
 jaigozin an mikonad */
- (void)copy_book:(int)index {


    [self show_loading];
    NSString *dest_name = [NSString stringWithFormat:@"%@", [ids1u objectAtIndex:dl_indexu]];
    NSString *source_name = [NSString stringWithFormat:@"%@%@", [ids1u objectAtIndex:dl_indexu], [ids1u objectAtIndex:dl_indexu]];
    NSString *destinationPath = [self.dbManager.documentsDirectory stringByAppendingPathComponent:dest_name];
    NSString *sourcePath = [self.dbManager.documentsDirectory stringByAppendingPathComponent:source_name];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:&error];


    [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    if (error != nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    else {
        [[NSFileManager defaultManager] removeItemAtPath:sourcePath error:&error];
        NSString *query = [NSString stringWithFormat:@"update books set  download='%@' , copy=1 ,upgrade=0 where id=%@ ", @"1", [ids1u objectAtIndex:dl_indexu]];
        [self.dbManager executeQuery:query];
    }

    [hud hide:YES];
    [hud removeFromSuperview];
    hud = nil;
    dl_runningu = false;


}


















//--------------------------------------------------------------------------










- (void)Error:(NSString *)msg {
    dispatch_async(dispatch_get_main_queue(), ^{

        NSString *message = error_str;


        if ([msg isEqualToString:@"103"]) {
            message = @"نام کاربری نا معتبر میباشد";
        }
        else if ([msg isEqualToString:@"111"]) {
            message = @"کتاب با موفقیت بروزرسانی شد";
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
        else if ([msg isEqualToString:@"800"]) {

            message = @"شما مجاز به دریافت این فایل نیستید";
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




//-------------------------------------------- DataBase Function ------------------------------


// gereftane etelaat az database
// keteb haee k flag upgrade anha 1 bashad niaz b update darand

- (void)GetFromDatabase {

    NSString *query = [NSString stringWithFormat:@"select * from books WHERE download = 1 and upgrade=1 "];
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];

    for (int i = 0; i < [results count]; i++) {
        [ids1u addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"id"]]];
        [name1u addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"name"]]];
        [pics1u addObject:[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"image_path"]]];

        int t = [[[results objectAtIndex:i] objectAtIndex:[self.dbManager.arrColumnNames indexOfObject:@"upgrade"]] intValue];
        if (t == 0)
            [show2u addObject:@"0"];
        else
            [show2u addObject:@"1"];
        [show1u addObject:@"0"];


    }


    [collectionView reloadData];

    collectionView.hidden = NO;

}



//----------------------------------------------------------


//------------------------------------------------------------


- (void)viewWillDisappear:(BOOL)animated {
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
    [collectionView registerNib:[UINib nibWithNibName:@"CollectionCellLibrary" bundle:nil] forCellWithReuseIdentifier:@"CollectionCellLibrary"];
    [collectionView setBackgroundView:nil];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [collectionView reloadData];
        collectionView.hidden = NO;
        [hud hide:YES];
        [hud removeFromSuperview];
        [activityIndicator stopAnimating];
    });
    _obj = [DataClass getInstance];

    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;
}





//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************


- (void)requestFinished:(ASIHTTPRequest *)request {

}

- (void)requestFailed:(ASIHTTPRequest *)request {

}

- (void)dealloc {

}


//set kardane progress hengame download shodan
- (void)setProgress:(float)progress {

    NSLog(@"Progress… %f", progress);
    [dl_cell.labeledProgressView setProgress:progress animated:YES];
    int i = dl_cell.labeledProgressView.progress * 100;
    dl_cell.labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d %%", i];
}


// setup kardane download file  b sorate resume dar va dar background
- (void)download_book:(NSString *)book_id {

    progu = 0;
    dl_cell.labeledProgressView.hidden = NO;
    [show1u replaceObjectAtIndex:dl_indexu withObject:@"1"];
    NSString *temp = @"http://intelligent-book.ir/home/MobDownload?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@", temp, @"IMEI=", imei, @"&Username=", username, @"&Id=", book_id];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:temp3];
    _obj.Request2 = [ASIHTTPRequest requestWithURL:url];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *downloadPath = [NSString stringWithFormat:@"/%@%@", book_id, book_id];;
    downloadPath = [NSString stringWithFormat:@"%@%@", documentsDirectory, downloadPath];
    NSString *tempPath = [NSString stringWithFormat:@"/%@%@%@", book_id, book_id, @".download"];
    tempPath = [NSString stringWithFormat:@"%@%@", documentsDirectory, tempPath];
    [_obj.Request2 setDownloadDestinationPath:downloadPath];
    [_obj.Request2 setTemporaryFileDownloadPath:tempPath];
    [_obj.Request2 setAllowResumeForFileDownloads:YES];
    [_obj.Request2 setDownloadProgressDelegate:self];
    [_obj.Request2 setShouldContinueWhenAppEntersBackground:YES];
    [_obj.Request2 setTimeOutSeconds:4.0];


    [_obj.Request2 setCompletionBlock:^{

        [timeru invalidate];
        timeru = nil;
        [dl_cell.labeledProgressView setProgress:progu animated:YES];
        progu = 0;
        dl_runningu = false;
        [show1u replaceObjectAtIndex:dl_indexu withObject:@"0"];
        dl_cell.labeledProgressView.progressLabel.text = [NSString stringWithFormat:@"%d %%", 100];


        NSString *dbname = [NSString stringWithFormat:@"%@%@", [ids1u objectAtIndex:dl_indexu], [ids1u objectAtIndex:dl_indexu]];
        self.dbManager3 = [[DBManager alloc] initWithDatabaseFilename:dbname];
        NSArray *columns = [self.dbManager3 getColumn:[@"select * from tbl_f_book_law " UTF8String]];

        if ([columns count] != 0) {

            NSString *query = [NSString stringWithFormat:@"update books set  download='%@' , copy=0 where id=%@ ", @"0", [ids1u objectAtIndex:dl_indexu]];
            [self.dbManager executeQuery:query];
            [self copy_book:dl_indexu];
            [show2u replaceObjectAtIndex:dl_indexu withObject:@"0"];
            if ([ids1u count] > dl_indexu) {
                [ids1u removeObjectAtIndex:dl_indexu];
                [pics1u removeObjectAtIndex:dl_indexu];
                [name1u removeObjectAtIndex:dl_indexu];
                [show1u removeObjectAtIndex:dl_indexu];
                [show2u removeObjectAtIndex:dl_indexu];

            }


        }
        else {
            [self Error:@"800"];
        }


        [_obj.Request2 cancel];
        [_obj.Request2 clearDelegatesAndCancel];
        _obj.Request2 = nil;
        [collectionView reloadData];
        dl_indexu = -1;


    }];
    [_obj.Request2 setFailedBlock:^{

        [timeru invalidate];
        timeru = nil;
        NSError *error = [_obj.Request2 error];
        if (error) {

            [self Error:@""];

        }

        [show1u replaceObjectAtIndex:dl_indexu withObject:@"0"];
        dl_indexu = -1;
        progu = 0;
        dl_runningu = false;


        [collectionView reloadData];
        [_obj.Request2 cancel];
        _obj.Request2 = nil;
        [_obj.Request2 clearDelegatesAndCancel];
        NSLog(@"%@", error);
    }];

    [_obj.Request2 startAsynchronous];
    NSString *theContent = [NSString stringWithContentsOfFile:downloadPath];
}


@end

//
//  LibraryPage2.m
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "LibraryPage3.h"
#import "SearchBook.h"

#import "DBManager.h"
#import "CellImg.h"

NSString *table;
NSString *table_link;
NSMutableDictionary *_frames3;

@interface LibraryPage3 () {

}

@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;
@property Boolean is_active_mortabetin;
@property NSInteger o;
@property NSInteger first;
@property NSInteger section;
@property Boolean open;

@end

@implementation LibraryPage3


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _frames3 = [NSMutableDictionary new];

    // tanzimate avalie
    _section = 1;// agar tozihat nadashte bashad faqat 1 section va agar dashte bashad 3 qesmat mishavad
    _open = true;

    _mortabetin_btn.layer.cornerRadius = 4;
    _mortabetin_btn.clipsToBounds = YES;


    self.content.attributedText = _body;
    NSAttributedString *at = _body;
    NSAttributedString *at2 = _body2;

    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:self.db_name];

    NSArray *f = [self.dbManager loadDataFromDB:[NSString stringWithFormat:@"select * from fav where id = %d and book =%d", _law_id, _book_id]];
    if ([f count] > 0) {
        _isFav = true;
        UIImage *btnImage;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
            btnImage = [UIImage imageNamed:@"fav_on.png1.png"];
        else
            btnImage = [UIImage imageNamed:@"fav_on.png"];

    }
    else {
        _isFav = false;
        UIImage *btnImage;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
            btnImage = [UIImage imageNamed:@"favorite_off1.png"];
        else
            btnImage = [UIImage imageNamed:@"favorite_off.png"];
        [_fav_img setBackgroundImage:btnImage forState:UIControlStateNormal];
    }


    NSArray *temp = [self.dbManager2 loadDataFromDB:@"select * from tbl_f_book_law"];
    if ([temp count] == 0)
        return;
    table = [[temp objectAtIndex:0] objectAtIndex:2];
    table_link = [[temp objectAtIndex:0] objectAtIndex:3];
    [self load_data];
    _is_active_mortabetin = [self isActive_button];
    // aya mortabetini vojod darad ?
    if (_is_active_mortabetin == false)
        _mortabetin_btn.hidden = YES;

    NSString *query;
    NSArray *allResults;
    switch (self.type) {
        case 1: {
            //index madeh in subtree (non zero based)
            query = [NSString stringWithFormat:@"select (SELECT COUNT(*) FROM %@ AS t2 WHERE t2.date >= t1.date AND sub_tree = %d) from %@ AS t1 where _id = %d ORDER BY date desc", _table, self.subtree, _table, self.law_id];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.index = [allResults[0][0] intValue]-1; //make in zero based
            
            // list of subtree of current law
            query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sub_tree = %d", _table, self.subtree];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.count = [allResults[0][0] intValue];
        }
            break;
            
        case 2: {
            //index madeh in subtree (non zero based)
            query = [NSString stringWithFormat:@"select (SELECT COUNT(*) FROM %@ AS t2 WHERE t2.date >= t1.date AND sub_tree = %d) from %@ AS t1 where _id = %d ORDER BY date desc", _table, self.subtree, _table, self.law_id];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.index = [allResults[0][0] integerValue]-1; //make in zero based
            
            // list of subtree of current law
            query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sub_tree = %d", _table, self.subtree];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.count = [allResults[0][0] integerValue];
        }
            break;
            
        case 3: {
            //index madeh in subtree (non zero based)
            query = [NSString stringWithFormat:@"select (SELECT COUNT(*) FROM %@ AS t2 WHERE t2.number <= t1.number AND sub_tree = %d) from %@ AS t1 where _id = %d ORDER BY number asc", _table, self.subtree, _table, self.law_id];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.index = [allResults[0][0] integerValue]-1; //make in zero based
            
            // list of subtree of current law
            query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sub_tree = %d", _table, self.subtree];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.count = [allResults[0][0] integerValue];
        }
            break;
            
        case 4: {
            //index madeh in subtree (non zero based)
            query = [NSString stringWithFormat:@"select (SELECT COUNT(*) FROM %@ AS t2 WHERE t2._id >= t1._id AND sub_tree = %d) from %@ AS t1 where _id = %d ORDER BY _id desc", _table, self.subtree, _table, self.law_id];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.index = [allResults[0][0] integerValue]-1; //make in zero based
            
            // list of subtree of current law
            query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sub_tree = %d", _table, self.subtree];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.count = [allResults[0][0] integerValue];
        }
            break;
            
        case 5: {
            //index madeh in subtree (non zero based)
            query = [NSString stringWithFormat:@"select (SELECT COUNT(*) FROM %@ AS t2 WHERE t2._id >= t1._id AND sub_tree = %d) from %@ AS t1 where _id = %d ORDER BY _id desc", _table, self.subtree, _table, self.law_id];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.index = [allResults[0][0] integerValue]-1; //make in zero based
            
            // list of subtree of current law
            query = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ where sub_tree = %d", _table, self.subtree];
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0) break;
            self.count = [allResults[0][0] integerValue];
        }
            break;
            
        default:
            break;
    }
    
    
}

-(void)getMinMax:(NSArray *)list
{
    NSMutableArray *array = [NSMutableArray new];
    for (NSArray *a in list) {
        [array addObject:[NSNumber numberWithInt:[a[0] intValue]]];
    }

    self.min = [[array valueForKeyPath:@"@min.intValue"] intValue];
    self.max = [[array valueForKeyPath:@"@max.intValue"] intValue];
    self.count = array.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-------------------------------------------



// gereftane etelaate made
- (void)load_data {

    NSString *query = @"";
    if (self.type == 1)
        query = [NSString stringWithFormat:@"select * from %@ where _id = %d ORDER BY date desc", _table, self.law_id];
    if (self.type == 2)
        query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan from %@ where _id = %d ORDER BY date desc", _table, self.law_id];
    if (self.type == 3)
        query = [NSString stringWithFormat:@"select _id,madeh,state , sharh, number from %@ where _id = %d ORDER BY number asc", _table, self.law_id];
    if (self.type == 4)
        query = [NSString stringWithFormat:@"select _id , number , onvan , sharh  from %@ where _id = %d ORDER BY _id desc", _table, self.law_id];
    if (self.type == 5)
        query = [NSString stringWithFormat:@"select _id , mozoo , mean from %@ where _id = %d ORDER BY _id desc", _table, self.law_id];


    NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
    if ([results2 count] == 0)
        return;


    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];

    [paragraphStyle setBaseWritingDirection:NSWritingDirectionRightToLeft];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]],
            NSBaselineOffsetAttributeName : @0,
            NSParagraphStyleAttributeName : paragraphStyle};

    [self fillBodyFromArray:results2[0] ofType:self.type];

    [tableView reloadData];


}



//-----------------------------------------------------------------

// agar mortabetin dashte bashad true bar migardanad

- (Boolean)isActive_button {

    NSString *query = @"select _id , type from tbl_f_book_law";
    NSArray *tmp = [self.dbManager loadDataFromDB:query];
    if ([tmp count] == 0)
        return false;
    NSMutableArray *ids = [[NSMutableArray alloc] init];;
    NSMutableArray *types = [[NSMutableArray alloc] init];;
    for (int j = 0; j < [tmp count]; j++) {
        [ids addObject:[[tmp objectAtIndex:j] objectAtIndex:0]];
        [types addObject:[[tmp objectAtIndex:j] objectAtIndex:1]];
    }

    query = [NSString stringWithFormat:@"select book , id_madeh from %@ where id_marja=%d and ( book=%@ ", _table_link, self.law_id, [ids objectAtIndex:0]];
    for (int i = 1; i < [ids count]; i++) {
        query = [NSString stringWithFormat:@"%@ %@ %@", query, @"OR book=", [ids objectAtIndex:i]];

    }
    query = [NSString stringWithFormat:@"%@ ) %@ ", query, @" order by book"];
    NSArray *result = [self.dbManager2 loadDataFromDB:query];
    if ([result count] == 0)
        return false;
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:self.db_name];
    return true;
}

// raftan b page mortabetin
- (IBAction)mortabetin:(UIButton *)sender {

    LibraryPage4 *page;
    page = [[LibraryPage4 alloc] initWithNibName:@"LibraryPage4_Portrait" bundle:nil];
    int lid = self.law_id;
    int bookid = self.book_id;

    page.law_id = self.law_id;
    page.book_id = self.book_id;
    page.db_name = [NSString stringWithFormat:@"%d", self.book_id];


    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;

    if (!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        transition.subtype = kCATransitionFromTop;

    }
    else {

        transition.subtype = kCATransitionFromRight;

    }


    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];

    [self.navigationController pushViewController:page animated:NO];


}


- (IBAction)fav:(UIButton *)sender {


    if (_isFav) {

        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
            [_fav_img setImage:[UIImage imageNamed:@"favorite_off1.png"] forState:UIControlStateNormal];
        else
            [_fav_img setImage:[UIImage imageNamed:@"favorite_off.png"] forState:UIControlStateNormal];


        _isFav = false;
        [self.dbManager executeQuery:[NSString stringWithFormat:@"delete  from fav where id = %d and book =%d", _law_id, _book_id]];
    }
    else {

        [self.dbManager executeQuery:[NSString stringWithFormat:@"insert into fav (id , book , type ) VALUES (%d ,%d , %d) ", _law_id, _book_id, _type]];


        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait)
            [_fav_img setImage:[UIImage imageNamed:@"fav_on1.png"] forState:UIControlStateNormal];
        else
            [_fav_img setImage:[UIImage imageNamed:@"fav_on.png"] forState:UIControlStateNormal];

        _isFav = true;
    }
}


- (IBAction)search:(UIButton *)sender {

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    SearchBook *page;

    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[SearchBook alloc] initWithNibName:@"SearchBook_Portrait" bundle:nil];
    }
    else {
        page = [[SearchBook alloc] initWithNibName:@"SearchBook_Landscape" bundle:nil];
    }


    page.type = _type;
    page.book = _book_id;
    [self.navigationController pushViewController:page animated:YES];
}

- (IBAction)share:(UIButton *)sender {

    UIButton *shareButton = (UIButton *)sender;
    NSMutableArray *sharingItems = [NSMutableArray new];


    [sharingItems addObject:_body.string];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:sharingItems applicationActivities:nil];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self presentViewController:activityController animated:YES completion:nil];
    }
        //if iPad
    else {
        // Change Rect to position Popover
        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:activityController];
        [popup presentPopoverFromRect:shareButton.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

- (IBAction)hidePane:(id)sender {
    if (self.hidden) // unhide the pane
    {
        CGFloat delay = 0;
        CGFloat x;

        [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // resize title imageView
            UIView *view = [self.view viewWithTag:201];
            CGRect frame = view.frame;
            frame.size.width = self.view.bounds.size.width-(isiPad ? 430 : 217) - 21;
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

            // resize tableView
            view = [self.view viewWithTag:202];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width- (isiPad ? 430 : 217) - 21;
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];


            // move کتابخانه label back to place
            view = [self.view viewWithTag:203];
            frame = view.frame;
            frame.size.width = (isiPad ? 537 : 54);
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

            // move pane to the right most point of self.view
            view = [self.view viewWithTag:204];
            frame = view.frame;
            frame.origin.x = self.view.bounds.size.width-(isiPad ? 387 : 197);
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

//            // resize مرطبتین
            view = [self.view viewWithTag:206];
            frame = view.frame;
            [UIView animateWithDuration:0.4 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished){
//                view.hidden = YES;
            }];
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            view = [self.view viewWithTag:205];
            frame = view.frame;
            [UIView animateWithDuration:0.4 animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished){
//                view.hidden = NO;
            }];
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
        } completion:^(BOOL finished) {
        }];


        for (int i=101;i<=107;i++)
        {
            switch (i) {
                case 101:
                case 105:
                    x = self.view.bounds.size.width - (isiPad ? 300 : 157) - (isiPad ? 70.0/2 : 35.0/2);
                    break;

                case 102:
                case 104:
                    x = self.view.bounds.size.width - (isiPad ? 294 : 150) - (isiPad ? 70.0/2 : 35.0/2);
                    break;

                case 103:
                    x = self.view.bounds.size.width - (isiPad ? 292 : 148) - (isiPad ? 70.0/2 : 35.0/2);
                    break;

                case 106:
                    x = self.view.bounds.size.width - (isiPad ? 324 : 167) - (isiPad ? 70.0/2 : 35.0/2);
                    break;

                case 107:
                    x = self.view.bounds.size.width - (isiPad ? 410 : 186) - 35.0/2;
                    break;

                default:
                    break;
            }

            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CGPoint center = button.center;
            center.x = x;
            [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.center = center;
                [_frames3 setObject:[NSValue valueWithCGRect:button.frame] forKey:[NSNumber numberWithInteger:button.tag]];

            } completion:^(BOOL finished) {
                if (button.tag == 106) {
                    [button setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
                }
            }];
            delay += 0.05;
        }

    } else {        // hide the pane
        CGFloat delay = 0;

        for (int i=101;i<=107;i++)
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CGPoint center = button.center;
            center.x = self.view.bounds.size.width - (isiPad ? 40 : 20);
            if (i == 107) center.x = self.view.bounds.size.width - (isiPad ? 100 : 50);
            [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.center = center;
                [_frames3 setObject:[NSValue valueWithCGRect:button.frame] forKey:[NSNumber numberWithInteger:button.tag]];
            } completion:^(BOOL finished) {

            }];
            delay += 0.05;
        }

        [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // resize title imageView
            UIView *view = [self.view viewWithTag:201];
            CGRect frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 110 : 50);
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

            // resize tableView
            view = [self.view viewWithTag:202];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 110 : 50);
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

            // move کتابخانه label to right
            view = [self.view viewWithTag:203];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 110 : 50);
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

            // move pane to the right most point of self.view
            view = [self.view viewWithTag:204];
            frame = view.frame;
            frame.origin.x = self.view.bounds.size.width - (isiPad ? 30 : 15);
            view.frame = frame;
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];

            // resize مرطبتین
            view = [self.view viewWithTag:205];
            frame = view.frame;
            [UIView animateWithDuration:0.4 animations:^{
                view.alpha = 0;
            } completion:^(BOOL finished){
//                view.hidden = YES;
            }];
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            view = [self.view viewWithTag:206];
            frame = view.frame;
            [UIView animateWithDuration:0.4 animations:^{
                view.alpha = 1;
            } completion:^(BOOL finished){
//                view.hidden = NO;
            }];
            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
//            frame = view.frame;
//            [view invalidateIntrinsicContentSize];
//            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 110 : 50);
//            view.frame = frame;
//            [_frames3 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
        } completion:^(BOOL finished) {
            [((UIButton *)[self.view viewWithTag:106]) setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        }];
    }
    self.hidden = !self.hidden;
}



//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
- (IBAction)mytestbuttonTapped:(id)sender {

}


-(NSArray *)getItemFromDBWithOrder:(ItemOrder)order {

    NSString *query = @"";
    NSArray *allResults;
    switch (self.type) {
        case 1: {
            int index = self.index;
            if (order == kItemOrderNext) {
                index++;
                if (index >= self.count) return  nil;
                query = [NSString stringWithFormat:@"select * from %@ WHERE sub_tree = %d ORDER BY date desc limit 1 offset %d", _table, self.subtree, index];
            } else {
                index--;
                if (index < 0) return nil;
                query = [NSString stringWithFormat:@"select * from %@ WHERE sub_tree = %d ORDER BY date desc limit 1 offset %d", _table, self.subtree, index];
            }
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0)
                return nil;

            self.index = index;
            _date = allResults[0][4];
            self.law_id = [allResults[0][0] intValue];
        }
            break;

        case 2: {
            int index = self.index;
            if (order == kItemOrderNext) {
                index++;
                if (index >= self.count) return  nil;
                query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan from %@ WHERE sub_tree = %d ORDER BY date desc limit 1 offset %d", _table, self.subtree,index];
            } else {
                index--;
                if (index < 0) return nil;
                query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan from %@ WHERE sub_tree = %d ORDER BY date desc limit 1 offset %d", _table, self.subtree,index];
            }
            
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0)
                return nil;
            
            self.index = index;
            _date = allResults[0][2];
            self.law_id = [allResults[0][0] intValue];
        }
            break;
            
        case 3: {
            int index = self.index;
            if (order == kItemOrderNext) {
                index++;
                if (index >= self.count) return  nil;
                query = [NSString stringWithFormat:@"select _id,madeh,state , sharh, number from %@ where sub_tree = %d ORDER BY number asc limit 1 offset %d", _table, self.subtree, index];
            } else {
                index--;
                if (index < 0) return nil;
                query = [NSString stringWithFormat:@"select _id,madeh,state , sharh, number from %@ where sub_tree = %d ORDER BY number asc limit 1 offset %d", _table, self.subtree, index];
            }
            
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0)
                return nil;
            
            self.index = index;
            _number = allResults[0][4];
            self.law_id = [allResults[0][0] intValue];
        }
            break;
            
        case 4: {
            int index = self.index;
            if (order == kItemOrderNext) {
                index++;
                if (index >= self.count) return  nil;
                query = [NSString stringWithFormat:@"select _id , number , onvan , sharh  from %@ WHERE sub_tree = %d ORDER BY _id desc limit 1 offset %d", _table, self.subtree, index];
            } else {
                index--;
                if (index < 0) return nil;
                query = [NSString stringWithFormat:@"select _id , number , onvan , sharh  from %@ WHERE sub_tree = %d ORDER BY _id desc limit 1 offset %d", _table, self.subtree, index];
            }
            
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0)
                return nil;
            
            self.index = index;
            _number = allResults[0][1];
            self.law_id = [allResults[0][0] intValue];
        }
            break;
            
        case 5: {
            int index = self.index;
            if (order == kItemOrderNext) {
                index++;
                if (index >= self.count) return  nil;
                query = [NSString stringWithFormat:@"select _id , mozoo , mean from %@ WHERE  sub_tree = %d ORDER BY _id desc limit 1 offset %d", _table, self.subtree, index];
            } else {
                index--;
                if (index < 0) return nil;
                query = [NSString stringWithFormat:@"select _id , mozoo , mean from %@ WHERE sub_tree = %d ORDER BY _id desc limit 1 offset %d", _table, self.subtree, index];
            }
            
            allResults = [self.dbManager2 loadDataFromDB:query];
            if (allResults.count == 0)
                return nil;
            
            self.index = index;
            self.law_id = [allResults[0][0] intValue];
        }
            break;
    }
    return allResults[0];
}


- (void)fillBodyFromArray:(NSArray *)result ofType:(int)type {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentJustified;
    [paragraphStyle setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];
//
    [paragraphStyle setBaseWritingDirection:NSWritingDirectionRightToLeft];
    NSDictionary *attributes = @{NSFontAttributeName : [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]],
            NSBaselineOffsetAttributeName : @0,
            NSParagraphStyleAttributeName : paragraphStyle};

    switch (type) {
        case 1: {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
            NSString *number = [result objectAtIndex:3];
            NSString *date = [result objectAtIndex:4];
            NSString *sharh = [result objectAtIndex:6];

            NSString *tmp = [NSString stringWithFormat:@"%@ : %@        %@  \n%@", nazarie_shomare, number, date, sharh];
            //tmp = [tmp stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
            [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];

            NSRange range1 = [tmp rangeOfString:number];
            NSRange range2 = [tmp rangeOfString:date];
            NSRange range3 = [tmp rangeOfString:nazarie_shomare];

            NSRange range = [tmp rangeOfString:tmp];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];

            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range3];
            self.content.attributedText = attString;
            _body = attString;
        }
            break;

        case 2: {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
            NSString *r = [dict objectForKey:@"ray"];
            NSString *mozo = [dict objectForKey:@"type5"];

            NSString *number = [result objectAtIndex:1];
            NSString *date = [result objectAtIndex:2];
            NSString *ray = [result objectAtIndex:3];
            NSString *onvan = [result objectAtIndex:4];

            NSString *sds = @"  رای";
            NSString *tmp = [NSString stringWithFormat:@"%@ %@        %@ \n\n%@ \n%@ \n%@ \n%@ ", ray_shomare, number, date, mozo, onvan, sds, ray];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
            [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];

            NSRange range = [tmp rangeOfString:tmp];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];

            NSRange range1 = [tmp rangeOfString:number];
            NSRange range2 = [tmp rangeOfString:date];
            NSRange range3 = [tmp rangeOfString:ray_shomare];
            NSRange range4 = [tmp rangeOfString:sds];

            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range3];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range4];
            NSRange range5 = [tmp rangeOfString:onvan];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range5];

            NSRange range6 = [tmp rangeOfString:mozo];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range6];

            self.content.attributedText = attString;
            _body = attString;

        }
            break;

        case 3: {
            NSString *madeh = [result objectAtIndex:1];
            NSString *sharh = [result objectAtIndex:3];
            _number = [result objectAtIndex:4];
            NSString *ss = [NSString stringWithFormat:@"%@", sharh];

            NSString *trimmedString = [ss stringByTrimmingCharactersInSet:
                    [NSCharacterSet whitespaceCharacterSet]];

            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *tozihat = [dict objectForKey:@"tozihat"];
            NSMutableAttributedString *attString;
            NSMutableAttributedString *attString2;
            int empty = 1;
            NSString *tmp;
            if ([trimmedString isEqualToString:@""]) {
                attString = [[NSMutableAttributedString alloc] initWithString:madeh];
                [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];

            }
            else {
                empty = 0;
                tmp = [NSString stringWithFormat:@"%@\n\n", madeh];
                attString = [[NSMutableAttributedString alloc] initWithString:tmp];
                attString2 = [[NSMutableAttributedString alloc] initWithString:sharh];
                [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];
                [attString2 setAttributes:attributes range:NSMakeRange(0, attString2.length)];
            }

            int state = [[result objectAtIndex:2] intValue];

            //NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:madeh];
            NSRange range1 = [madeh rangeOfString:madeh];
            NSRange range2;
            if (empty == 0) {
                range2 = [sharh rangeOfString:sharh];
                _section = 3;

            }


            if (empty == 0) {
                NSRange range = [tmp rangeOfString:tmp];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
                [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range2];
            }
            else {

                NSRange range = [madeh rangeOfString:madeh];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];
            }


            if (state == 2) {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
                if (empty == 0) {
                    [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                }
            }
            if (state == 3) {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:range1];
                if (empty == 0) {
                    [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                }
            }
            if (state == 4) {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
                if (empty == 0) {
                    [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                }
            }
            if (state == 5) {
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];
                if (empty == 0) {
                    [attString2 addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                }
            }

            self.content.attributedText = attString;
            self.content2.attributedText = attString2;
            _body = attString;
            _body2 = attString2;

        }
            break;

        case 4: {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *type4_str = [dict objectForKey:@"type4"];
            NSString *mozo = [dict objectForKey:@"type5"];
            NSString *number = [result objectAtIndex:1];
            NSString *onvan = [result objectAtIndex:2];
            NSString *sharh = [result objectAtIndex:3];

            if ([number isEqualToString:@""]) {
                type4_str = @"";
            }

            NSString *tmp = [NSString stringWithFormat:@"%@ %@\n%@  \n%@  \n%@ ", type4_str, number, mozo, onvan, sharh];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
            [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];
            NSRange range1 = [tmp rangeOfString:type4_str];
            NSRange range2 = [tmp rangeOfString:number];
            NSRange range3 = [tmp rangeOfString:onvan];
            NSRange range4 = [tmp rangeOfString:mozo];


            NSRange range = [tmp rangeOfString:tmp];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range];

            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range3];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range4];
            self.content.attributedText = attString;
            _body = attString;

        }
            break;

        case 5: {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *type5_str = [dict objectForKey:@"type5"];

            NSString *mozoo = [result objectAtIndex:1];
            NSString *mean = [result objectAtIndex:2];


            NSString *tmp = [NSString stringWithFormat:@"%@ %@ \n%@", type5_str, mozoo, mean];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
            [attString setAttributes:attributes range:NSMakeRange(0, attString.length)];
            NSRange range1 = [tmp rangeOfString:type5_str];
            NSRange range2 = [tmp rangeOfString:mozoo];
            NSRange range3 = [tmp rangeOfString:tmp];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:range3];

            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
            self.content.attributedText = attString;
            _body = attString;
        }
            break;

        default:
            break;
    }
}

- (IBAction)forwardTapped:(id)sender {
    NSArray *result = [self getItemFromDBWithOrder:kItemOrderNext];
    if (result)
    {
        [self fillBodyFromArray:result ofType:self.type];
        _is_active_mortabetin = [self isActive_button];
        // aya mortabetini vojod darad ?
        if (_is_active_mortabetin == false) {
            _mortabetin_btn.hidden = YES;
            _mortabetin_btn_wide.hidden = YES;
        } else {
            _mortabetin_btn.hidden = NO;
            _mortabetin_btn_wide.hidden = NO;
        }
        [tableView reloadData];
    }
}

- (IBAction)backwardTapped:(id)sender {
    NSArray *result = [self getItemFromDBWithOrder:kItemOrderPrevious];
    if (result)
    {
        [self fillBodyFromArray:result ofType:self.type];
        _is_active_mortabetin = [self isActive_button];
        // aya mortabetini vojod darad ?
        if (_is_active_mortabetin == false) {
            _mortabetin_btn.hidden = YES;
            _mortabetin_btn_wide.hidden = YES;
        } else {
            _mortabetin_btn.hidden = NO;
            _mortabetin_btn_wide.hidden = NO;
        }
        [tableView reloadData];
    }
}

- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)home:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForNewOrientation:self.interfaceOrientation];

    if (_is_active_mortabetin == false) {
        _mortabetin_btn.hidden = YES;
        _mortabetin_btn_wide.hidden = YES;
    } else {
        _mortabetin_btn.hidden = NO;
        _mortabetin_btn_wide.hidden = NO;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        if (_frames3.count) {
            if (self.hidden) {
                _mortabetin_btn_wide.alpha = 1;
                _mortabetin_btn.alpha = 0;
                [((UIButton*)([self.view viewWithTag:106])) setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
            } else {
                _mortabetin_btn_wide.alpha = 0;
                _mortabetin_btn.alpha = 1;
                [((UIButton*)([self.view viewWithTag:106])) setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
            }
            for (NSNumber *key in _frames3)
            {
                CGRect frame = [[_frames3 objectForKey:key] CGRectValue];
                NSInteger tag = [key integerValue];
                UIView *view = [self.view viewWithTag:tag];
                view.frame = frame;
            }
        } else {
            if (self.hidden) {
                self.hidden = !self.hidden; // for hide toggle to work properly
                [self hidePane:self];
            }
        }
    });
}


- (void)viewWillAppear:(BOOL)animated {
    //[super viewDidAppear:animated];
    [super viewWillAppear:animated];
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


    _mortabetin_btn.layer.cornerRadius = 4;
    _mortabetin_btn.clipsToBounds = YES;
    if (_is_active_mortabetin == false)
        _mortabetin_btn.hidden = YES;

    if (_isFav) {
        _isFav = true;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            self.hidden = NO;
            [_fav_img setImage:[UIImage imageNamed:@"fav_on1.png"] forState:UIControlStateNormal];
        }
        else
            [_fav_img setImage:[UIImage imageNamed:@"fav_on.png"] forState:UIControlStateNormal];

    }
    else {
        _isFav = false;
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            self.hidden = NO;
            [_fav_img setImage:[UIImage imageNamed:@"favorite_off1.png"] forState:UIControlStateNormal];
        }
        else
            [_fav_img setImage:[UIImage imageNamed:@"favorite_off.png"] forState:UIControlStateNormal];


    }


    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;


    UIColor *color = [[UIColor alloc] initWithRed:0 green:0 blue:0 alpha:0.2];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:color];
    tableView.layer.cornerRadius = 5;
    tableView.clipsToBounds = YES;

}










//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************




//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _section;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellImg *cell;
    static NSString *simpleTableIdentifier1 = @"CellMade1";
    static NSString *simpleTableIdentifier2 = @"CellMade2";
    if (indexPath.row == 1)
        cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier2];
    else
        cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier1];

    if (cell == nil) {
        NSArray *nib;
        if (indexPath.row == 1) {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CellMade2" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        else {
            nib = [[NSBundle mainBundle] loadNibNamed:@"CellMade1" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }


    [cell setBackgroundColor:[UIColor clearColor]];


    cell.btn.layer.cornerRadius = 7;
    cell.btn.clipsToBounds = YES;
    [[cell.btn layer] setBorderWidth:1.3f];
    [[cell.btn layer] setBorderColor:[self colorWithHexString:@"553405"].CGColor];


    cell.btn.tag = indexPath.row;
    [cell.btn addTarget:self action:@selector(desc_click:) forControlEvents:UIControlEventTouchUpInside];


    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    NSLog(@"%d", self.type);

    if (indexPath.row == 0)
        cell.txt.attributedText = _body;
    if (indexPath.row == 2)
        cell.txt.attributedText = _body2;


    if (indexPath.row == 1 && _open == true)
        cell.txt.text = @"-";
    if (indexPath.row == 1 && _open == false)
        cell.txt.text = @"+";

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

}


// tabeie click roie tozihat
- (void)desc_click:(UIButton *)sender {
    if (_open == true) {
        _section--;
        _open = false;
    }
    else {
        _section++;
        _open = true;
    }
    [tableView reloadData];
}




// ertefae string ra bar asase size va noe font barmigardanad

- (float)getSize:(NSAttributedString *)str {


    CGFloat width = tableView.frame.size.width - 17;  //tableView width - left border width - accessory indicator - right border width
    UIFont *font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];
    CGRect rect = [str boundingRectWithSize:(CGSize) {width, CGFLOAT_MAX}
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    context:nil];
    CGSize size = rect.size;
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);
    return size.height + 15;


}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    UILabel *temp = [[UILabel alloc] init];
    if (indexPath.row == 0)
        temp.attributedText = _body;
    else if (indexPath.row == 2)
        temp.attributedText = _body2;


    if (indexPath.row == 0 || indexPath.row == 2)
        return [self getSize:temp.attributedText] + 20;
    else
        return 39;

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


@end

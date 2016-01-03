//
//  LibraryPage2.m
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "LibraryPage4.h"
#import "LibraryPage3.h"


#import "DBManager.h"
#import "CellImg.h"


@interface LibraryPage4 ()

@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;

@end

@implementation LibraryPage4

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
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:self.db_name];

    NSArray *temp = [self.dbManager2 loadDataFromDB:@"select * from tbl_f_book_law"];
    if ([temp count] == 0)
        return;
    _table = [[temp objectAtIndex:0] objectAtIndex:2];
    _table_link = [[temp objectAtIndex:0] objectAtIndex:3];

    _law_ids = [[NSMutableArray alloc] init];
    _content = [[NSMutableArray alloc] init];
    _mode = [[NSMutableArray alloc] init];
    _book_ids = [[NSMutableArray alloc] init];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self load_data];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//-------------------------------------------


// load kardane mortabetin ba tajoh b ketab haee k download shode
// mode=1>>>made + title (name ketab ham hamrahe an hast va header darad >CellMortabetin)
// mode=0>>>made + title (name ketab ham hamrahe an hast va header darad >CellMortabetin2)

- (void)load_data {

    NSString *query = @"select _id , type from tbl_f_book_law";
    NSArray *tmp = [self.dbManager loadDataFromDB:query];
    if ([tmp count] == 0)
        return;
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
        return;



    //------------------------
    for (int i = 0; i < [ids count]; i++) {
        NSMutableArray *laws = [[NSMutableArray alloc] init];
        for (int x = 0; x < [result count]; x++) {

            if ([[ids objectAtIndex:i] intValue] == [[[result objectAtIndex:x] objectAtIndex:0] intValue])
                [laws addObject:[[result objectAtIndex:x] objectAtIndex:1]];
        }
        if ([laws count] == 0)
            continue;

        //-------------
        NSString *temp_name = [NSString stringWithFormat:@"%@", [ids objectAtIndex:i]];
        self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];
        NSString *query = @"select tablee from tbl_f_book_law";

        NSArray *tmp2 = [self.dbManager2 loadDataFromDB:query];
        if ([tmp2 count] == 0)
            continue;

        NSString *tbl = [[tmp2 objectAtIndex:0] objectAtIndex:0];
        int tbl_type = [[types objectAtIndex:i] intValue];


        NSString *q = [NSString stringWithFormat:@"_id = %@ ", [laws objectAtIndex:0]];
        for (int x = 1; x < [laws count]; x++)
            q = [NSString stringWithFormat:@"%@ OR _id = %@ ", q, [laws objectAtIndex:x]];

        if (tbl_type == 1)
            query = [NSString stringWithFormat:@"select * from %@ where %@ ORDER BY date desc", tbl, q];
        if (tbl_type == 2)
            query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan from %@ where %@ ORDER BY date desc", tbl, q];
        if (tbl_type == 3)
            query = [NSString stringWithFormat:@"select _id,madeh,state from %@ where %@ ORDER BY number asc", tbl, q];
        if (tbl_type == 4)
            query = [NSString stringWithFormat:@"select _id , number , onvan , sharh  from %@ where %@ ORDER BY _id desc", tbl, q];
        if (tbl_type == 5)
            query = [NSString stringWithFormat:@"select _id , mozoo , mean from %@ where %@ ORDER BY _id desc", tbl, q];


        NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
        if ([results2 count] == 0)
            continue;


        int temp_i = i;
        if (tbl_type == 1) {

            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
            for (int i = 0; i < [results2 count]; i++) {

                [_book_ids addObject:[ids objectAtIndex:temp_i]];
                [_law_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                NSString *number = [[results2 objectAtIndex:i] objectAtIndex:3];
                NSString *date = [[results2 objectAtIndex:i] objectAtIndex:4];
                NSString *sharh = [[results2 objectAtIndex:i] objectAtIndex:6];

                NSString *tmp = [NSString stringWithFormat:@"%@ %@ , %@ , %@", nazarie_shomare, number, date, sharh];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
                NSRange range1 = [tmp rangeOfString:number];
                NSRange range2 = [tmp rangeOfString:date];
                NSRange range3 = [tmp rangeOfString:nazarie_shomare];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range3];
                [_content addObject:attString];

                if (i == 0)
                    [_mode addObject:@"1"];
                else
                    [_mode addObject:@"0"];

            }
        }


        if (tbl_type == 2) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
            for (int i = 0; i < [results2 count]; i++) {

                [_book_ids addObject:[ids objectAtIndex:temp_i]];
                [_law_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                NSString *number = [[results2 objectAtIndex:i] objectAtIndex:1];
                NSString *date = [[results2 objectAtIndex:i] objectAtIndex:2];
                NSString *ray = [[results2 objectAtIndex:i] objectAtIndex:3];
                NSString *onvan = [[results2 objectAtIndex:i] objectAtIndex:4];


                NSString *tmp = [NSString stringWithFormat:@"%@ %@ , %@ , %@ ,%@ ", ray_shomare, number, date, onvan, ray];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
                NSRange range1 = [tmp rangeOfString:number];
                NSRange range2 = [tmp rangeOfString:date];
                NSRange range3 = [tmp rangeOfString:ray_shomare];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range3];

                NSRange range4 = [tmp rangeOfString:onvan];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range4];

                [_content addObject:attString];
                if (i == 0)
                    [_mode addObject:@"1"];
                else
                    [_mode addObject:@"0"];

            }
        }


        if (tbl_type == 3) {

            for (int i = 0; i < [results2 count]; i++) {

                [_book_ids addObject:[ids objectAtIndex:temp_i]];
                [_law_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                NSString *madeh = [[results2 objectAtIndex:i] objectAtIndex:1];
                int state = [[[results2 objectAtIndex:i] objectAtIndex:2] intValue];

                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:madeh];
                NSRange range1 = [madeh rangeOfString:madeh];
                if (state == 2)
                    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range1];
                if (state == 3)
                    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor purpleColor] range:range1];
                if (state == 4)
                    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
                if (state == 5)
                    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:range1];

                [_content addObject:attString];
                if (i == 0)
                    [_mode addObject:@"1"];
                else
                    [_mode addObject:@"0"];

            }
        }


        if (tbl_type == 4) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *type4_str = [dict objectForKey:@"type4"];
            for (int i = 0; i < [results2 count]; i++) {

                [_book_ids addObject:[ids objectAtIndex:temp_i]];
                [_law_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                NSString *number = [[results2 objectAtIndex:i] objectAtIndex:1];
                NSString *onvan = [[results2 objectAtIndex:i] objectAtIndex:2];
                NSString *sharh = [[results2 objectAtIndex:i] objectAtIndex:3];

                if ([number isEqualToString:@""])
                    type4_str = @"";

                NSString *tmp = [NSString stringWithFormat:@"%@ %@ , %@ , %@ ", type4_str, number, onvan, sharh];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
                NSRange range1 = [tmp rangeOfString:type4_str];
                NSRange range2 = [tmp rangeOfString:number];
                NSRange range3 = [tmp rangeOfString:onvan];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range3];
                [_content addObject:attString];
                if (i == 0)
                    [_mode addObject:@"1"];
                else
                    [_mode addObject:@"0"];

            }
        }


        if (tbl_type == 5) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *type5_str = [dict objectForKey:@"type5"];
            for (int i = 0; i < [results2 count]; i++) {

                [_book_ids addObject:[ids objectAtIndex:temp_i]];
                [_law_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];

                NSString *mozoo = [[results2 objectAtIndex:i] objectAtIndex:1];
                NSString *mean = [[results2 objectAtIndex:i] objectAtIndex:2];


                NSString *tmp = [NSString stringWithFormat:@"%@ %@ \n %@", type5_str, mozoo, mean];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
                NSRange range1 = [tmp rangeOfString:type5_str];
                NSRange range2 = [tmp rangeOfString:mozoo];

                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                [_content addObject:attString];
                [_mode addObject:@"0"];
                if (i == 0)
                    [_mode addObject:@"1"];
                else
                    [_mode addObject:@"0"];

            }
        }

    }


}


//------------------------------------- TABLEVIEW FUNCTION ----------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    CellImg *cell;
    if ([[_mode objectAtIndex:indexPath.row] intValue] == 0) {
        static NSString *simpleTableIdentifier = @"CellMortabetin2";
        cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellMortabetin2" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }


    }
    else {
        static NSString *simpleTableIdentifier = @"CellMortabetin";
        cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellMortabetin" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
    }

    cell.bg.layer.cornerRadius = 10;
    cell.bg.clipsToBounds = YES;
    cell.txt.font = [UIFont fontWithName:@"BYekan" size:16.0];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {


    if ([[_mode objectAtIndex:indexPath.row] intValue] == 0)
        return 140;
    return 190;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableAttributedString *attrString = [_content objectAtIndex:indexPath.row];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [attrString length])];
    cell.txt.attributedText = attrString;
    cell.txt.textAlignment = NSTextAlignmentRight;
    cell.txt.font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];

    //-------------






    NSString *temp_name = [NSString stringWithFormat:@"%@", [_book_ids objectAtIndex:indexPath.row]];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];


    NSString *query = [NSString stringWithFormat:@"select name from tbl_f_book_law where _id = %@", [_book_ids objectAtIndex:indexPath.row]];
    NSArray *tmp2 = [self.dbManager loadDataFromDB:query];
    if ([tmp2 count] == 0)
        return;
    cell.txt_header.text = [[tmp2 objectAtIndex:0] objectAtIndex:0];
    CGRect f = cell.header.frame;
    CGRect f2 = cell.txt_header.frame;


}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    LibraryPage3 *page;

    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Portrait" bundle:nil];
    }
    else {
        page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Landscape" bundle:nil];
    }


    page.law_id = [[_law_ids objectAtIndex:indexPath.row] intValue];
    page.db_name = [NSString stringWithFormat:@"%d", [[_book_ids objectAtIndex:indexPath.row] intValue]];


    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:[NSString stringWithFormat:@"%d", [[_book_ids objectAtIndex:indexPath.row] intValue]]];
    NSArray *t = [self.dbManager2 loadDataFromDB:@"select * from tbl_f_book_law"];
    if ([t count] == 0)
        return;

    page.table = [[t objectAtIndex:0] objectAtIndex:2];;
    page.table_link = [[t objectAtIndex:0] objectAtIndex:3];
    page.book_id = [[_book_ids objectAtIndex:indexPath.row] intValue];


    NSArray *t2 = [self.dbManager loadDataFromDB:[NSString stringWithFormat:@"select type from tbl_f_book_law where _id = %d", [[_book_ids objectAtIndex:indexPath.row] intValue]]];
    if ([t count] == 0)
        return;

    page.type = [[[t2 objectAtIndex:0] objectAtIndex:0] intValue];

    [self.navigationController pushViewController:page animated:YES];


}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_law_ids count];
}


//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
- (IBAction)back:(UIButton *)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;

    if (!UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        transition.subtype = kCATransitionFromBottom;

    } else if (self.interfaceOrientation == UIDeviceOrientationLandscapeRight) {

        transition.subtype = kCATransitionFromLeft;
    } else {
        transition.subtype = kCATransitionFromRight;
    }
    transition.delegate = self;
    [self.navigationController.view.layer addAnimation:transition forKey:kCATransition];


    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)home:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}



//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************












@end

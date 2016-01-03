//
//  LibraryPage2.m
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "FavPage.h"
#import "LibraryPage3.h"


#import "DBManager.h"
#import "CellImg.h"


@interface FavPage ()

@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;
@property NSInteger row_num;
@end

@implementation FavPage


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrientation) name:UIDeviceOrientationDidChangeNotification object:nil];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];

    _ids = [[NSMutableArray alloc] init];
    _book_ids = [[NSMutableArray alloc] init];
    _content = [[NSMutableArray alloc] init];
    _name = [[NSMutableArray alloc] init];
    _types = [[NSMutableArray alloc] init];

    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];


    [self load_data];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// load kardane  alaaqe mandi ha az table fav dar
- (void)load_data {
    NSString *query = @"select id , book , type from fav ";
    NSArray *results = [self.dbManager loadDataFromDB:query];
    if ([results count] == 0)
        return;

    for (int i = 0; i < [results count]; i++) {
        [_ids addObject:[[results objectAtIndex:i] objectAtIndex:0]];
        [_book_ids addObject:[[results objectAtIndex:i] objectAtIndex:1]];
        [_types addObject:[[results objectAtIndex:i] objectAtIndex:2]];
    }

    for (int i = 0; i < [results count]; i++) {

        NSString *query = @"";
        NSString *temp_name = [NSString stringWithFormat:@"%@", [_book_ids objectAtIndex:i]];
        self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];


        NSArray *temp = [self.dbManager2 loadDataFromDB:@"select tablee , name from tbl_f_book_law"];
        if ([temp count] == 0)
            return;
        NSString *table = [[temp objectAtIndex:0] objectAtIndex:0];
        [_name addObject:[[temp objectAtIndex:0] objectAtIndex:1]];


        if ([[_types objectAtIndex:i] intValue] == 1)
            query = [NSString stringWithFormat:@"select * from %@ where _id = %@ ORDER BY date desc", table, [_ids objectAtIndex:i]];
        if ([[_types objectAtIndex:i] intValue] == 2)
            query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan from %@ where _id = %@ ORDER BY date desc", table, [_ids objectAtIndex:i]];
        if ([[_types objectAtIndex:i] intValue] == 3)
            query = [NSString stringWithFormat:@"select _id, madeh , state from %@ where _id = %@ ORDER BY number asc", table, [_ids objectAtIndex:i]];
        if ([[_types objectAtIndex:i] intValue] == 4)
            query = [NSString stringWithFormat:@"select _id , number , onvan , sharh  from %@ where _id = %@ ORDER BY _id desc", table, [_ids objectAtIndex:i]];
        if ([[_types objectAtIndex:i] intValue] == 5)
            query = [NSString stringWithFormat:@"select _id , mozoo , mean from %@ where _id = %@ ORDER BY _id desc", table, [_ids objectAtIndex:i]];


        NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
        if ([results2 count] == 0)
            return;


        if ([[_types objectAtIndex:i] intValue] == 1) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
            for (int i = 0; i < [results2 count]; i++) {


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


            }
        }


        if ([[_types objectAtIndex:i] intValue] == 2) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
            for (int i = 0; i < [results2 count]; i++) {


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
                [_content addObject:attString];

            }
        }


        if ([[_types objectAtIndex:i] intValue] == 3) {

            for (int i = 0; i < [results2 count]; i++) {


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


            }
        }


        if ([[_types objectAtIndex:i] intValue] == 4) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *type4_str = [dict objectForKey:@"type4"];
            for (int i = 0; i < [results2 count]; i++) {


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


            }
        }


        if ([[_types objectAtIndex:i] intValue] == 5) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *type5_str = [dict objectForKey:@"type5"];
            for (int i = 0; i < [results2 count]; i++) {


                NSString *mozoo = [[results2 objectAtIndex:i] objectAtIndex:1];
                NSString *mean = [[results2 objectAtIndex:i] objectAtIndex:2];


                NSString *tmp = [NSString stringWithFormat:@"%@ %@ \n %@", type5_str, mozoo, mean];
                NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
                NSRange range1 = [tmp rangeOfString:type5_str];
                NSRange range2 = [tmp rangeOfString:mozoo];

                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
                [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
                [_content addObject:attString];

            }
        }


    }


    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });


}



















//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_content count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CellFav";

    CellImg *cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];


    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellFav" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }


    cell.dislike.tag = indexPath.row;
    [cell.dislike addTarget:self action:@selector(delete_row:) forControlEvents:UIControlEventTouchUpInside];


    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    cell.bg.layer.cornerRadius = 10;
    cell.bg.clipsToBounds = YES;

    [cell setBackgroundColor:[UIColor clearColor]];
    cell.txt.font = [UIFont fontWithName:@"BYekan" size:16.0];


    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {

    return 145;

}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.txt_header.text = [_name objectAtIndex:indexPath.row];

    NSMutableAttributedString *attrString = [_content objectAtIndex:indexPath.row];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue]];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [attrString length])];
    cell.txt.attributedText = attrString;
    cell.txt.textAlignment = NSTextAlignmentRight;
    cell.txt.font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];
    cell.txt_header.font = [UIFont fontWithName:@"BYekan" size:18.0];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    LibraryPage3 *page;


    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Portrait" bundle:nil];
    }
    else {
        page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Landscape" bundle:nil];
    }


    page.law_id = [[_ids objectAtIndex:indexPath.row] intValue];
    page.db_name = [NSString stringWithFormat:@"%@", [_book_ids objectAtIndex:indexPath.row]];


    NSString *temp_name = [NSString stringWithFormat:@"%@", [_book_ids objectAtIndex:indexPath.row]];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];
    NSArray *temp = [self.dbManager2 loadDataFromDB:@"select tablee , table_link from tbl_f_book_law"];
    if ([temp count] == 0)
        return;
    NSString *table = [[temp objectAtIndex:0] objectAtIndex:0];
    NSString *tabl_link = [[temp objectAtIndex:0] objectAtIndex:1];


    page.table = table;
    page.table_link = tabl_link;
    page.book_id = [[_book_ids objectAtIndex:indexPath.row] intValue];
    page.type = [[_types objectAtIndex:indexPath.row] intValue];
    [self.navigationController pushViewController:page animated:YES];


}


- (void)delete_row:(UIButton *)sender {


    NSLog([NSString stringWithFormat:@"%ld", (long) sender.tag]);

    [self.dbManager executeQuery:[NSString stringWithFormat:@"DELETE  from fav where id = %@ and book = %@", [_ids objectAtIndex:sender.tag], [_book_ids objectAtIndex:sender.tag]]];
    [_ids removeObjectAtIndex:sender.tag];
    [_name removeObjectAtIndex:sender.tag];
    [_content removeObjectAtIndex:sender.tag];
    [_book_ids removeObjectAtIndex:sender.tag];
    [_types removeObjectAtIndex:sender.tag];


    [tableView reloadData];

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


- (void)changeOrientation {


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
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    if ([visible count] != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
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

}

//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************












@end

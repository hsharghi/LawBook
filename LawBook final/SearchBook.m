//
//  SearchPage.m
//  LawBook final
//
//  Created by saeid on 11/22/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import "SearchBook.h"
#import "LibraryPage3.h"
#import "DBManager.h"
#import "CellImg.h"

@interface SearchBook ()
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;

@property NSInteger row_num;
@end

@implementation SearchBook


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    // setup avalie
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _ids = [[NSMutableArray alloc] init];
    _subtrees = [NSMutableArray new];
    _content = [[NSMutableArray alloc] init];


    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];

    NSString *temp_name = [NSString stringWithFormat:@"%d", _book];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];


    [self.search addTarget:self
                    action:@selector(updateSearchString:)
          forControlEvents:UIControlEventEditingChanged];

    self.search.delegate = self;
    self.search.returnKeyType = UIReturnKeyDone;


}


// navigation button function

- (IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// zamani k text field avaz mishavad meqdarash farakhani mishavad
- (void)updateSearchString:(NSString *)SearchString {


    [_ids removeAllObjects];
    [_content removeAllObjects];
    [_subtrees removeAllObjects];
    if (![_search.text isEqualToString:@""]) {
        [self load_data:_search.text];
    }

}



// search kardan va gereftane etelaat

- (void)load_data:(NSString *)str {


    NSString *query = @"select tablee ,name from tbl_f_book_law";

    NSArray *tmp2 = [self.dbManager2 loadDataFromDB:query];
    if ([tmp2 count] == 0)
        return;

    NSString *tbl = [[tmp2 objectAtIndex:0] objectAtIndex:0];
    _name = [[tmp2 objectAtIndex:0] objectAtIndex:1];
    int tbl_type = _type;


    NSString *q = @"";

    if (tbl_type == 1)
        q = [NSString stringWithFormat:@"number like '%%%@%%' OR date like '%%%@%%' OR sharh like '%%%@%%'  ", str, str, str];
    if (tbl_type == 2)
        q = [NSString stringWithFormat:@"number like '%%%@%%' OR date like '%%%@%%' OR ray like '%%%@%%'   OR onvan like '%%%@%%' ", str, str, str, str];
    if (tbl_type == 3)
        q = [NSString stringWithFormat:@" madeh like '%%%@%%'  OR sharh like '%%%@%%'  ", str, str];
    if (tbl_type == 4)
        q = [NSString stringWithFormat:@"number like '%%%@%%' OR onvan like '%%%@%%' OR sharh like '%%%@%%'  ", str, str, str];
    if (tbl_type == 5)
        q = [NSString stringWithFormat:@"mozoo like '%%%@%%' OR mean like '%%%@%%' ", str, str];


    if (tbl_type == 1)
        query = [NSString stringWithFormat:@"select * from %@ where %@ ORDER BY date desc ", tbl, q];
    if (tbl_type == 2)
        query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan, sub_tree from %@ where %@ ORDER BY date desc ", tbl, q];
    if (tbl_type == 3)
        query = [NSString stringWithFormat:@"select _id,madeh,state, sub_tree from %@ where %@ ORDER BY number asc ", tbl, q];
    if (tbl_type == 4)
        query = [NSString stringWithFormat:@"select _id , number , onvan , sharh, sub_tree  from %@ where %@ ORDER BY _id desc ", tbl, q];
    if (tbl_type == 5)
        query = [NSString stringWithFormat:@"select _id , mozoo , mean, sub_tree from %@ where %@ ORDER BY _id desc ", tbl, q];


    NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
    if ([results2 count] == 0) {
        [tableView reloadData];
        return;
    }


    if (tbl_type == 1) {

        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
        for (int i = 0; i < [results2 count]; i++) {


            [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
            NSString *number = [[results2 objectAtIndex:i] objectAtIndex:3];
            NSString *date = [[results2 objectAtIndex:i] objectAtIndex:4];
            NSString *sharh = [[results2 objectAtIndex:i] objectAtIndex:6];
            [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:2]];

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


    if (tbl_type == 2) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
        for (int i = 0; i < [results2 count]; i++) {


            [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
            NSString *number = [[results2 objectAtIndex:i] objectAtIndex:1];
            NSString *date = [[results2 objectAtIndex:i] objectAtIndex:2];
            NSString *ray = [[results2 objectAtIndex:i] objectAtIndex:3];
            NSString *onvan = [[results2 objectAtIndex:i] objectAtIndex:4];
            [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:5]];


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


    if (tbl_type == 3) {

        for (int i = 0; i < [results2 count]; i++) {


            [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
            [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:3]];

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


    if (tbl_type == 4) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *type4_str = [dict objectForKey:@"type4"];
        for (int i = 0; i < [results2 count]; i++) {

            [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
            [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:4]];
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


    if (tbl_type == 5) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *type5_str = [dict objectForKey:@"type5"];
        for (int i = 0; i < [results2 count]; i++) {

            [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
            [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:3]];

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


    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });


}
//**************
//**************
//**************
//**************



//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ids count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CellSearch";

    CellImg *cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];


    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellSearch" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    cell.bg.layer.cornerRadius = 10;
    cell.bg.clipsToBounds = YES;


    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    return 140;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.txt_header.text = _name;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

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
    page.db_name = [NSString stringWithFormat:@"%d", _book];
    page.subtree = [[_subtrees objectAtIndex:indexPath.row] integerValue];

    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:[NSString stringWithFormat:@"%d", _book]];
    NSArray *t = [self.dbManager2 loadDataFromDB:@"select * from tbl_f_book_law"];
    if ([t count] == 0)
        return;

    page.table = [[t objectAtIndex:0] objectAtIndex:2];;
    page.table_link = [[t objectAtIndex:0] objectAtIndex:3];
    page.book_id = _book;


    NSArray *t2 = [self.dbManager loadDataFromDB:[NSString stringWithFormat:@"select type from tbl_f_book_law where _id = %d", _book]];
    if ([t count] == 0)
        return;

    page.type = [[[t2 objectAtIndex:0] objectAtIndex:0] intValue];
    [self.navigationController pushViewController:page animated:YES];

}



//**-*-*-*-*--------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
    [self.search addTarget:self
                    action:@selector(updateSearchString:)
          forControlEvents:UIControlEventEditingChanged];

    self.search.delegate = self;
    self.search.returnKeyType = UIReturnKeyDone;

    tableView.hidden = NO;
    [tableView reloadData];
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
@end

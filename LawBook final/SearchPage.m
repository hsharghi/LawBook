//
//  SearchPage.m
//  LawBook final
//
//  Created by saeid on 11/22/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import "SearchPage.h"
#import "LibraryPage3.h"

#import "BookListPage.h"
#import "DBManager.h"
#import "CellImg.h"
#import "MBProgressHUD.h"

@interface SearchPage ()
@property(nonatomic, strong) DBManager *dbManager;
// datase koli k etelaate hameie ketab ha az qabil download shode ya nashode version,noe ketab,alaqe mandiha,update,...
@property(nonatomic, strong) DBManager *dbManager2;
// database har ketab k matn va mohtavaie ketab dakhele an mibashad
@property Boolean is_running;

@property Boolean operation;;
@property NSInteger first;
@property NSInteger row_num;
@end

@implementation SearchPage


MBProgressHUD *hud;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    _books = [[NSMutableArray alloc] init]; /// for book list page *** selected ids
    _books_name = [[NSMutableArray alloc] init];/// for book list page *** selected ids
    _books_type = [[NSMutableArray alloc] init];/// for book list page *** selected ids




    _ids = [[NSMutableArray alloc] init]; // for table ...
    _ids_book = [[NSMutableArray alloc] init];// for table ...
    _content = [[NSMutableArray alloc] init];// for table ...
    _names = [[NSMutableArray alloc] init];// for table ...
    _subtrees = [NSMutableArray new];
    _idx = 0;

    //set kardane background va gerd kardane bg
//    [tableView setBackgroundView:nil];
//    [tableView setBackgroundColor:[UIColor clearColor]];
    _select_book.layer.cornerRadius = 5;
    _select_book.clipsToBounds = YES;
    [[_select_book layer] setBorderWidth:1.3f];
    [[_select_book layer] setBorderColor:[UIColor whiteColor].CGColor];
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    [self.search addTarget:self
                    action:@selector(updateSearchString:)
          forControlEvents:UIControlEventEditingChanged];

    self.search.delegate = self;
    self.search.returnKeyType = UIReturnKeyDone;


    self.is_running = false;// dar hale search
    self.operation = false;// jostejoie badi ee vojod darad




}


- (IBAction)home:(UIButton *)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (IBAction)help:(UIButton *)sender {

    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];
    [self.view addSubview:theWebView];


}


- (IBAction)helplandscape:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-------------------------------------------------------




// raftan b safeie entekhabe ketab ha
- (IBAction)BookSelect:(UIButton *)sender {


    BookListPage *page = [[BookListPage alloc] initWithNibName:@"BookListPage" bundle:nil];
    page.delegate = self;
    page.selected_ids = _books;
    [self.navigationController pushViewController:page animated:YES];

}


//----------------------------- Getting Table Name ---------------------------
- (IBAction)mode_change {

    [self do_search:_mode.selectedSegmentIndex];

}

// anjame joste jo
- (void)do_search:(NSInteger)mode {
    if (self.is_running == true) {
        self.operation = true;
        return;
    }
    [_ids removeAllObjects];
    [_ids_book removeAllObjects];
    [_content removeAllObjects];
    [_names removeAllObjects];
    [_subtrees removeAllObjects];
    _idx = 0;
    if (![_search.text isEqualToString:@""]) {


        self.is_running = true;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            if (mode == 1) {
                //jostejoie mamoli
                [self load_data];

            }
            else {
                //jostejoie mamoli + jostejoie kalame b kalame = jostejoie pishrafte
                [self load_data];//jostejoie mamoli
                [self load_data2];//jostejoie kalame b kalame
            }


            dispatch_async(dispatch_get_main_queue(), ^{


                self.is_running = false;
                if (self.operation == true) {
                    // chon search b sorate live mibashad mibinad k agar taqiri dar ebarat ejad shode bod dobare search mikonad
                    _operation = false;
                    [self do_search:_mode.selectedSegmentIndex];
                }
            });
        });


    }
    [tableView reloadData];
}

// hengame bazgasht az safeie entekhabe kotob in  tabe seda zade mishavad ba maqadiri k dariaft mikonad
- (void)sendDataToA:(NSMutableArray *)array names:(NSMutableArray *)names types:(NSMutableArray *)types {
    //
    _books = array;
    _books_name = names;
    _books_type = types;
    [self do_search:_mode.selectedSegmentIndex];

}


- (void)updateSearchString:(NSString *)SearchString {

    //jostejo bar asase mode
    [self do_search:_mode.selectedSegmentIndex];


}



// gereftane etelaate az data base (jostejoie mamoli) b sorate 12 taee k baes kondie system nashavad va har bar k b enteha beravim 12 taie badi load mishavad

- (void)load_data {

    NSString *str = _search.text;
    for (int i = 0; i < [_books count]; i++) {
        NSMutableArray *laws = [[NSMutableArray alloc] init];

        NSString *temp_name = [NSString stringWithFormat:@"%@", [_books objectAtIndex:i]];
        self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];
        NSString *query = @"select tablee from tbl_f_book_law";

        NSArray *tmp2 = [self.dbManager2 loadDataFromDB:query];
        if ([tmp2 count] == 0)
            continue;

        NSString *tbl = [[tmp2 objectAtIndex:0] objectAtIndex:0];
        int tbl_type = [[_books_type objectAtIndex:i] intValue];

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
            query = [NSString stringWithFormat:@"select * from %@ where %@ ORDER BY date desc  LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];
        if (tbl_type == 2)
            query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan, sub_tree from %@ where %@ ORDER BY date desc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];
        if (tbl_type == 3)
            query = [NSString stringWithFormat:@"select _id,madeh,state, sub_tree from %@ where %@ ORDER BY number asc   LIMIT 12 OFFSET %d",tbl, q, (_idx * 12)];
        if (tbl_type == 4)
            query = [NSString stringWithFormat:@"select _id , number , onvan , sharh, sub_tree  from %@ where %@ ORDER BY _id desc  LIMIT 12 OFFSET %d ", tbl, q, (_idx * 12)];
        if (tbl_type == 5)
            query = [NSString stringWithFormat:@"select _id , mozoo , mean, sub_tree from %@ where %@ ORDER BY _id desc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];


        NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
        if ([results2 count] == 0)
            continue;


        int temp_i = i;
        if (tbl_type == 1) {

            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
            for (int i = 0; i < [results2 count]; i++) {

                [_ids_book addObject:[_books objectAtIndex:temp_i]];
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:2]];
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


        if (tbl_type == 2) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
            for (int i = 0; i < [results2 count]; i++) {
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
                [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:5]];
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


        if (tbl_type == 3) {

            for (int i = 0; i < [results2 count]; i++) {
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
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
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
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
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
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

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });


}
//**************
//**************
//**************
//**************
// gereftane etelaate az data base (jostejoie pishrafte b sorate kalame kalame) b sorate 12 taee k baes kondie system nashavad va har bar k b enteha beravim 12 taie badi load mishavad

- (void)load_data2 {

    NSString *str = _search.text;
    NSArray *str2 = [str componentsSeparatedByString:@" "];







    //------------------------
    for (int i = 0; i < [_books count]; i++) {
        NSMutableArray *laws = [[NSMutableArray alloc] init];

        NSString *temp_name = [NSString stringWithFormat:@"%@", [_books objectAtIndex:i]];
        self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:temp_name];
        NSString *query = @"select tablee from tbl_f_book_law";

        NSArray *tmp2 = [self.dbManager2 loadDataFromDB:query];
        if ([tmp2 count] == 0)
            continue;

        NSString *tbl = [[tmp2 objectAtIndex:0] objectAtIndex:0];
        int tbl_type = [[_books_type objectAtIndex:i] intValue];


        NSString *q = @"";
        for (int j = 0; j < [str2 count]; j++) {
            if (tbl_type == 1)
                q = [NSString stringWithFormat:@"%@ number like '%%%@%%' OR date like '%%%@%%' OR sharh like '%%%@%%'  ", q, [str2 objectAtIndex:j], [str2 objectAtIndex:j], [str2 objectAtIndex:j]];
            if (tbl_type == 2)
                q = [NSString stringWithFormat:@"%@ number like '%%%@%%' OR date like '%%%@%%' OR ray like '%%%@%%'   OR onvan like '%%%@%%' ", q, [str2 objectAtIndex:j], [str2 objectAtIndex:j], [str2 objectAtIndex:j], [str2 objectAtIndex:j]];
            if (tbl_type == 3)
                q = [NSString stringWithFormat:@"%@  madeh like '%%%@%%'  OR sharh like '%%%@%%'  ", q, [str2 objectAtIndex:j], [str2 objectAtIndex:j]];
            if (tbl_type == 4)
                q = [NSString stringWithFormat:@"%@ number like '%%%@%%' OR onvan like '%%%@%%' OR sharh like '%%%@%%'  ", q, [str2 objectAtIndex:j], [str2 objectAtIndex:j], [str2 objectAtIndex:j]];
            if (tbl_type == 5)
                q = [NSString stringWithFormat:@"%@ mozoo like '%%%@%%' OR mean like '%%%@%%' ", q, [str2 objectAtIndex:j], [str2 objectAtIndex:j]];
            if (j != [str2 count] - 1)
                q = [NSString stringWithFormat:@" %@ OR  ", q];

        }

        if (tbl_type == 1)
            query = [NSString stringWithFormat:@"select * from %@ where %@ ORDER BY date desc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];
        if (tbl_type == 2)
            query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan, sub_tree from %@ where %@ ORDER BY date desc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];
        if (tbl_type == 3)
            query = [NSString stringWithFormat:@"select _id,madeh,state, sub_tree from %@ where %@ ORDER BY number asc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];
        if (tbl_type == 4)
            query = [NSString stringWithFormat:@"select _id , number , onvan , sharh, sub_tree  from %@ where %@ ORDER BY _id desc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];
        if (tbl_type == 5)
            query = [NSString stringWithFormat:@"select _id , mozoo , mean, sub_tree from %@ where %@ ORDER BY _id desc   LIMIT 12 OFFSET %d", tbl, q, (_idx * 12)];


        NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
        if ([results2 count] == 0)
            continue;


        int temp_i = i;
        if (tbl_type == 1) {

            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
            for (int i = 0; i < [results2 count]; i++) {
                Boolean exist = false;
                for (int j = 0; j < [_ids count]; j++) {
                    if ([[_ids_book objectAtIndex:j] intValue] == [[_books objectAtIndex:temp_i] intValue]) if ([[_ids objectAtIndex:j] intValue] == [[[results2 objectAtIndex:i] objectAtIndex:0] intValue]) {
                        exist = true;
                        break;

                    }
                }
                if (exist == true)
                    continue;


                [_ids_book addObject:[_books objectAtIndex:temp_i]];
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:2]];

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


        if (tbl_type == 2) {
            NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
            NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
            NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
            for (int i = 0; i < [results2 count]; i++) {
                Boolean exist = false;
                for (int j = 0; j < [_ids count]; j++) {
                    if ([[_ids_book objectAtIndex:j] intValue] == [[_books objectAtIndex:temp_i] intValue]) if ([[_ids objectAtIndex:j] intValue] == [[[results2 objectAtIndex:i] objectAtIndex:0] intValue]) {
                        exist = true;
                        break;

                    }
                }
                if (exist == true)
                    continue;
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
                [_ids addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
                [_subtrees addObject:[[results2 objectAtIndex:i] objectAtIndex:5]];

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
        if (tbl_type == 3) {

            for (int i = 0; i < [results2 count]; i++) {
                Boolean exist = false;
                for (int j = 0; j < [_ids count]; j++) {
                    if ([[_ids_book objectAtIndex:j] intValue] == [[_books objectAtIndex:temp_i] intValue]) if ([[_ids objectAtIndex:j] intValue] == [[[results2 objectAtIndex:i] objectAtIndex:0] intValue]) {
                        exist = true;
                        break;
                    }
                }
                if (exist == true)
                    continue;
                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
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

                Boolean exist = false;
                for (int j = 0; j < [_ids count]; j++) {
                    if ([[_ids_book objectAtIndex:j] intValue] == [[_books objectAtIndex:temp_i] intValue]) if ([[_ids objectAtIndex:j] intValue] == [[[results2 objectAtIndex:i] objectAtIndex:0] intValue]) {
                        exist = true;
                        break;
                    }
                }
                if (exist == true)
                    continue;

                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
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


                Boolean exist = false;
                for (int j = 0; j < [_ids count]; j++) {
                    if ([[_ids_book objectAtIndex:j] intValue] == [[_books objectAtIndex:temp_i] intValue]) if ([[_ids objectAtIndex:j] intValue] == [[[results2 objectAtIndex:i] objectAtIndex:0] intValue]) {
                        exist = true;
                        break;
                    }
                }
                if (exist == true)
                    continue;

                [_names addObject:[_books_name objectAtIndex:temp_i]];
                [_ids_book addObject:[_books objectAtIndex:temp_i]];
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
    }
    dispatch_async(dispatch_get_main_queue(), ^{
//        [tableView setBackgroundView:nil];
//        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView reloadData];
//        [tableView setBackgroundView:nil];
//        [tableView setBackgroundColor:[UIColor clearColor]];
    });


}
//tavabe table view
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
    if (indexPath.row == [_ids count] - 1) {
        _idx++;
        if (_mode.selectedSegmentIndex == 1) {
            [self load_data];

        }
        else {
            [self load_data];
            [self load_data2];
        }
    }

    cell.txt.font = [UIFont fontWithName:@"BYekan" size:18.0];
    cell.txt_header.font = [UIFont fontWithName:@"BYekan" size:18.0];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {

    return 120 + 40;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.txt_header.text = [_names objectAtIndex:indexPath.row];

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

    cell.backgroundColor = [UIColor clearColor];
    //cell.txt.attributedText =[_content objectAtIndex:indexPath.row] ;
    //

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {


    LibraryPage3 *page;

    if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
        page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Portrait" bundle:nil];
    }
    else {
        page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Landscape" bundle:nil];
    }


    page.law_id = [[_ids objectAtIndex:indexPath.row] intValue];
    page.db_name = [NSString stringWithFormat:@"%d", [[_ids_book objectAtIndex:indexPath.row] intValue]];
//    page.index = indexPath.row;
    page.subtree = [[_subtrees objectAtIndex:indexPath.row] integerValue];

    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:[NSString stringWithFormat:@"%d", [[_ids_book objectAtIndex:indexPath.row] intValue]]];
    NSArray *t = [self.dbManager2 loadDataFromDB:@"select * from tbl_f_book_law"];
    if ([t count] == 0)
        return;

    page.table = [[t objectAtIndex:0] objectAtIndex:2];;
    page.table_link = [[t objectAtIndex:0] objectAtIndex:3];
    page.book_id = [[_ids_book objectAtIndex:indexPath.row] intValue];


    NSArray *t2 = [self.dbManager loadDataFromDB:[NSString stringWithFormat:@"select type from tbl_f_book_law where _id = %d", [[_ids_book objectAtIndex:indexPath.row] intValue]]];
    if ([t2 count] == 0)
        return;

    page.type = [[[t2 objectAtIndex:0] objectAtIndex:0] intValue];
    
    [self.navigationController pushViewController:page animated:YES];
}



//**-*-*-*-*--------------------------------------------

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}






//++++++++++++++++++++++++++++++++++++++ new



- (IBAction)help_ipad:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];

    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}


- (IBAction)helplandscape_ipad:(UIButton *)sender {


    UIWebView *theWebView = [[UIWebView alloc] initWithFrame:CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.frame.size.height)];
    theWebView.scalesPageToFit = YES;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"help" ofType:@"pdf"];
    NSURL *targetURL = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [theWebView loadRequest:request];

    [self.view addSubview:theWebView];


}


- (void)show_loading {
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.labelText = @"test";
}


- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


- (void)changeOrientation1 {


}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateLayoutForNewOrientation:self.interfaceOrientation];
    
//    NSMutableArray *indexpaths = [[tableView indexPathsForVisibleRows] mutableCopy];
//    if (indexpaths) {
//    NSIndexPath *lastIndexPath = indexpaths[indexpaths.count-1];
//    NSIndexPath *extraIndexPath = [NSIndexPath indexPathForRow:lastIndexPath.row+1 inSection:lastIndexPath.section];
//    [indexpaths addObject:extraIndexPath];
//    [tableView reloadRowsAtIndexPaths:[tableView indexPathsForVisibleRows] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}


// update kardane view dar zamane charkhesh
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self updateLayoutForNewOrientation:toInterfaceOrientation];
}


// name xib ee k baiad load shavad ra barmigardanad
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
    NSString *t = _search.text;
    int temp = _mode.selectedSegmentIndex;

    [[NSBundle mainBundle] loadNibNamed:[self nibNameForInterfaceOrientation:orientation] owner:self options:nil];
    if ([visible count] != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }
    _mode.selectedSegmentIndex = temp;
    _search.text = t;


    [self.search addTarget:self
                    action:@selector(updateSearchString:)
          forControlEvents:UIControlEventEditingChanged];

    self.search.delegate = self;
    self.search.returnKeyType = UIReturnKeyDone;


    _select_book.layer.cornerRadius = 5;
    _select_book.clipsToBounds = YES;
    [[_select_book layer] setBorderWidth:1.3f];
    [[_select_book layer] setBorderColor:[UIColor whiteColor].CGColor];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (_row_num) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:NO];
    }
    
//    [tableView reloadData];

}

@end

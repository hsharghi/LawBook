//
//  LibraryPage2.m
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "LibraryPage2.h"
#import "LibraryPage3.h"
#import "SearchBook.h"


#import "DBManager.h"
#import "CellImg.h"


NSString *table;
NSString *table_link;
NSMutableDictionary *_frames2;


@interface LibraryPage2 ()
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;
@property NSInteger row_num;


@end

@implementation LibraryPage2


@synthesize book_id;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    
//    if (!_frames2)
        _frames2 = [NSMutableDictionary new];

    
    // tanzimate avalie
    NSString *newString = [_hdr string];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    _hdr = [[NSMutableAttributedString alloc] initWithString:[newString stringByAppendingFormat:@" - %d", _hidden]];
    _header.attributedText = _hdr;


    _header.adjustsFontSizeToFitWidth = YES;


    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    NSLog(@"%@", self.dbManager.documentsDirectory);
    NSString *name = [NSString stringWithFormat:@"%d", self.book_id];
    self.dbManager2 = [[DBManager alloc] initWithDatabaseFilename:name];

    _ids2l = [[NSMutableArray alloc] init];
    _content2l = [[NSMutableArray alloc] init];
    _mode = [[NSMutableArray alloc] init];

    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    NSArray *temp = [self.dbManager2 loadDataFromDB:@"select * from tbl_f_book_law"];
    if ([temp count] == 0)
        return;
    table = [[temp objectAtIndex:0] objectAtIndex:2];
    table_link = [[temp objectAtIndex:0] objectAtIndex:3];



    // agar parent 1 bashad faqat anavine ketab ra miavarad
    // dar qeire in sorat ham anavin va ham made ha load mishavad
    if (self.parent == -1)
        [self load_lowestParent];
    else {
        [self load_sub_tree:self.parent];
        [self load_data];

    }


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






// load kardane faslha ee k zir majmoee darand

- (void)load_lowestParent {

    NSString *query = @"select _id , parentt from tbl_f_tree_law ORDER BY parentt asc";
    NSArray *results = [self.dbManager2 loadDataFromDB:query];
    if ([results count] == 0)
        return;
    int pr = [[[results objectAtIndex:0] objectAtIndex:1] intValue];
    query = [NSString stringWithFormat:@"select * from tbl_f_tree_law where parentt = %d", pr];
    NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
    if ([results2 count] == 0)
        return;

    for (int i = 0; i < [results2 count]; i++) {
        [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[[results2 objectAtIndex:i] objectAtIndex:1]];
        [_content2l addObject:attString];
        [_mode addObject:@"0"];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });

    int temp = self.parent;

}

// load kardane  onvanha ba yek parrent

- (void)load_data {


    NSMutableString *query = [[NSString stringWithFormat:@"select * from tbl_f_tree_law where parentt = %d", self.parent] mutableCopy];
    NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
    if ([results2 count] == 0)
        return;

    for (int i = 0; i < [results2 count]; i++) {
        [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:[[results2 objectAtIndex:i] objectAtIndex:1]];
        [_content2l addObject:attString];
        [_mode addObject:@"0"];

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });


}


// load kardane subtree
- (void)load_sub_tree:(int)pr {

    NSString *query = @"";
    if (self.type == 1)
        query = [NSString stringWithFormat:@"select * from %@ where sub_tree = %d ORDER BY date desc", table, pr];
    if (self.type == 2)
        query = [NSString stringWithFormat:@"select _id , number , date, ray , onvan from %@ where sub_tree = %d ORDER BY date desc", table, pr];
    if (self.type == 3)
        query = [NSString stringWithFormat:@"select _id, madeh,state from %@ where sub_tree = %d ORDER BY number asc", table, pr];
    if (self.type == 4)
        query = [NSString stringWithFormat:@"select _id , number , onvan , sharh  from %@ where sub_tree = %d ORDER BY _id desc", table, pr];
    if (self.type == 5)
        query = [NSString stringWithFormat:@"select _id , mozoo , mean from %@ where sub_tree = %d ORDER BY _id desc", table, pr];


    NSArray *results2 = [self.dbManager2 loadDataFromDB:query];
    if ([results2 count] == 0)
        return;


    if (self.type == 1) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *nazarie_shomare = [dict objectForKey:@"nazarie_shomare"];
        for (int i = 0; i < [results2 count]; i++) {

            [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
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
            [_content2l addObject:attString];
            [_mode addObject:@"1"];

        }
    }


    if (self.type == 2) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *ray_shomare = [dict objectForKey:@"ray_shomare"];
        for (int i = 0; i < [results2 count]; i++) {

            [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
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

            [_content2l addObject:attString];
            [_mode addObject:@"1"];

        }
    }


    if (self.type == 3) {

        for (int i = 0; i < [results2 count]; i++) {

            [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
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

            [_content2l addObject:attString];
            [_mode addObject:@"1"];

        }
    }


    if (self.type == 4) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *type4_str = [dict objectForKey:@"type4"];
        for (int i = 0; i < [results2 count]; i++) {

            [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];
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
            [_content2l addObject:attString];
            [_mode addObject:@"1"];

        }
    }


    if (self.type == 5) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Strings" ofType:@"plist"];
        NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
        NSString *type5_str = [dict objectForKey:@"type5"];
        for (int i = 0; i < [results2 count]; i++) {

            [_ids2l addObject:[[results2 objectAtIndex:i] objectAtIndex:0]];

            NSString *mozoo = [[results2 objectAtIndex:i] objectAtIndex:1];
            NSString *mean = [[results2 objectAtIndex:i] objectAtIndex:2];


            NSString *tmp = [NSString stringWithFormat:@"%@ %@ \n %@", type5_str, mozoo, mean];
            NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:tmp];
            NSRange range1 = [tmp rangeOfString:type5_str];
            NSRange range2 = [tmp rangeOfString:mozoo];

            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range1];
            [attString addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:range2];
            [_content2l addObject:attString];
            [_mode addObject:@"1"];

        }
    }


    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView reloadData];
    });


}



















//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ids2l count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CellLibrary";
    CellImg *cell;
    if ([[_mode objectAtIndex:indexPath.row] intValue] == 0)
        cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    else
        cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:@"CellLibrary2"];

    if (cell == nil) {
        NSArray *nib;
        if ([[_mode objectAtIndex:indexPath.row] intValue] == 0)
            nib = [[NSBundle mainBundle] loadNibNamed:@"CellLibrary" owner:self options:nil];
        else
            nib = [[NSBundle mainBundle] loadNibNamed:@"CellLibrary2" owner:self options:nil];

        cell = [nib objectAtIndex:0];
    }


    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    cell.bg.layer.cornerRadius = 10;
    cell.bg.clipsToBounds = YES;


    cell.txt.font = [UIFont fontWithName:@"BYekan" size:16.0];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    int h = 50;
    if ([[_mode objectAtIndex:indexPath.row] intValue] == 0)
        return h + 13;
    else {
        return h * 2 + 40;

    }

}

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


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSMutableAttributedString *attrString = [_content2l objectAtIndex:indexPath.row];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontspace"] intValue] - 7];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, [attrString length])];
    cell.txt.attributedText = attrString;
    cell.txt.textAlignment = NSTextAlignmentRight;
    cell.txt.font = [UIFont fontWithName:@"BYekan" size:[[[NSUserDefaults standardUserDefaults] stringForKey:@"fontsize"] intValue]];


    if ([[_mode objectAtIndex:indexPath.row] intValue] == 0)
        cell.img.hidden = NO;
    else
        cell.img.hidden = YES;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];

    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if ([[_mode objectAtIndex:indexPath.row] intValue] == 0) {
        LibraryPage2 *page;

        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            page = [[LibraryPage2 alloc] initWithNibName:@"LibraryPage2_Portrait" bundle:nil];
        }
        else {
            page = [[LibraryPage2 alloc] initWithNibName:@"LibraryPage2_Landscape" bundle:nil];
        }


        page.hidden = self.hidden;
        page.book_id = self.book_id;
        page.parent = [[_ids2l objectAtIndex:indexPath.row] intValue];
        page.type = self.type;
        page.hdr = [_content2l objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:page animated:YES];
    }
    else {
        LibraryPage3 *page;

        if ([[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortrait) {
            page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Portrait" bundle:nil];
        }
        else {
            page = [[LibraryPage3 alloc] initWithNibName:@"LibraryPage3_Landscape" bundle:nil];

        }

        page.hidden = self.hidden;
        page.law_id = [[_ids2l objectAtIndex:indexPath.row] intValue];
        page.db_name = [NSString stringWithFormat:@"%d", self.book_id];
        page.table = table;
        page.table_link = table_link;
        page.book_id = self.book_id;
        page.type = self.type;
        page.index = indexPath.row;
        page.subtree = self.parent;
        [self.navigationController pushViewController:page animated:YES];
    }


}


// raftan b safeie search
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
    page.book = book_id;
    [self.navigationController pushViewController:page animated:YES];
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
            frame.size.width = self.view.bounds.size.width-(isiPad ? 387 : 197) - 21;
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // resize tableView
            view = [self.view viewWithTag:202];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width-(isiPad ? 387 : 197) - 21;
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            
            // move کتابخانه label back to place
            view = [self.view viewWithTag:203];
            frame = view.frame;
            frame.size.width = (isiPad ? 550 : 212);
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // move pane to the right most point of self.view
            view = [self.view viewWithTag:204];
            frame = view.frame;
            frame.origin.x = self.view.bounds.size.width - (isiPad ? 387 : 197);
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
        } completion:^(BOOL finished) {
        }];
        
        
        for (int i=101;i<=104;i++)
        {
            switch (i) {
                case 101:
                case 103:
                    x = self.view.bounds.size.width - (isiPad ? 294 : 150) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                case 102:
                    x = self.view.bounds.size.width - (isiPad ? 292 : 148) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                case 104:
                    x = self.view.bounds.size.width - (isiPad ? 320 : 166) - (isiPad ? 70.0/2 : 35.0/2);
                    break;
                    
                default:
                    break;
            }
            
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CGPoint center = button.center;
            center.x = x;
            [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.center = center;
                [_frames2 setObject:[NSValue valueWithCGRect:button.frame] forKey:[NSNumber numberWithInteger:button.tag]];
                
            } completion:^(BOOL finished) {
                if (button.tag == 104) {
                    [button setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
                }
            }];
            delay += 0.05;
        }
        
    } else {        // hide the pange
        CGFloat delay = 0;
        
        for (int i=101;i<=104;i++)
        {
            UIButton *button = (UIButton *)[self.view viewWithTag:i];
            CGPoint center = button.center;
            center.x = self.view.bounds.size.width - (isiPad ? 40 : 20);
            [UIView animateWithDuration:0.7 delay:delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                button.center = center;
                [_frames2 setObject:[NSValue valueWithCGRect:button.frame] forKey:[NSNumber numberWithInteger:button.tag]];
            } completion:^(BOOL finished) {
                
            }];
            delay += 0.05;
        }
        
        [UIView animateWithDuration:0.7 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            // resize title imageView
            UIView *view = [self.view viewWithTag:201];
            CGRect frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 80 : 40);
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // resize tableView
            view = [self.view viewWithTag:202];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 80 : 40);
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // move کتابخانه label to right
            view = [self.view viewWithTag:203];
            frame = view.frame;
            frame.size.width = self.view.bounds.size.width - frame.origin.x - (isiPad ? 80 : 50); //40
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            // move pane to the right most point of self.view
            view = [self.view viewWithTag:204];
            frame = view.frame;
            frame.origin.x = self.view.bounds.size.width-(isiPad ? 30 : 15);
            view.frame = frame;
            [_frames2 setObject:[NSValue valueWithCGRect:frame] forKey:[NSNumber numberWithInteger:view.tag]];
            
            
        } completion:^(BOOL finished) {
            [((UIButton *)[self.view viewWithTag:104]) setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
        }];
    }
    self.hidden = !self.hidden;
    
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


// update kardane view hengami k mikhahad namaiesh dade shavad
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    if ([visible count] != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:YES];
    }


    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _header.attributedText = _hdr;
    _header.adjustsFontSizeToFitWidth = YES;
    _actionbar.layer.cornerRadius = [[[NSUserDefaults standardUserDefaults] stringForKey:@"actionbar"] intValue];
    _actionbar.clipsToBounds = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableView setBackgroundView:nil];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView reloadData];
        tableView.hidden = NO;

    });
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    // if pane was hidden, setup hidden view
//    if (self.hidden)
//        [self configureHiddenView];
//    

    if (_row_num != 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_row_num inSection:0];
        [tableView scrollToRowAtIndexPath:indexPath
                         atScrollPosition:UITableViewScrollPositionTop
                                 animated:NO];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_frames2.count) {
            for (NSNumber *key in _frames2)
            {
                CGRect frame = [[_frames2 objectForKey:key] CGRectValue];
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
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************
//*************-------------***********______________***************_____________*************







































@end

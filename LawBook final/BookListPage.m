//
//  BookListPage.m
//  LawBook final
//
//  Created by saeid1 on 12/4/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import "BookListPage.h"
#import "DBManager.h"
#import "CellImg.h"


@interface BookListPage ()
@property(nonatomic, strong) DBManager *dbManager;
@property(nonatomic, strong) DBManager *dbManager2;


@end

@implementation BookListPage
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [tableView setBackgroundView:nil];
    [tableView setBackgroundColor:[UIColor clearColor]];
    // amade sazie database
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];

    _types = [[NSMutableArray alloc] init];
    _ids = [[NSMutableArray alloc] init];
    _names = [[NSMutableArray alloc] init];
    _is_selected = [[NSMutableArray alloc] init];



    // araie baraie zakhire sazi va ferestadan b safeie search k che ketab haeee baiad joste jo shavand
    _selected_types = [[NSMutableArray alloc] init];
    _selected_names = [[NSMutableArray alloc] init];


    _temp_label = [[NSMutableArray alloc] init];


    //gereftane etelaate ketab ha az database
    NSArray *books = [self.dbManager loadDataFromDB:@" select _id , name , type from tbl_f_book_law "];

    if ([books count] > 0) {
        for (int i = 0; i < [books count]; i++) {
            [_ids addObject:[[books objectAtIndex:i] objectAtIndex:0]];
            [_names addObject:[[books objectAtIndex:i] objectAtIndex:1]];
            [_types addObject:[[books objectAtIndex:i] objectAtIndex:2]];
            [_is_selected addObject:@"0"];


        }
    }
    for (int i = 0; i < [_ids count]; i++) {
        for (int j = 0; j < [_selected_ids count]; j++) {
            if ([[_ids objectAtIndex:i] intValue] == [[_selected_ids objectAtIndex:j] intValue]) {
                [_is_selected replaceObjectAtIndex:i withObject:@"1"];
                break;
            }
        }
    }
    [tableView reloadData];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}





// tavabe table view
//------------------------------------- TABLEVIEW FUNCTION ----------------------------

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_ids count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CellBookList";

    CellImg *cell = (CellImg *) [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];


    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CellBookList" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    [cell setBackgroundColor:[UIColor clearColor]];


    cell.sw.tag = indexPath.row;
    [cell.sw addTarget:self action:@selector(switch_click:) forControlEvents:UIControlEventTouchUpInside];


    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {

    return 70;


}


- (void)tableView:(UITableView *)tableView willDisplayCell:(CellImg *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    // namaieshe list ketab ha va vaziate tik zade shodan ya nazade shodane an ha
    cell.txt.text = [_names objectAtIndex:indexPath.row];
    if ([[_is_selected objectAtIndex:indexPath.row] intValue] == 0)
        [cell.sw setOn:NO animated:NO];

    else
        [cell.sw setOn:YES animated:NO];

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    CellImg *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.sw.isOn == YES) {
        [cell.sw setOn:NO animated:YES];
        [_is_selected replaceObjectAtIndex:indexPath.row withObject:@"0"];
    }
    else {
        [cell.sw setOn:YES animated:YES];
        [_is_selected replaceObjectAtIndex:indexPath.row withObject:@"1"];
    }


}

// tabe click kardan roie yeki az  tick ha
- (void)switch_click:(UISwitch *)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:tableView];
    NSIndexPath *indexPath = [tableView indexPathForRowAtPoint:buttonPosition];


    CellImg *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([[_is_selected objectAtIndex:sender.tag] isEqualToString:@"1"]) {
        [sender setOn:NO animated:YES];
        [_is_selected replaceObjectAtIndex:sender.tag withObject:@"0"];
    }
    else {
        [sender setOn:YES animated:YES];
        [_is_selected replaceObjectAtIndex:sender.tag withObject:@"1"];
    }


}







//-----------------------------------------------------------------

- (void)viewWillDisappear:(BOOL)animated {
    [_selected_ids removeAllObjects];
    for (int i = 0; i < [_ids count]; i++) {
        if ([[_is_selected objectAtIndex:i] intValue] == 1) {

            [_selected_ids addObject:[_ids objectAtIndex:i]];
            [_selected_names addObject:[_names objectAtIndex:i]];
            [_selected_types addObject:[_types objectAtIndex:i]];


        }
    }
    [delegate sendDataToA:_selected_ids names:_selected_names types:_selected_types];

}


- (IBAction)back:(UIButton *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}


@end

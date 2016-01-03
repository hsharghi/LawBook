//
//  SearchPage.h
//  LawBook final
//
//  Created by saeid on 11/22/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPage : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tableView;
    NSOperationQueue *operationQueue;
    NSInvocationOperation *opr;

}
@property(retain) IBOutlet UIImageView *actionbar;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

- (IBAction)help:(UIButton *)sender;

- (IBAction)helplandscape:(UIButton *)sender;

- (IBAction)BookSelect:(UIButton *)sender;

- (IBAction)updateSearchString:(NSString *)SearchString;

- (IBAction)mode_change;


- (IBAction)help_ipad:(UIButton *)sender;

- (IBAction)helplandscape_ipad:(UIButton *)sender;


@property NSMutableArray *books;
@property NSMutableArray *books_name;
@property NSMutableArray *books_type;


@property NSMutableArray *ids;
@property NSMutableArray *subtrees;
@property NSMutableArray *content;
@property NSMutableArray *ids_book;
@property NSMutableArray *names;
@property int idx;


@property IBOutlet UIButton *select_book;


@property IBOutlet UISegmentedControl *mode;
@property IBOutlet UITextField *search;


@end

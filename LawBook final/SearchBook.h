//
//  SearchPage.h
//  LawBook final
//
//  Created by saeid on 11/22/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBook : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *tableView;


}
- (IBAction)back:(UIButton *)sender;

- (IBAction)updateSearchString:(NSString *)SearchString;


@property(retain) IBOutlet UIImageView *actionbar;
@property NSMutableArray *ids;
@property NSMutableArray *subtrees;
@property NSMutableArray *content;
@property NSString *name;


@property int type;
@property int book;


@property IBOutlet UIButton *select_book;


@property IBOutlet UITextField *search;


@end

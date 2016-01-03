//
//  LibraryPage2.h
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface LibraryPage4 : UIViewController <UITableViewDataSource, UITableViewDelegate> {


    IBOutlet UITableView *tableView;


}


- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;


@property NSMutableArray *mode;
@property NSMutableArray *book_ids;
@property NSMutableArray *law_ids;
@property NSMutableArray *content;


@property int book_id;
@property int law_id;
@property NSString *db_name;


@property NSString *table;
@property NSString *table_link;


@property Boolean portrait;


@end

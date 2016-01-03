//
//  LibraryPage2.h
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavPage : UIViewController <UITableViewDataSource, UITableViewDelegate> {


    IBOutlet UITableView *tableView;


}

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;


@property(retain) IBOutlet UIImageView *actionbar;
@property NSMutableArray *ids;
@property NSMutableArray *book_ids;
@property NSMutableArray *content;
@property NSMutableArray *name;
@property NSMutableArray *types;


@end

//
//  BookListPage.h
//  LawBook final
//
//  Created by saeid1 on 12/4/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol senddataProtocol <NSObject>

- (void)sendDataToA:(NSMutableArray *)array names:(NSMutableArray *)names types:(NSMutableArray *)types;
@end

@interface BookListPage : UIViewController <UITableViewDataSource, UITableViewDelegate> {


    IBOutlet UITableView *tableView;


}
@property NSMutableArray *ids;
@property NSMutableArray *types;
@property NSMutableArray *names;

@property NSMutableArray *is_selected;


@property NSMutableArray *selected_ids;
@property NSMutableArray *selected_names;
@property NSMutableArray *selected_types;


@property NSMutableArray *temp_label;

@property(nonatomic, assign) id delegate;

- (IBAction)back:(UIButton *)sender;

@end

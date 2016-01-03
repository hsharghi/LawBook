//
//  LibraryPage2.h
//  LawBook final
//
//  Created by saeid1 on 9/6/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>


#define isiPad (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)

@interface LibraryPage2 : UIViewController <UITableViewDataSource, UITableViewDelegate> {


    IBOutlet UITableView *tableView;
}

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

- (IBAction)search:(UIButton *)sender;

- (IBAction)hidePane:(id)sender;


@property(nonatomic, assign) BOOL hidden;

@property NSMutableArray *ids2l;
@property NSMutableArray *content2l;
@property NSMutableArray *mode;

@property(retain) IBOutlet UIImageView *actionbar;

@property int book_id;
@property int parent;
@property int type;

@property IBOutlet UILabel *header;
@property NSMutableAttributedString *hdr;


@end

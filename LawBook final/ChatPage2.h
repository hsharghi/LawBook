//
//  ChatPage1.h
//  low book
//
//  Created by saeid1 on 8/27/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatPage2 : UIViewController <UITableViewDelegate, UITableViewDataSource> {


    IBOutlet UITableView *tableView;


}
@property(retain) IBOutlet UIImageView *actionbar;
@property IBOutlet UILabel *header;
@property NSString *hdr;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

@property int main_id;
@end

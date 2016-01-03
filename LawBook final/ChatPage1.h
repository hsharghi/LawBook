//
//  ChatPage1.h
//  low book
//
//  Created by saeid1 on 8/27/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChatPage1 : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    IBOutlet UITableView *tableView;
}

- (IBAction)back:(UIButton *)sender;
- (IBAction)home:(UIButton *)sender;
- (IBAction)showProfile:(id)sender;

@property(retain) IBOutlet UIImageView *actionbar;

@end

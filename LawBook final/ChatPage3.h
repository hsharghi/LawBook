//
//  ChatPage3.h
//  LawBook final
//
//  Created by saeid1 on 8/29/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface ChatPage3 : UIViewController <UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, ASIHTTPRequestDelegate> {


    IBOutlet UITableView *tableView;
    IBOutlet UIActivityIndicatorView *activityIndicator;


}


@property (retain         ) IBOutlet UIImageView *actionbar;
@property (weak, nonatomic) IBOutlet UITextField *comment_txt;
@property (weak, nonatomic) IBOutlet UIButton    *comment_send;

- (IBAction)back:(UIButton *)sender;
- (IBAction)home:(UIButton *)sender;
- (IBAction)send:(UIButton *)sender;

@property IBOutlet UILabel *header;
@property NSString *hdr;
@property int main_id;
@end

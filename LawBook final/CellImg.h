//
//  CellImg.h
//  low book
//
//  Created by saeid1 on 8/26/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+dynamicSizeMe.h"

@protocol MyCustomCellDelegate
@optional
- (IBAction)likeTapped:(UITableViewCell *)cell button:(UIButton *)sender;
@end


@interface CellImg : UITableViewCell {
    IBOutlet UILabel *txt;
}


@property(nonatomic, weak) IBOutlet UIImageView *img;
@property(nonatomic, weak) IBOutlet UIImageView *bg;
@property(nonatomic, retain) UILabel *txt;
@property(nonatomic, retain) IBOutlet UITextView *txt2;

@property(nonatomic, weak) IBOutlet UIImageView *img_header;

@property(nonatomic, retain) IBOutlet UILabel *txt_header;
@property(nonatomic, retain) IBOutlet UILabel *date;
@property(nonatomic, retain) IBOutlet UILabel *num;
@property(nonatomic, retain) IBOutlet UITextView *text;

@property(weak, nonatomic) IBOutlet UIImageView *avatar;
@property(nonatomic, retain) IBOutlet UIButton *like;
@property(nonatomic, retain) IBOutlet UIButton *dislike;
@property(nonatomic, retain) IBOutlet UILabel *dislike_num;
@property(nonatomic, retain) IBOutlet UILabel *like_num;

@property(nonatomic, weak) IBOutlet UIView *header;

@property(nonatomic, weak) IBOutlet UISwitch *sw;

@property(nonatomic, retain) IBOutlet UIButton *btn;


@property(nonatomic, weak) id delegate;


@end

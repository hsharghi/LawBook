//
//  CellImg.m
//  low book
//
//  Created by saeid1 on 8/26/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "CellImg.h"

NSString *kCellTextView_ID = @"CellImg";

@implementation CellImg
@synthesize txt;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)likeTapped:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(myCustomCellButtonTapped:button:)])
        [self.delegate likeTapped:self button:sender];
}


@end

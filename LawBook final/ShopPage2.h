//
//  ShopPage1.h
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopPage2 : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate> {


    IBOutlet UICollectionView *collectionView;
    IBOutlet UIActivityIndicatorView *activityIndicator;


}
@property(retain) IBOutlet UIImageView *actionbar;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

@property IBOutlet UILabel *header;
@property NSString *hdr;
@property int main_id2;

@property NSMutableArray *isBuy;


@end

//
//  ShopPage1.h
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopPage3 : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate> {


    IBOutlet UICollectionView *collectionView;


}
@property(retain) IBOutlet UIImageView *actionbar;
@property(strong) IBOutlet UILabel *name;
@property(strong) IBOutlet UILabel *name2;
@property(strong) IBOutlet UIImageView *img;
@property(strong) IBOutlet UIImageView *container;
@property(strong) IBOutlet UIButton *price;
@property(strong) IBOutlet UIButton *download;
@property(strong) IBOutlet UILabel *desc;
@property(strong) IBOutlet UIButton *desc_btn;
@property(strong) IBOutlet UILabel *temp;
@property(strong) IBOutlet UIView *desc_btn_border;
@property(strong) IBOutlet UIScrollView *scroll;
@property int main_id_s3;
@property NSString *cost;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

- (IBAction)open_close_desc:(UIButton *)sender;

@property IBOutlet UILabel *header;
@property NSString *hdr;
@property bool isBuy;


@property bool prt;
@property int land;


@property IBOutlet UIImageView *image_btn;

@property NSString *txt_name;
@property NSString *txt_desc;
@property NSString *txt_price;
@property NSString *link_img;


- (IBAction)BtnClicked:(id)sender;


@end

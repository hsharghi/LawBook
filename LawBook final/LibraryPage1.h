//
//  ShopPage1.h
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"


#define isiPad (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad)


//*******************














///*********************

@interface LibraryPage1 : UIViewController <UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UISearchBarDelegate> {


    IBOutlet UICollectionView *collectionView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    //****************


}
- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;

- (IBAction)fav:(UIButton *)sender;

- (IBAction)refresh:(UIButton *)sender;

- (IBAction)update:(UIButton *)sender;

- (IBAction)hidePane:(id)sender;

- (IBAction)searchTapped:(id)sender;

- (IBAction)read_book:(UIButton *)sender;

@property(weak, nonatomic) IBOutlet UIButton *refreshButton;
@property(weak, nonatomic) IBOutlet UIButton *favButton;
@property(weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak, nonatomic) IBOutlet UIButton *updateButton;
@property(weak, nonatomic) IBOutlet UIButton *updateBadgeButton;
@property(weak, nonatomic) IBOutlet UIButton *homeButton;
@property(weak, nonatomic) IBOutlet UIButton *hidePaneButton;
@property(nonatomic, assign) BOOL hidden;

@property(weak, nonatomic) IBOutlet UISearchBar *searchField;
@property(retain) IBOutlet UIImageView *actionbar;
@property IBOutlet UIImageView *image_btn;

@property(weak, nonatomic) IBOutlet UIImageView *paneImageView;
@property IBOutlet UIButton *red;
@property int from_shop;
//*****************************










@end

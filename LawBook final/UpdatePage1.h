//
//  UpdatePage1.h
//  LawBook
//
//  Created by saeid1 on 12/24/14.
//  Copyright (c) 2014 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface UpdatePage1 : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate> {


    IBOutlet UICollectionView *collectionView;
    IBOutlet UIActivityIndicatorView *activityIndicator;


}
@property(retain) IBOutlet UIImageView *actionbar;

- (IBAction)back:(UIButton *)sender;

- (IBAction)home:(UIButton *)sender;


@end

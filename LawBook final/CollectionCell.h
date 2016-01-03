//
//  CollectionCell.h
//  LawBook final
//
//  Created by saeid1 on 8/30/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DALabeledCircularProgressView.h"


@interface CollectionCell : UICollectionViewCell


@property(nonatomic, strong) IBOutlet UIImageView *dl;
@property(nonatomic, strong) IBOutlet UIImageView *container;
@property(nonatomic, strong) IBOutlet UIImageView *img;
@property(nonatomic, strong) IBOutlet UILabel *name;
@property(nonatomic, strong) IBOutlet UILabel *price;
@property(nonatomic, strong) IBOutlet UIButton *btn;


@property(nonatomic, strong) IBOutlet UIActivityIndicatorView *indicator;


@property(strong, nonatomic) IBOutlet DALabeledCircularProgressView *labeledProgressView;

@property(strong, nonatomic) IBOutlet DALabeledCircularProgressView *tempProgressView;


@end

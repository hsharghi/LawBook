//
//  DACircularProgressView.h
//  DACircularProgress
//
//  Created by Daniel Amitay on 2/6/12.
//  Copyright (c) 2012 Daniel Amitay. All rights reserved.
//

#import <UIKit/UIKit.h>


#ifndef FLT_EPSILON
#define FLT_EPSILON __FLT_EPSILON__
#endif


@interface DACircularProgressView : UIView

@property(nonatomic, strong) UIColor *trackTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger roundedCorners UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(
@property(nonatomic) CGFloat thicknessRatio UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger clockwiseProgress UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(
@property(nonatomic) CGFloat progress;

@property(nonatomic) CGFloat indeterminateDuration UI_APPEARANCE_SELECTOR;
@property(nonatomic) NSInteger indeterminate UI_APPEARANCE_SELECTOR; // Can not use BOOL with UI_APPEARANCE_SELECTOR :-(

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated initialDelay:(CFTimeInterval)initialDelay;

@end
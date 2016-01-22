//
//  ViewController.h
//  LawBook final
//
//  Created by saeid1 on 8/28/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (IBAction)Chat:(UIButton *)sender;

- (IBAction)Shop:(UIButton *)sender;

- (IBAction)About:(UIButton *)sender;

- (IBAction)Search:(UIButton *)sender;

- (IBAction)Library:(UIButton *)sender;


@property NSString *is_registered;
@property(weak, nonatomic) IBOutlet UIButton *shopbookbtn;
@property(weak, nonatomic) IBOutlet UIButton *aboutbtn;


@end

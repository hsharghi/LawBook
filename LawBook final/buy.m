//
//  buy.m
//  Circles
//
//  Created by saeid1 on 12/2/14.
//  Copyright (c) 2014 turned on digital. All rights reserved.
//

#import "buy.h"

#import "CirclesIAPHelper.h"

@interface buy ()

@end

@implementation buy
NSArray *_products;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];







    //&&&&&&&&&&&&&&&&&&&&&&&&&p
    _products = nil;
    [[CirclesIAPHelper sharedInstance:@"2"] requestProductsWithCompletionHandler:^(BOOL success, NSArray *products) {
        if (success) {_products = products;}
    }];

    //&&&&&&&&&&&&&&&&&&&&&&&&&&&p








}


- (IBAction)buyButtonTapped:(id)sender {





    // set value for id book
    //  NSString *valueToSave = @"3";
    // [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"id_get_book"];
    //[[NSUserDefaults standardUserDefaults] synchronize];



    //  CirclesIAPHelper *cp=[[CirclesIAPHelper alloc] init];
    // cp.id_txt = @"2";


    // call buying method
    SKProduct *product = _products[0];
    NSLog(@"Buying %@... buyButtonTapped in StoreTableViewController", product.productIdentifier);
    [[CirclesIAPHelper sharedInstance:@"2"] buyProduct:product];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

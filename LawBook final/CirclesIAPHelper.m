//
//  CirclesIAPHelper.m
//  Circles - Sibche IAP Sample Project.
//
//  Copyright (c) 2014 Sibche. All rights reserved.
//


#import "CirclesIAPHelper.h"

@implementation CirclesIAPHelper

NSString *name_get_book;

+ (CirclesIAPHelper *)sharedInstance:(NSString *)id_get_book {

    // get id book from user defult
    //  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //  id_get_book = [defaults stringForKey:@"id_get_book"];



    name_get_book = [NSString stringWithFormat:@"%@%@", @"ir.MultiPlatform.LawBook.", id_get_book];
    static dispatch_once_t once;
    static CirclesIAPHelper *sharedInstance;
    once = 0;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                name_get_book,
                        nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}


@end
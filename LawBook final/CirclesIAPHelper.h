//
//  CirclesIAPHelper.h
//  Circles - Sibche IAP Sample Project.
//
//  Copyright (c) 2014 Sibche. All rights reserved.
//


#import "IAPHelper.h"


@interface CirclesIAPHelper : IAPHelper


//@property (strong)   NSString *id_txt;
@property NSString *id_txt;


+ (CirclesIAPHelper *)sharedInstance:(NSString *)id_get_book;

- (BOOL)isPackageConsumableWithProductIdentifier:(NSString *)identifier;

- (NSString *)descriptionForProduct:(SKProduct *)product;

@end
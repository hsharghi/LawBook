//
//  IAPHelper.h
//  Circles - Sibche IAP Sample Project.
//
//  Copyright (c) 2014 Sibche. All rights reserved.
//


@import Foundation;
@import StoreKit;

// Notification constants (we'll use them to notify listeners when a product has been purchased)
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;
UIKIT_EXTERN NSString *const IAPHelperProductPurchaseFailedNotification;

// Block definition
typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray *products);

@interface IAPHelper : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

// Method definitions

// Initializer that takes a list of product identifiers, such as com.TOD.circles.unlockLevels, com.TOD.circles.ExtraLivesPack1, etc.
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;

// Retrieve information about the products from Sibche/AppStore
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

// Starts the purchase process for a product
- (void)buyProduct:(SKProduct *)product;

// Determines if a product has been purchased
- (BOOL)productPurchased:(NSString *)productIdentifier;

@end

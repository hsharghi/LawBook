//
//  IAPHelper.m
//  Circles - Sibche IAP Sample Project.
//
//  Copyright (c) 2014 Sibche. All rights reserved.
//
#import "IAPHelper.h"
// We should define SibcheReplaceRealStoreKit if its not a appstore release so the SibcheStoreKit classes will replace with Apple Storekit modules.
#ifndef APPSTORE_RELEASE
#   define SibcheReplaceRealStoreKit 1
#endif

// You need to use SibcheStorekit to access the In-App Purchase APIs, so you import the SibcheStorekit header here.
//#import <SibcheStorekit/SibcheStorekit.h>

#define kJsonStatusKey                      @"status"
#define kJsonDataKey                        @"data"
#define kJsonErrorKey                       @"error"
#define kJsonRecieptKey                     @"receipt"

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductPurchaseFailedNotification = @"IAPHelperProductPurchaseFailedNotification";

static NSString *sibcheVerfyBaseURL = @"http://my.sibche.ir/payment/verifyreceipt?receipt=";

/*
 To receive a list of products from StoreKit, you need to implement the SKProductsRequestDelegate protocol.
 To track transaction status, we implement the SKPaymentTransactionObserver too.
 */
@interface IAPHelper () <SKProductsRequestDelegate, SKPaymentTransactionObserver>
@end

@implementation IAPHelper {

    NSUserDefaults *setting;
    NSString *imei;
    NSString *username;
    NSString *get_transaction;



    /*
     You create an instance variable to store the results of SKProductsRequest, to retrieve a list of products.
     */
    SKProductsRequest *_productsRequest;
    // You also keep track of the completion handler for the outstanding products request, ...
    RequestProductsCompletionHandler _completionHandler;
    // ... the list of product identifiers passed in, ...
    NSSet *_productIdentifiers;

    NSMutableData *responseData;
}

// Initialitzer to check which products have been purchased
- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    self = [super init];
    if (self) {
        // Store product identifiers
        _productIdentifiers = productIdentifiers;

        // Check for previously purchased products
        // This is important in order to check if a user already purchased products, so that we can show them to the user ...
        for (NSString *productIdentifier in _productIdentifiers) {
            // TODO: create a BOOL value named "productPurchased" and return a BOOL value for a given productIdentifier (boolForKey) for NSUserDefaults' standardUserDefaults method
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                NSLog(@"Previously purchased: %@", productIdentifier);
            } else {
                NSLog(@"Not purchased: %@", productIdentifier);
            }
        }

        // Add self as a transaction observer
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    // A copy of the completion handler block inside the instance variable so it can notify when the asynchronous product request completes
    _completionHandler = [completionHandler copy];

    // Create a new instance of SKProductsRequest (to pull the info from iTunes Connect)
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"Loaded products...");
    _productsRequest = nil;

    NSArray *skProducts = response.products;
    for (SKProduct *skProduct in skProducts) {
        NSLog(@"Found product: %@ – Product: %@ – Price: %0.2f", skProduct.productIdentifier, skProduct.localizedTitle, skProduct.price.floatValue);
    }

    // Method definition; (BOOL success, NSArray * products) ... success=YES, and the array of products is SKProducts
    _completionHandler(YES, skProducts);
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {


    NSLog(@"Failed to load list of products.");

    // Method definition; (BOOL success, NSArray * products) ... success=NO, and the array of products is nil
    _completionHandler(NO, nil);
}

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
}


- (void)buyProduct:(SKProduct *)product {
    NSLog(@"Buying %@ ... (buyProduct ind IAPHelper)", product.productIdentifier);

    // TODO: create a SKPayment object ("payment") and call paymentWithProduct that returns a new payment for the specified product ("product)". (hint: 1 LOC)
    SKPayment *payment = [SKPayment paymentWithProduct:product];

    // TODO: issue the SKPayment to the SKPaymentQueue: make the SKPaymentQueue class call the defaultQueue method and add a payment request to the queue (addPayment) for a given payment ("payment"). (hint: 1 LOC)
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchased:
                [self validateReceiptForTransaction:transaction];
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            default:
                break;
        }
    };
}


// Called when the transaction was successful
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"completeTransaction...");
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];


    get_transaction = [NSString stringWithFormat:@"%@", transaction];


}


// Called when a transaction has failed
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"failedTransaction...");

    if (transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);

//        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"تلاش مجدد"
//                                                          message:@"خطایی در فرایند خرید رخ داده است"
//                                                         delegate:nil
//                                                cancelButtonTitle:@"OK"
//                                                otherButtonTitles:nil];
//        [message show];












    }

    [self sendFailureNotification];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    NSLog(@"provideContentForProductIdentifier");
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification
                                                        object:productIdentifier
                                                      userInfo:nil];
}

// Sends transaction receipt to sibche servers and verfies it. for consumalbe packages its neccassery to verfy the receipt to consume the package.
- (void)validateReceiptForTransaction:(SKPaymentTransaction *)transaction {

    responseData = [NSMutableData data];

    // If you pass a fake reciept to sibche verification server. you will encounter purchase failed message.
    NSString *receipt = [transaction.transactionReceipt base64Encoding];
    NSString *verfyURLString = [NSString stringWithFormat:@"%@%@", sibcheVerfyBaseURL, receipt];
    NSURL *sibcheVerfyUrl = [NSURL URLWithString:verfyURLString];

    // Send check reciept request to sibche server to verfy the transaction receipt. Also this method will consume the non micropayment packages.
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:sibcheVerfyUrl cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:60];
    NSURLConnection *urlConnection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
    [urlConnection start];
}

#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
    NSLog(@"didReceiveData");
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %d bytes of data", [responseData length]);

    // Convert to JSON
    NSError *myError = nil;
    NSDictionary *responseJson = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];

    if (responseJson == nil) {
        NSLog(@"the response from server is not valid JSON.");
        [self sendFailureNotification];
        return;
    }

    BOOL status = [[responseJson valueForKey:kJsonStatusKey] boolValue];
    // The purchased package is verfied.
    if (status) {
        NSDictionary *dataDict = [responseJson valueForKey:kJsonRecieptKey];
        NSString *produnctID = [dataDict valueForKey:@"product_id"];
        [self provideContentForProductIdentifier:produnctID];


        //===============send webservice






        setting = [NSUserDefaults standardUserDefaults];
        //   username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"] ;
        username = [setting stringForKey:@"username"];
        imei = [setting stringForKey:@"imei"];
        // imei = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];


        NSString *str1 = [produnctID stringByReplacingOccurrencesOfString:@"ir.MultiPlatform.LawBook."
                                                               withString:@""];
        NSString *str2 = [get_transaction stringByReplacingOccurrencesOfString:@"<SibcheSKPaymentTransaction: "
                                                                    withString:@""];
        NSString *str3 = [str2 stringByReplacingOccurrencesOfString:@">"
                                                         withString:@""];

        {

            NSString *temp = @"http://intelligent-book.ir/Home/MobAddBookBought?";

            NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", temp, @"&id=", str1, @"&IMEI=", imei, @"&Username=", username, @"&Transaction=", str3];
            NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            NSURL *url = [NSURL URLWithString:temp3];


            // NSError *error;

            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                   cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                               timeoutInterval:10.0];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];
            //[request setHTTPBody: jsonInput];

            [NSURLConnection sendAsynchronousRequest:request
                                               queue:queue
                                   completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                       if (error || !data) {

                                           dispatch_async(dispatch_get_main_queue(), ^{


                                               NSString *message = @"خطا در برقراری ارتباط";
                                               UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                               message:message
                                                                                              delegate:nil
                                                                                     cancelButtonTitle:nil
                                                                                     otherButtonTitles:nil, nil];
                                               [toast show];

                                               int duration = 2; // duration in seconds

                                               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                   [toast dismissWithClickedButtonIndex:0 animated:YES];
                                               });
                                           });


                                       } else {


                                           NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:NSJSONReadingMutableContainers
                                                                                                               error:NULL];


                                           NSString *res;

                                           id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                           NSString *msg1 = [object objectForKey:@"Error"];
                                           NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                           NSLog(msg);
                                           if ([msg isEqualToString:@"0"]) {


                                           } else {

                                               dispatch_async(dispatch_get_main_queue(), ^{


                                                   NSString *message = @"خطا در ثبت داده ها";
                                                   UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                                                                   message:msg
                                                                                                  delegate:nil
                                                                                         cancelButtonTitle:nil
                                                                                         otherButtonTitles:nil, nil];
                                                   int duration = 2; // duration in seconds

                                                   dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                                                       [toast dismissWithClickedButtonIndex:0 animated:YES];
                                                   });
                                               });


                                           }


                                       }


                                   }
            ];


        }















        //=========================







    } else {

        NSString *errorString = [responseJson valueForKey:kJsonErrorKey];
        NSLog(@"errorString :%@", errorString);
        [self sendFailureNotification];
    }
}




//- (void)timer_func:(NSTimer *)sender
//{
//    [sender invalidate];
//    sender = nil;
//    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"پرداخت موفقیت آمیز بود . به کتابخانه بروید"
//                                                      message:nil
//                                                     delegate:nil
//                                            cancelButtonTitle:@"باشه"
//                                            otherButtonTitles:nil];
//}



































- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    [self sendFailureNotification];

}

// Notify listeners that the purchase has failed.
- (void)sendFailureNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchaseFailedNotification
                                                        object:nil
                                                      userInfo:nil];
}


@end

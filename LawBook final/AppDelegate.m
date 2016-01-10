//
//  AppDelegate.m
//  LawBook final
//
//  Created by saeid1 on 8/28/1393 AP.
//  Copyright (c) 1393 MultiPlatform. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import <SibcheStorekit/SibcheStorekit.h>
//#import "TestFairy.h"


#import "DBManager.h"

@implementation AppDelegate

@synthesize orientstion_save;

NSUserDefaults *setting;


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:
        (void (^)(UIBackgroundFetchResult))completionHandler {


    // update kardane etelaat dar background
    NSLog(@"Background fetch started...");
    ViewController *viewController = (ViewController *) self.window.rootViewController;

    //---do background fetch here---
    // You have up to 30 seconds to perform the fetch

    BOOL downloadSuccessful = YES;

    if (downloadSuccessful) {
        [self PostRequest];
    } else {
        //---set the flag that download is not successful---
        completionHandler(UIBackgroundFetchResultFailed);
    }

    NSLog(@"Background fetch completed...");
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


// ersal darkhast baraie dariafte vaziat notification
- (void)PostRequest {

    DBManager *dbManager;
    dbManager = [[DBManager alloc] initWithDatabaseFilename:@"BookDownload"];
    NSString *username = [setting stringForKey:@"username"];
    NSString *imei = [setting stringForKey:@"imei"];
    if (username == nil)
        return;

    NSString *temp = @"http://intelligent-book.ir/home/MobLastPm?";
    NSString *temp2 = [NSString stringWithFormat:@"%@%@%@%@%@%@%d", temp, @"IMEI=", imei, @"&Username=", username, @"&id=", 1];
    NSString *temp3 = [temp2 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSURL *url = [NSURL URLWithString:temp3];


    NSError *error;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"content-type"];


    [NSURLConnection sendAsynchronousRequest:request
                                       queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (error || !data) {

                                   NSLog(@"errrrrooooooor", error);
                                   //[self  Error:@""];
                                   NSLog(@"Background fetch error...");
                               } else {
                                   NSMutableDictionary *ParsedData = [NSJSONSerialization JSONObjectWithData:data
                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                       error:NULL];


                                   id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   NSString *msg1 = [object objectForKey:@"Error"];
                                   NSString *msg = [NSString stringWithFormat:@"%@", msg1];
                                   if ([msg isEqualToString:@"0"]) {

                                       NSArray *exist_ids = [dbManager loadDataFromDB:@"select id from notify"];
                                       NSDictionary *DataArray = ParsedData[@"Payams"];

                                       int notify_id = [DataArray[@"id"] intValue];
                                       int type = [DataArray[@"type"] intValue];
                                       NSString *lile = DataArray[@"lile"];
                                       NSString *body = DataArray[@"body"];
                                       NSString *date = DataArray[@"date"];
                                       Boolean exist = false;

                                       for (int i = 0; i < [exist_ids count]; i++) {
                                           if (notify_id == [[[exist_ids objectAtIndex:i] objectAtIndex:0] intValue]) {
                                               exist = true;
                                               break;
                                           }
                                       }
                                       if (!exist) {

                                           [dbManager executeQuery:[NSString stringWithFormat:@"insert into notify values( '%d' , '%@', '%@', '%d' , '%@')", notify_id, date, body, type, lile]];

                                           NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
                                           [setting setObject:lile forKey:@"notification_title"];
                                           [setting setObject:body forKey:@"notification_body"];

                                           [self show_noty:body title:lile];

                                       }


                                   }
                                   else
                                       NSLog(@"errrrrooooooor", error);
                                   //[self Error:msg];


                               }


                           }

    ];
}


- (void)show_noty:(NSString *)body title:(NSString *)title {
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:5];
    NSString *txt = [NSString stringWithFormat:@"%@ \n\n %@", title, body];


    localNotification.alertBody = txt;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];

    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSUserDefaults *setting = [NSUserDefaults standardUserDefaults];
    [setting setObject:@"1" forKey:@"from_notification"];
    application.applicationIconBadgeNumber = 0;


    [setting setObject:@"0" forKey:@"from_notification"];
    NSString *title = [setting stringForKey:@"notification_title"];
    NSString *body = [setting stringForKey:@"notification_body"];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:title
                                                      message:body
                                                     delegate:nil
                                            cancelButtonTitle:@"باشه"
                                            otherButtonTitles:nil];
    [message show];
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)remoteNotification
{
    // on receive notification nothing has to be done.
    
    NSString *remoteMessage = remoteNotification[@"aps"][@"alert"];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"سامانه هوشمند قوانین" message:remoteMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *aa = [UIAlertAction actionWithTitle:@"باشه" style:UIAlertActionStyleDefault handler:nil
                         ];
    [ac addAction:aa];
    dispatch_async(dispatch_get_main_queue(), ^{
        [application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
        
    });

}



// URL Handler is required to continue the purchase process for Sibche
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {

//    if ([[SibcheCentral sharedInstance] urlIsForMicropayment:url]) {
//        [self setupSibcheVars];
//        return [[SibcheCentral sharedInstance] sibcheHandleOpenURL:url];
//    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSDictionary *remoteNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification) {
        // on receive notification
        NSString *remoteMessage = remoteNotification[@"aps"][@"alert"];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"سامانه هوشمند قوانین" message:remoteMessage preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *aa = [UIAlertAction actionWithTitle:@"باشه" style:UIAlertActionStyleDefault handler:nil
                             ];
        [ac addAction:aa];
        dispatch_async(dispatch_get_main_queue(), ^{
            [application.keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
            
        });
    }

    
//    [TestFairy begin:@"d5bc8f21eee62068f09fbbb4b1a6018925f6c8b2"];


    // sefr kardane notification ha
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];


    UILocalNotification *localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotification) {
        application.applicationIconBadgeNumber = 0;
    }

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

//    UIUserNotificationType *notify = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notify categories:nil];
//    [application registerUserNotificationSettings:settings];
//    [application registerForRemoteNotifications];

    
    //  Parse push service
    [Parse setApplicationId:@"x5fBNS8KdZvn5lHwg9HAJFFSHRUKgaev0cCicDLB" clientKey:@"uM7PJ5RpHvySC9tjDmUG6Fdt0zBCmSR3bVNJgZsG"];
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes  categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

    
//    [self setupSibcheVars];
    return YES;

}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    PFInstallation *install = [PFInstallation currentInstallation];
    [install setDeviceTokenFromData:deviceToken];
    [install saveInBackground];
}

@end

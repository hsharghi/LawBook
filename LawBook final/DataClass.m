//
//  DataClass.m
//  LawBook
//
//  Created by saeid1 on 1/22/15.
//  Copyright (c) 2015 MultiPlatform. All rights reserved.
//

#import "DataClass.h"

@implementation DataClass

@synthesize Request1;
@synthesize Request2;

static DataClass *instance = nil;

+ (DataClass *)getInstance {
    @synchronized (self) {
        if (instance == nil) {
            instance = [DataClass new];
        }
    }
    return instance;
}
@end

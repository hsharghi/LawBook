//
//  DataClass.h
//  LawBook
//
//  Created by saeid1 on 1/22/15.
//  Copyright (c) 2015 MultiPlatform. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface DataClass : NSObject {

    ASIHTTPRequest *Request1;
    ASIHTTPRequest *Request2;

}

@property(nonatomic, retain) ASIHTTPRequest *Request1;
@property(nonatomic, retain) ASIHTTPRequest *Request2;

+ (DataClass *)getInstance;
@end
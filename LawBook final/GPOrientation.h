//
//  GPOrientation.h
//  GPOrientationKit_Test 1.2
//
//  Created by LogiSian, Inc. on 8/3/12.
//  Copyright (c) 2012 LogiSian Inc. All rights reserved.
//
// GPOrientationKit is the library developed by Gautham Pai under the banner LogiSian, Inc. for iOS to support interface orientataion using XIBs.
// The Library is under beta development and may cause error. Do not use in inappropriate condtions.

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Differenent Reference index. Please check the documentation in logisian.blogspot.com
typedef enum {
    GPOrientationReferenceIndex,
    GPOrientationReferenceTag,
} GPOrientationReference;

@protocol GPOrientationDelegate <NSObject>

@optional
// Called after the UI is rendered for perticular orientation.
//
// @interfaceOrientation returns the orientation for which the UI is rendered.

- (void)didChangeUIForOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

@interface GPOrientation : NSObject

@property(nonatomic, assign) id <GPOrientationDelegate> delegate;

@property(nonatomic) GPOrientationReference orientationReference;

// Pass the delegate as self.
// Differenent Reference index. Please check the documentation in logisian.blogspot.com
- (id)initWithNibName:(NSString *)nibName
             delegate:(id)sender
 orientationReference:(GPOrientationReference)orientationReference;


// Manually render interfaceOrientaion. Not recomended by LogiSian.
- (void)renderViewForInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

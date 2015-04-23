//
//  UIASample.h
//  uia2junit
//
//  Created by George Lee on 5/12/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIASample : NSObject {
    NSString* logType;
    NSString* message;
    NSDate* timestampString;
    NSInteger sampleType;
    long testCaseDuration;
}

@property (nonatomic, retain) NSString* logType;
@property (nonatomic, retain) NSString* message;
@property (nonatomic, retain) NSDate* timestampString;
@property (nonatomic) NSInteger sampleType;
@property (nonatomic) long testCaseDuration;

- (id)initWithDictionary:(NSDictionary*)plist;
- (BOOL)isaTest;

@end

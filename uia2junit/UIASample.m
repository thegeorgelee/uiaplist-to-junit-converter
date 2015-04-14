//
//  UIASample.m
//  uia2junit
//
//  Created by George Lee on 5/12/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import "UIASample.h"
#import "UIACommon.h"

@implementation UIASample
@synthesize logType;
@synthesize message;
@synthesize timestampString;
@synthesize testCaseDuration;
@synthesize sampleType;

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}
//each dict is passed here and is a testcase
- (id)initWithDictionary:(NSDictionary*)plist
{
    if (self = [super init]) {
        [self setLogType:[plist objectForKey:@"LogType"]];
        [self setMessage:[plist objectForKey:@"Message"]];
        [self setTimestampString:[plist objectForKey:@"Timestamp"]];
        [self setSampleType:[[plist objectForKey:@"Type"] intValue]];
    }
    return self;
}

// There are four types of samples
// LogType(Type) = Pass(5), Debug(0), Fail(7), Default(1)
// Only two of them are actually results from a test case, the rest are log type statements
- (BOOL)isaTest
{
    if (sampleType == UIA_SAMPLE_TYPE_PASS || sampleType == UIA_SAMPLE_TYPE_FAIL || sampleType == UIA_SAMPLE_TYPE_ERROR ) {
        return YES;
    }
    return NO;
}

- (void)setTestCaseDuration:(long)newValue
{
    testCaseDuration = newValue;
}

/*
 - (NSXMLElement *) toXML {
 
 
 }
 */

- (void)dealloc
{
    [logType release];
    logType = nil;
    [message release];
    message = nil;
    [timestampString release];
    timestampString = nil;
    //    [sampleType release]; sampleType = nil;
    
    [super dealloc];
}

@end

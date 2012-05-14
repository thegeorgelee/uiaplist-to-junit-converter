//
//  UIASample.m
//  uia2junit
//
//  Created by George Lee on 5/12/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import "UIASample.h"

@implementation UIASample
@synthesize logType;
@synthesize message;
@synthesize timestampString;
@synthesize type;

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary *)plist {
    if (self = [super init]) {
        [self setLogType:[plist objectForKey:@"LogType"]];
        [self setMessage:[plist objectForKey:@"Message"]];
        [self setTimestampString:[plist objectForKey:@"Timestamp"]];
        [self setType:[plist objectForKey:@"Type"]];
    }
    return self;
}

// There are four types of samples
// LogType(Type) = Pass(5), Debug(0), Fail(7), Default(1)
// Only two of them are actually results from a test case, the rest are log type statements
- (BOOL) isaTest {
    if ([logType isEqualToString:@"Pass"] || [logType isEqualToString:@"Fail"]) {
        return YES;
    }
    return NO;
}

/*
- (NSXMLElement *) toXML {
    
    
}
*/

- (void) dealloc {
    [logType release]; logType = nil;
    [message release]; message = nil;
    [timestampString release]; timestampString = nil;
    [type release]; type = nil;
    
    [super dealloc];
}

@end

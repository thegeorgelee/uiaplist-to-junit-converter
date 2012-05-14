//
//  UIATestCase.m
//  uia2junit
//
//  Created by George Lee on 5/14/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import "UIATestCase.h"
#import "UIASample.h"

@implementation UIATestCase

@synthesize testSample;
@synthesize logSamples;

- (id) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void) dealloc {
    [testSample release];
    [logSamples release];

    [super dealloc];
}

/*
 <testcase assertions="" classname="" name="" status="" time="">
 <skipped/>
 <error message="" type=""/>
 <error message="" type=""/>
 <failure message="" type=""/>
 <failure message="" type=""/>
 <system-out/>
 <system-out/>
 <system-err/>
 <system-err/>
 </testcase>
 */

+ (NSXMLElement *) elementWithName:(NSString *)name value:(NSString *)value {
    NSXMLElement *child = [[NSXMLElement alloc] initWithName:name];        
    [child setStringValue:value];
    
    return [child autorelease];
}

- (NSXMLElement *) toXML {
    NSXMLElement *testcase = [[NSXMLElement alloc] initWithName:@"testcase"];
    [testcase addAttribute:[NSXMLNode attributeWithName:@"timestamp" stringValue:[testSample timestampString]]];    
    
    // loop through and add each of the debug statements
    for (UIASample *sample in logSamples) {
        NSXMLElement *log = [UIATestCase elementWithName:@"system-out" value:[sample message]];
        [testcase addChild:log];
    }
    
    // add ourselves as a system out
    NSXMLElement *desc = [UIATestCase elementWithName:@"system-out" value:[testSample message]];
    [testcase addChild:desc];
    
    return testcase;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<%@: %p - testSample:%p logSamples:%p>", 
			[self class], self, testSample, logSamples];
}

@end

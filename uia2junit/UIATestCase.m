//
//  UIATestCase.m
//  uia2junit
//
//  Created by George Lee on 5/14/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import "UIATestCase.h"
#import "UIASample.h"
#import "UIACommon.h"

@implementation UIATestCase
@synthesize name;
@synthesize className;
@synthesize testSample;
@synthesize logSamples;

- (id)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc
{
    [name release];
    name = nil;
    [className release];
    className = nil;
    [testSample release];
    testSample = nil;
    [logSamples release];
    logSamples = nil;
    
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

+ (NSXMLElement*)elementWithName:(NSString*)name value:(NSString*)value
{
    NSXMLElement* child = [[NSXMLElement alloc] initWithName:name];
    [child setStringValue:value];
    
    return [child autorelease];
}

- (NSXMLElement*)toXML
{
    NSXMLElement* testcase = [[NSXMLElement alloc] initWithName:@"testcase"];
    NSString* testCaseDurationString = [NSString stringWithFormat:@"%ld", [testSample testCaseDuration]];
    [testcase addAttribute:[NSXMLNode attributeWithName:@"classname" stringValue:className]];
    [testcase addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:name]];
    [testcase addAttribute:[NSXMLNode attributeWithName:@"time" stringValue:testCaseDurationString]];
    
    //not adding log or debug statements since
    // loop through and add each of the debug statements
    //for (UIASample* sample in logSamples) {
    //    NSXMLElement* log = [UIATestCase elementWithName:@"system-out" value:[sample message]];
    //[testcase addChild:log];
    //  }
    
    // if success then add ourselves as a system out, else add as a failure
    // add ourselves as a system out
    // LogType(Type) = Pass(5), Debug(0), Fail(7), Default(1)
    
    if ([testSample sampleType] == UIA_SAMPLE_TYPE_FAIL || [testSample sampleType] == UIA_SAMPLE_TYPE_ERROR) {
        //NSLog(@"testSample message: %d", [testSample message]);
        NSXMLElement* testfail = [UIATestCase elementWithName:@"failure" value:[testSample message]];
        //[testcase addAttribute:[NSXMLNode attributeWithName:@"message" stringValue:[testSample message]]];
        [testcase addChild:testfail];
    }
    else {
        NSXMLElement* desc = [UIATestCase elementWithName:@"system-out" value:@""]; //[testSample message]];
        //[testcase addAttribute:[NSXMLNode attributeWithName:@"message" stringValue:[testSample message]]];
        [testcase addChild:desc];
    }
    
    return testcase;
}

- (NSString*)description
{
    return [NSString stringWithFormat:@"<%@: %p - testSample:%p logSamples:%p>",
            [self class], self, testSample, logSamples];
}

@end

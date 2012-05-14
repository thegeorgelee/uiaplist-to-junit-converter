//
//  UIAConverter.m
//  uia2junit
//
//  Created by George Lee on 5/10/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import "UIAResultsConverter.h"
#import "UIASample.h"
#import "UIATestCase.h"

@implementation UIAResultsConverter

@synthesize commandLineArgs;

- (id) initWithCommandLineArgs:(NSDictionary *)args {
    if (self = [super init]) {
        NSLog(@"UIAResultsConverter init");
        self.commandLineArgs = args;
    }
    return self;
}


// Convert from a plist dictionary to a list of testCases
- (NSArray *) testCasesFromPList:(NSDictionary *)plist {
    
    // find the samples part of the dictionary
    NSArray *plistSamples = [plist objectForKey:@"All Samples"];
    
    // array of log output which is not an acutal pass/fail test
    NSMutableArray *logArray = [NSMutableArray arrayWithCapacity:[plistSamples count]];
    
    NSMutableArray *testCases = [NSMutableArray arrayWithCapacity:[plistSamples count]];
    for (NSDictionary *sampleDict in plistSamples) {
        NSLog(@"Processing sampleDict=%@", sampleDict);
         
        // There are four types of samples
        // LogType(Type) = Pass(5), Debug(0), Fail(7), Default(1)
        
        // Look for a Pass/Fail sample and stuff all previous Debug/Default output as
        // Standard Output of the testcase
        UIASample *sample = [[UIASample alloc] initWithDictionary:sampleDict];
        if ([sample isaTest]) {
            UIATestCase *testCase = [[UIATestCase alloc] init];
            [testCase setLogSamples:logArray];
            [testCase setTestSample:sample];
            [testCases addObject:testCase];
            [testCase release];
            // clear the logs as we have a new test case
            logArray = [NSMutableArray arrayWithCapacity:[plistSamples count]];
        } else {
            [logArray addObject:sample];
        }
    }
    return testCases;
}


// Run the conversion
- (NSXMLDocument *) convert:(NSDictionary *)plist {
    NSLog(@"UIAResultsConverter convert");

    
    // convert into testcases
    NSArray *testCases = [self testCasesFromPList:plist];

    // dump the testcases into xml
    NSXMLElement *root = [[NSXMLElement alloc] initWithName:@"testsuite"];
    NSXMLDocument *document = [[NSXMLDocument alloc] init];
    [document setRootElement:root];
    
    // loop through and add the testcases
    for (UIATestCase *tc in testCases) {
        [root addChild:[tc toXML]];        
    }

    return document;
}

- (void) run {
    // read the plist
    NSString *plistPath = [commandLineArgs objectForKey:@"inputPlist"];
    NSDictionary *plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // process it
    NSXMLDocument *jUnitXML = [self convert:plist];
    
    // write the file
    NSString *outputPath = [commandLineArgs objectForKey:@"outputPath"];
    NSError *error = nil;
    [[jUnitXML XMLString] writeToFile:outputPath 
                                          atomically:NO 
                                            encoding:NSUTF8StringEncoding 
                                               error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

- (void) dealloc {
    NSLog(@"UIAResultsConverter dealloc");

    [commandLineArgs release];
    commandLineArgs = nil;
    
    [super dealloc];
}

@end

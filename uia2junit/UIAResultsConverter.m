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

#define ERR_DOMAIN @"UIAResultsConverter"
#define ERRID_FULL_PATH 100
#define ERRID_FAILED_FIND_PARENT 101

@implementation UIAResultsConverter

@synthesize commandLineArgs;

- (id)initWithCommandLineArgs:(NSDictionary*)args
{
    if (self = [super init]) {
        NSLog(@"UIAResultsConverter init");
        self.commandLineArgs = args;
    }
    return self;
}

// Convert from a plist dictionary to a list of testCases
- (NSArray*)testCasesFromPList:(NSDictionary*)plist
{
    
    // find the samples part of the dictionary
    NSArray* plistSamples = [plist objectForKey:@"All Samples"];
    
    //totalTestCaseCount = [plistSamples count];
    // array of log output which is not an acutal pass/fail test
    NSMutableArray* logArray = [NSMutableArray arrayWithCapacity:[plistSamples count]];
    NSLog(@"%lu", (unsigned long)[plistSamples count]);
    
    // we need names for the testcases so that we don't crash the jenkins plist processor
    // create names and classnames for each of the testcases
    // if we are passed in classname or name then use it, for names use test and keep adding one to it
    NSString* className = ([commandLineArgs objectForKey:@"classname"]) ? [commandLineArgs objectForKey:@"classname"] : @"InstrumentsTest";
    NSString* name = ([commandLineArgs objectForKey:@"name"]) ? [commandLineArgs objectForKey:@"name"] : @"test";
    
    NSMutableArray* testCases = [NSMutableArray arrayWithCapacity:[plistSamples count]];
    NSInteger i = 1;
    for (NSDictionary* sampleDict in plistSamples) {
        NSLog(@"Processing sampleDict=%@", sampleDict);
        
        // There are four types of samples
        // LogType(Type) = Pass(5), Debug(0), Fail(7), Default(1)
        
        // Look for a Pass/Fail sample and stuff all previous Debug/Default output as
        // Standard Output of the testcase
        UIASample* sample = [[UIASample alloc] initWithDictionary:sampleDict];
        if ([sample isaTest]) {
            UIATestCase* testCase = [[UIATestCase alloc] init];
            [testCase setLogSamples:logArray];
            [testCase setTestSample:sample];
            [testCase setName:[NSString stringWithFormat:@"%@_%d", name, i]];
            //NSLog(@"className: %d", className);
            [testCase setClassName:className];
            
            //NSLog(@"sample logtype--> %@", [sample logType]);
            
            //            if ([[sample logType] isEqualToString:@"Pass"]) {
            //                passCount++;
            //            }
            //            else if ([[sample logType] isEqualToString:@"Fail"]) {
            //                failCount++;
            //            }
            
            // add to the set of testcases
            [testCases addObject:testCase];
            [testCase release];
            // clear the logs as we have a new test case
            logArray = [NSMutableArray arrayWithCapacity:[plistSamples count]];
            
            // add one as we have just created a new testcase
            i++;
        }
        // We are some sort of log output, just add to the samples array
        else {
            //is not a pass/fail/default test
            [logArray addObject:sample];
        }
    }
    
    // classname=@"
    return testCases;
}

// Run the conversion
- (NSXMLDocument*)convert:(NSDictionary*)plist
{
    NSLog(@"UIAResultsConverter convert");
    
    // convert into testcases
    NSArray* testCases = [self testCasesFromPList:plist];
    passCount = 0;
    failCount = 0;
    NSInteger i = 0;
    totalTestCaseCount = [testCases count];
    
    for (UIATestCase* testCase in testCases) {
        UIASample* currentTestcase = [testCase testSample];
        
        i++;
        NSString *logType = [currentTestcase logType];
        // NSDate *currentTime = [currentTestcase timestampString];
        
        // NSLog(@"%ld) %@", (long)i, currentDate);
        
        if ([logType  isEqual: @"Pass"]) {
            passCount++;
            NSLog(@"%ld) %@", (long)i, logType);
        }
        else if ([logType  isEqual: @"Fail"]) {
            failCount++;
            NSLog(@"%ld) %@", (long)i, logType);
        }
        NSString* testcaseCount = [NSString stringWithFormat:@"%lu", (unsigned long)totalTestCaseCount];
        NSString* passTestCount = [NSString stringWithFormat:@"%lu", (unsigned long)passCount];
        NSString* failTestCount = [NSString stringWithFormat:@"%lu", (unsigned long)failCount];
        
        NSLog(@"failCount: %lu\tpassCount: %lu\t total: %lu", failCount, passCount, (long) totalTestCaseCount);
        
        
    }
    
    NSString* testcaseCount = [NSString stringWithFormat:@"%lu", (unsigned long)totalTestCaseCount];
    NSString* passTestCount = [NSString stringWithFormat:@"%lu", (unsigned long)passCount];
    NSString* failTestCount = [NSString stringWithFormat:@"%lu", (unsigned long)failCount];
    
    NSLog(@"failCount: %lu\tpassCount: %lu\t total: %lu", failCount, passCount, (long) totalTestCaseCount);
    // dump the testcases into xml
    NSXMLElement* root = [[NSXMLElement alloc] initWithName:@"testsuite"];
    [root addAttribute:[NSXMLNode attributeWithName:@"tests" stringValue:testcaseCount]];
    [root addAttribute:[NSXMLNode attributeWithName:@"name" stringValue:@"com.ibm.mil.Kohls"]];
    //[root addAttribute:[NSXMLNode attributeWithName:@"success" stringValue:passTestCount]];
    [root addAttribute:[NSXMLNode attributeWithName:@"failures" stringValue:failTestCount]];
    [root addAttribute:[NSXMLNode attributeWithName:@"hostname" stringValue:@"ibms-mac-mini.austin.ibm.com"]];
    [root addAttribute:[NSXMLNode attributeWithName:@"time" stringValue:@"0"]];
    NSXMLDocument* document = [[NSXMLDocument alloc] init];
    [document setRootElement:root];
    
    // loop through and add the testcases
    for (UIATestCase* tc in testCases) {
        [root addChild:[tc toXML]];
    }
    
    return document;
}

- (BOOL)writeFile:(NSString*)outputPath xmlDoc:(NSXMLDocument*)xmlDoc error:(NSError**)error
{
    NSLog(@"Writing to file: %@", outputPath);
    BOOL success = NO;
    
    // check file existence
    NSFileManager* fm = [[NSFileManager alloc] init];
    BOOL isDir = NO;
    BOOL isFileExist = [fm fileExistsAtPath:outputPath isDirectory:&isDir];
    
    // input should not be a directory, should be a full path
    if (isFileExist && isDir) {
        NSString* msg = [NSString stringWithFormat:@"Specify the full path to the output file and not just the output directory: %@", outputPath];
        *error = [UIAResultsConverter errorWithMessage:msg code:ERRID_FULL_PATH];
        success = NO;
    }
    else {
        // input filename is not a dir, continue and make sure parent is a dir
        NSString* parentDir = [outputPath stringByDeletingLastPathComponent];
        if ([fm fileExistsAtPath:parentDir isDirectory:&isDir] && isDir) {
            
            // everything looks good, write the file
            NSData* xmlData = [xmlDoc XMLDataWithOptions:NSXMLNodePrettyPrint];
            success = [xmlData writeToFile:outputPath options:NSDataWritingAtomic error:error];
            /*            success = [[xmlDoc XMLString] writeToFile:outputPath
             atomically:NO
             encoding:NSUTF8StringEncoding
             error:error];
             */
            if (!success) {
                NSLog(@"%@", [*error localizedDescription]);
                success = NO;
            }
        }
        else {
            NSString* msg = [NSString stringWithFormat:@"Did not find parent directory %@", parentDir];
            *error = [UIAResultsConverter errorWithMessage:msg code:ERRID_FAILED_FIND_PARENT];
            success = NO;
        }
    }
    [fm release];
    
    return success;
}

+ (NSError*)errorWithMessage:(NSString*)errString code:(NSInteger)code
{
    NSLog(@"%@", errString);
    
    NSMutableDictionary* errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:errString forKey:NSLocalizedDescriptionKey];
    NSError* error = [NSError errorWithDomain:ERR_DOMAIN
                                         code:code
                                     userInfo:errorDetail];
    return error;
}

- (BOOL)run:(NSError**)error
{
    // read the plist
    NSString* plistPath = [commandLineArgs objectForKey:@"inputPlist"];
    NSDictionary* plist = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    // process it
    NSXMLDocument* jUnitXML = [self convert:plist];
    
    // write the file
    NSString* outputPath = [commandLineArgs objectForKey:@"outputPath"];
    BOOL success = [self writeFile:outputPath xmlDoc:jUnitXML error:error];
    
    return success;
}

- (void)dealloc
{
    NSLog(@"UIAResultsConverter dealloc");
    
    [commandLineArgs release];
    commandLineArgs = nil;
    
    [super dealloc];
}

@end

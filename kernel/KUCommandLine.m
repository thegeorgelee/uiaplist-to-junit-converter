//
//  main.c
//  uia2junit
//
//  Created by George Lee on 5/10/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#include <stdio.h>
#include <Foundation/Foundation.h>

#import "KUCommandLine.h"
#import "UIAResultsConverter.h"

int main(int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    NSLog (@"Starting uia2junit");
    
    // process the arguments
    
    NSArray *required = [NSArray arrayWithObjects:@"inputPlist", @"outputPath", nil];
    KUCommandLine *commandLine = [[KUCommandLine alloc] initWithRequiredArgumentKeys:required];
    
    //x    BOOL isValidArgs = NO;
    if (! [[commandLine allArguments] objectForKey:@"inputPlist"]) {
        NSLog(@"Please specify the input PropertyList file.");
        return 0;
    }
    if (! [[commandLine allArguments] objectForKey:@"outputPath"]) {
        NSLog(@"Please specify the output file.");
        return 0;
    }
    
    // create the converter
    UIAResultsConverter *converter = [[UIAResultsConverter alloc] initWithCommandLineArgs:[commandLine allArguments]];
    
    // this actually converts the plist to the jUnit
    NSError *error = nil;
    BOOL success = [converter run:&error];
    
    if (success) {
        NSLog (@"Successful conversion");
        
    } else {
        NSLog(@"Failed conversion");
    }
    NSInteger rtnCode = (success) ? 0 : [error code];
    
    // we are done with it
    [converter release];
    
    NSLog (@"Ending uia2junit");
    
    [pool drain];
    
    return rtnCode;
}

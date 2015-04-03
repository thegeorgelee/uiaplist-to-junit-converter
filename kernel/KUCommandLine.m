//
//  KUCommandLine.m
//  uia2junit
//
//  Created by George Lee on 5/10/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import "KUCommandLine.h"

@implementation KUCommandLine

@synthesize  allArguments;

// Command lines have optional arguments and required arguments
// given a set of

// Call:
// Passed in command line:
// -h --help -check dog --check cat fog --bar baz -faser fff foo bar
// Called with (
- (id) initWithRequiredArgumentKeys:(NSArray *)requiredArgKeys {
    if (self = [super init]) {
        // all arguments on the command line
        NSArray *clAll = [[NSProcessInfo processInfo] arguments];
        NSLog(@"clAll=%@", clAll);
        
        // set the class variable
        allArguments = [[NSMutableDictionary alloc] initWithCapacity:[clAll count]];
        
        // process the optional arguments
        // WARN: for some reason -h and --help are stripped from NSArgumentDomain
        NSDictionary *clOptional = [[NSUserDefaults standardUserDefaults] volatileDomainForName:NSArgumentDomain];
        NSLog(@"Command line options %@", clOptional);
        
        // add the optional arguments to the entire set
        [allArguments addEntriesFromDictionary:clOptional];
        
        // strip the optionals from the command line
        NSMutableArray *clRequired = [NSMutableArray arrayWithCapacity:[clAll count]];
        
        NSInteger i = 1;  // ignore the zeroth arg in clAll because that is the name of the program we just called
        while (i < [clAll count]) {
            // ig
            NSString *arg = [clAll objectAtIndex:i];
            // if start with a dash then remove
            if ([[arg substringToIndex:1] isEqualToString:@"-"]) {
                i++;
                // if we have just passed an dash and the next value is not dashed
                // then it is the value of the optional, also remove
                if (i < [clAll count]) {
                    NSString *possibleValue = [clAll objectAtIndex:i];
                    if (! [[possibleValue substringToIndex:1] isEqualToString:@"-"]) {
                        i++;
                    }
                }
            } else {
                [clRequired addObject:[clAll objectAtIndex:i]];
                i++;
            }
        }
        NSLog(@"clRequired=%@", clRequired);
        
        // if there are more args then required then just drop them, if fewer then required
        for (NSInteger i=0; i<[requiredArgKeys count]; i++) {
            if (i < [clRequired count] && [clRequired objectAtIndex:i]) {
                [allArguments setObject:[clRequired objectAtIndex:i] forKey:[requiredArgKeys objectAtIndex:i]];
            } else if (i < [clRequired count]) {
                NSLog(@"Cannot find arguments for: %@", [clRequired objectAtIndex:i]);
            }
        }
        
        //        NSDictionary *reqDict = [NSDictionary dictionaryWithObjects:clRequired forKeys:requiredArgKeys];
        //        [allArguments addEntriesFromDictionary:reqDict];
        
        NSLog(@"allArguments=%@", allArguments);
    }
    return self;
}

- (void) junk {
    
}

- (void) dealloc {
    [allArguments release];
    allArguments = nil;
    
    [super dealloc];
}

@end

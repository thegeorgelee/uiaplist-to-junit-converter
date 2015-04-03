//
//  UIAConverter.h
//  uia2junit
//
//  Created by George Lee on 5/10/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAResultsConverter : NSObject {
    NSDictionary* commandLineArgs;
    NSInteger passCount;
    NSInteger failCount;
    NSInteger totalTestCaseCount;
}

@property (nonatomic, retain) NSDictionary* commandLineArgs;

- (id)initWithCommandLineArgs:(NSDictionary*)args;
- (NSArray*)testCasesFromPList:(NSDictionary*)plist;
- (NSXMLDocument*)convert:(NSDictionary*)plist;
- (BOOL)run:(NSError**)error;
- (BOOL)writeFile:(NSString*)outputPath xmlDoc:(NSXMLDocument*)xmlDoc error:(NSError**)error;
@end

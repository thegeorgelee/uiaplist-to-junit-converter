//
//  UIAConverter.h
//  uia2junit
//
//  Created by George Lee on 5/10/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAResultsConverter : NSObject {
    NSDictionary *commandLineArgs;    
}

@property (nonatomic, retain) NSDictionary *commandLineArgs;

- (id) initWithCommandLineArgs:(NSDictionary *)args;
- (NSXMLDocument *) convert;
- (void) run;


@end


//
//  UIATestCase.h
//  uia2junit
//
//  Created by George Lee on 5/14/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UIASample;

@interface UIATestCase : NSObject {
    NSString *name;
    NSString *className;
    UIASample *testSample;
    NSArray *logSamples;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *className;
@property (nonatomic, retain) UIASample *testSample;
@property (nonatomic, retain) NSArray *logSamples;

- (NSXMLElement *) toXML;

@end

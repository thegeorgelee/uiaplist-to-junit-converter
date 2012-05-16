//
//  UIASample.h
//  uia2junit
//
//  Created by George Lee on 5/12/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIASample : NSObject {    
    NSString *logType;
    NSString *message;
    NSString *timestampString;
    NSInteger sampleType;
}

@property (nonatomic, retain) NSString *logType;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *timestampString;
@property (nonatomic) NSInteger sampleType;

- (id) initWithDictionary:(NSDictionary *)plist;
- (BOOL) isaTest;

@end

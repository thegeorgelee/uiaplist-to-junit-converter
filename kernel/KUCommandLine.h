//
//  KUCommandLine.h
//  uia2junit
//
//  Created by George Lee on 5/10/12.
//  Copyright (c) 2012 Kuchbi Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KUCommandLine : NSObject {
    NSMutableDictionary *allArguments;
}

@property (nonatomic, retain) NSMutableDictionary *allArguments;

- (id) initWithRequiredArgumentKeys:(NSArray *)requiredArgKeys;

@end

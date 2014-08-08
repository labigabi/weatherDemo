//
//  NetworkEngine.h
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.08..
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MKNetworkKit/MKNetworkKit.h>

@interface NetworkEngine : NSObject

+ (MKNetworkEngine*) engine;
    
@end

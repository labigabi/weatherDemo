//
//  NetworkEngine.m
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.08..
//  Copyright (c) 2014 test. All rights reserved.
//

#import "NetworkEngine.h"

@interface NetworkEngine ()
@property (nonatomic, strong) MKNetworkEngine *engine;
@end

@implementation NetworkEngine


+ (NetworkEngine*) sharedNetworkEngine{
    static NetworkEngine *engine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [NetworkEngine new];
    });
    return engine;
}

- (id) init{
    self = [super init];
    if (self) {
        _engine = [[MKNetworkEngine alloc] initWithHostName:@"api.openweathermap.org" apiPath:@"/data/2.5" customHeaderFields:nil];
    }
    return self;
}


+ (MKNetworkEngine*) engine{
    return [[NetworkEngine sharedNetworkEngine] engine];
}

@end

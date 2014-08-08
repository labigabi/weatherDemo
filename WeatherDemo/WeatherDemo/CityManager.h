//
//  CityManager.h
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.08..
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CityManagerDidFinishRefresh)();
typedef void(^CityManagerDidFinishSearch)(NSArray *cities);

@interface CityManager : NSObject

- (void) refreshDatabaseFromNetworkCompletionHandler:(CityManagerDidFinishRefresh)onComplete;

- (void) searchForCityWithString:(NSString*)partCityName completionHandler:(CityManagerDidFinishSearch)onComplete;

@end

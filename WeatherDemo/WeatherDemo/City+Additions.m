//
//  City+Additions.m
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.08..
//  Copyright (c) 2014 test. All rights reserved.
//

#import "City+Additions.h"

@implementation City (Additions)

- (NSString*) description{
    return [NSString stringWithFormat:@"%@[%@] - %@, %@ %@", self.cityName, self.countryCode, self.cityID, self.latitude, self.longitude];
}

@end

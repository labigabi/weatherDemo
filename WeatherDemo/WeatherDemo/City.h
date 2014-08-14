//
//  City.h
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.14..
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSNumber * cityID;
@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSString * countryCode;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSNumber * favorite;

@end

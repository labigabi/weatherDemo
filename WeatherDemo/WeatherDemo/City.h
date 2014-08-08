//
//  City.h
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.08..
//  Copyright (c) 2014 test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface City : NSManagedObject

@property (nonatomic, retain) NSString * cityName;
@property (nonatomic, retain) NSNumber * cityID;

@end

//
//  CityManager.m
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.08..
//  Copyright (c) 2014 test. All rights reserved.
//

#import "CityManager.h"
#import "AppDelegate.h"
#import "City.h"

@implementation CityManager

- (void) refreshDatabaseFromNetworkCompletionHandler:(CityManagerDidFinishRefresh)onComplete{
    MKNetworkOperation *op = [[NetworkEngine engine] operationWithURLString:@"http://openweathermap.org/help/city_list.txt"];
//    __weak CityManager *weakSelf = self;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSString *cityList = [completedOperation responseStringWithEncoding:NSASCIIStringEncoding];
        if (cityList) {
            //remove all old cities from db
            [self removeAllCities];
            
            //parse new cities
            [self parseCityListString:cityList];
            
            if (onComplete) {
                onComplete();
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [[NetworkEngine engine] enqueueOperation:op];
}

- (void) removeAllCities{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = [appdelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:context]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error;
    NSArray *allCities = [context executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ajjajj: %@", error);
    }else{
        for (City *actCity in allCities) {
            [context deleteObject:actCity];
        }
        [context save:&error];
        if (error) {
            NSLog(@"error saving after delete");
        }
    }
}

- (void) parseCityListString:(NSString*)cityListString{
    NSArray *rows = [cityListString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *actRow in rows) {
        NSArray *items = [actRow componentsSeparatedByString:@"\t"];
        if ([items count] >= 2) {
            NSLog(@"%@ - %@", items[1], items[0]);
            
            NSNumber *cityId = @([items[0] integerValue]);
            [self addCityWithName:items[1] cityID:cityId];
        }
    }
    
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate saveContext];
}

- (void) addCityWithName:(NSString*)cityName cityID:(NSNumber*)cityID{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"City" inManagedObjectContext:context];
    
    City *act = [[City alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:context];
    act.cityName = cityName;
    act.cityID = cityID;
}

- (void) searchForCityWithString:(NSString*)partCityName completionHandler:(CityManagerDidFinishSearch)onComplete{
    
    
}


@end

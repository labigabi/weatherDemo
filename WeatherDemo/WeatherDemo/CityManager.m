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
    NSFetchRequest *fetchRequest = [NSFetchRequest new];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"City" inManagedObjectContext:[self context]]];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error;
    NSArray *allCities = [[self context] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        NSLog(@"ajjajj: %@", error);
    }else{
        for (City *actCity in allCities) {
            [[self context] deleteObject:actCity];
        }
        [self saveContext];
    }
}

- (void) parseCityListString:(NSString*)cityListString{
    NSArray *rows = [cityListString componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    for (NSString *actRow in rows) {
        NSArray *items = [actRow componentsSeparatedByString:@"\t"];
        if ([items count] >= 5) {
//            NSLog(@"%@", items);
            
            NSNumber *cityId = @([items[0] integerValue]);
            NSString *cityName = items[1];
            NSString *latitude = items[2];
            NSString *longitude = items[3];
            NSString *countryCode = items[4];
            
            [self addCityWithName:cityName cityID:cityId countryCode:countryCode latitude:latitude longitude:longitude];
        }
    }
    
    [self saveContext];
}

- (void) addCityWithName:(NSString*)cityName
                  cityID:(NSNumber*)cityID
             countryCode:(NSString*)countryCode
                latitude:(NSString*)latitude
               longitude:(NSString*)longitude{
    
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"City" inManagedObjectContext:[self context]];
    
    City *act = [[City alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:[self context]];
    act.cityName = cityName;
    act.cityID = cityID;
    act.countryCode = countryCode;
    act.longitude = longitude;
    act.latitude = latitude;
}

- (void) searchForCityWithString:(NSString*)partCityName completionHandler:(CityManagerDidFinishSearch)onComplete{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:[self context]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName BEGINSWITH[cd] %@", partCityName];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self context] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"ERROR: %@", error);
    }
    
    NSLog(@"result: %@", fetchedObjects);
    
    onComplete(fetchedObjects);
}

- (void) saveFavoriteCities:(NSArray*)favCities{
    for (City *actCity in favCities) {
        actCity.favorite = @YES;
    }
    [self saveContext];
}

- (NSArray*) loadFavoriteCities{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"City" inManagedObjectContext:[self context]];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"favorite = YES"];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cityName"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [[self context] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"ERROR: %@", error);
    }
    
    NSLog(@"result: %@", fetchedObjects);
    
    return fetchedObjects;
}


- (NSManagedObjectContext*) context{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    NSManagedObjectContext *context = appdelegate.managedObjectContext;
    return context;
}

- (void) saveContext{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate saveContext];
}

@end

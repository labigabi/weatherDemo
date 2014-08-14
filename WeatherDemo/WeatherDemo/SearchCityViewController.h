//
//  SearchCityViewController.h
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.12..
//  Copyright (c) 2014 test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "City.h"

@class SearchCityViewController;

@protocol SearchCityViewControllerDelegate <NSObject>

- (void) searchCityViewController:(SearchCityViewController*)searchCityViewController didSelectCity:(City*)city;

@end

@interface SearchCityViewController : UIViewController

@property (nonatomic, weak) id<SearchCityViewControllerDelegate> delegate;

@end





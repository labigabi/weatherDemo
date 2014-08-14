//
//  CityListViewController.m
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.12..
//  Copyright (c) 2014 test. All rights reserved.
//

#import "CityListViewController.h"
#import "SearchCityViewController.h"
#import "CityManager.h"

@interface CityListViewController () <UITableViewDataSource, UITableViewDelegate, SearchCityViewControllerDelegate>
@property (nonatomic, weak) IBOutlet UITableView *cityListTableView;
@property (nonatomic, strong) NSMutableArray *favoriteCities;
@property (nonatomic, strong) CityManager *cityManager;
@end

@implementation CityListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.favoriteCities = [NSMutableArray new];
        self.cityManager = [CityManager new];
        [self.favoriteCities addObjectsFromArray:[self.cityManager loadFavoriteCities]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addButtonTapped)];
}

- (void) addButtonTapped{
    SearchCityViewController *searchCityVC = [SearchCityViewController new];
    searchCityVC.delegate = self;
    
    [self.navigationController presentViewController:searchCityVC animated:YES completion:nil];
}

-(void)searchCityViewController:(SearchCityViewController *)searchCityViewController didSelectCity:(City *)city{
    NSLog(@"City list: %@ received city: %@", searchCityViewController, city);
    [self.favoriteCities addObject:city];
    [self.cityListTableView reloadData];
    [self.cityManager saveFavoriteCities:self.favoriteCities];
    [searchCityViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.favoriteCities count];
}

#define kCellIdentifier @"kCellIdentifier"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    City *city = self.favoriteCities[indexPath.row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", city.cityName, city.countryCode];
    
    return cell;
}



@end

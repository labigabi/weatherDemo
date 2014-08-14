//
//  SearchCityViewController.m
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.12..
//  Copyright (c) 2014 test. All rights reserved.
//

#import "SearchCityViewController.h"
#import "CityManager.h"
#import "City.h"

@interface SearchCityViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (strong, nonatomic) CityManager *cityManager;
@property (strong, nonatomic) NSArray *results;
@end

@implementation SearchCityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.cityManager = [CityManager new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.searchTextField addTarget:self action:@selector(textFieldContentChanged) forControlEvents:UIControlEventAllEditingEvents];
    
    UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.backgroundView addGestureRecognizer:gr];
}

- (void) dismissKeyboard{
    [self.searchTextField resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.searchTextField becomeFirstResponder];
}

- (void) textFieldContentChanged{
    NSLog(@"%@", self.searchTextField.text);
    __weak SearchCityViewController *welf = self;
    [self.cityManager searchForCityWithString:[self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] completionHandler:^(NSArray *cities) {
        welf.results = cities;
        [welf.resultTableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.results count];
}

#define kCellIdentifier @"kCellIdentifier"
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }

    City *actCity = self.results[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%@)", actCity.cityName, actCity.countryCode];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    City *actCity = self.results[indexPath.row];
    NSLog(@"%@", actCity);
    
    [self.delegate searchCityViewController:self didSelectCity:actCity];
}


@end

//
//  WeatherDetailsViewController.m
//  WeatherDemo
//
//  Created by Peter Stojcsics on 2014.08.14..
//  Copyright (c) 2014 test. All rights reserved.
//

#import "WeatherDetailsViewController.h"
#import "NetworkEngine.h"

@interface WeatherDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;

@end

@implementation WeatherDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cityName.text = self.city.cityName;
    
    MKNetworkOperation *op = [[NetworkEngine engine] operationWithPath:@"weather" params:@{@"id" : self.city.cityID,
                                                                                           @"APPID" : @"ad926d787edfedd6f8a01755c1582c02"} httpMethod:@"GET"];
    __weak WeatherDetailsViewController *welf = self;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [completedOperation responseJSONWithCompletionHandler:^(id jsonObject) {
            NSDictionary *weather = [jsonObject[@"weather"] firstObject];
            NSDictionary *temperature = jsonObject[@"main"];
            NSString *imageUrl = [NSString stringWithFormat:@"http://openweathermap.org/img/w/%@.png", weather[@"icon"]];
            [welf fetchImageFromUrlString:imageUrl];
            NSLog(@"%@ %@", weather, temperature);
        }];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [[NetworkEngine engine] enqueueOperation:op];
}

- (void) fetchImageFromUrlString:(NSString*)urlString{
    MKNetworkOperation *op = [[NetworkEngine engine] operationWithURLString:urlString];
    __weak WeatherDetailsViewController *welf = self;
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        welf.weatherImageView.image = [completedOperation responseImage];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [[NetworkEngine engine] enqueueOperation:op];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

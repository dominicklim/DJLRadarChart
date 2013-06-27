//
//  DJLMainVC.m
//  DJLRadarChartDemo
//
//  Created by Dominick Lim on 6/20/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLMainVC.h"
#import "DJLMainView.h"
#import "DJLRadarChartController.h"
#import "DJLRadarChart.h"
#import "DJLRadarChartKey.h"
#import "DJLRadarChartTitleLabel.h"

@interface DJLMainVC ()<DJLRadarChartDataSource, DJLRadarChartDelegate, DJLRadarChartKeyDataSource>

@property (nonatomic, strong) DJLMainView *view;

@property (nonatomic, strong) DJLRadarChartController *radarChartController;
@property (nonatomic, strong) NSArray *starNames;
@property (nonatomic, strong) NSArray *starColors;
@property (nonatomic, strong) NSArray *spokeNames;
@property (nonatomic, strong) NSArray *spokeValues;

@end

@implementation DJLMainVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark -- View lifecycle

- (void)loadView
{
    self.view = [[DJLMainView alloc] initWithFrame:[UIScreen mainScreen].bounds];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.radarChartController reloadData];
    [self.view addRadarChart:self.radarChartController.radarChart];
    [self.view addRadarChartKey:self.radarChartController.radarChartKey];
    [self.view addRadarChartTitle:self.radarChartController.radarChartTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- Private properties

- (DJLRadarChartController *)radarChartController
{
    if (!_radarChartController) {
        _radarChartController = [[DJLRadarChartController alloc] init];
        _radarChartController.radarChart.dataSource = self;
        _radarChartController.radarChart.delegate = self;
        _radarChartController.radarChartKey.dataSource = self;
        _radarChartController.radarChartTitle.text = @"Alfa Bravo";
    }
    
    return _radarChartController;
}

- (NSArray *)starNames
{
    if (!_starNames) {
        _starNames = @[@"India", @"Juliett", @"Kilo"];
    }
    
    return _starNames;
}

- (NSArray *)starColors
{
    if (!_starColors) {
        _starColors = @[[UIColor redColor], [UIColor blueColor], [UIColor greenColor]];
    }
    
    return _starColors;
}

- (NSArray *)spokeNames
{
    if (!_spokeNames) {
        _spokeNames = @[@"Charlie", @"Delta", @"Echo", @"Foxtrot", @"Golf", @"Hotel"];
    }
    
    return _spokeNames;
}

- (NSArray *)spokeValues
{
    if (!_spokeValues) {
        _spokeValues = @[@[@(0.0), @(1.0), @(0.7), @(0.8), @(1.0), @(0.5)],
                         @[@(0.5), @(0.0), @(0.3), @(1.0), @(0.0), @(0.3)],
                         @[@(0.8), @(9.0), @(0.7), @(0.8), @(0.5), @(1.0)]];
    }
    
    return _spokeValues;
}

#pragma mark -- Radar chart data source

- (NSString *)radarChart:(DJLRadarChart *)radarChart nameOfSpokeAtIndex:(NSInteger)index
{
    return self.spokeNames[index];
}

- (NSString *)radarChart:(DJLRadarChart *)radarChart nameOfStarAtIndex:(NSInteger)index
{
    return self.starNames[index];
}

- (NSInteger)numberOfSpokesInRadarChart:(DJLRadarChart *)radarChart
{
    return [self.spokeValues[0] count];
}

- (NSInteger)numberOfStarsInRadarChart:(DJLRadarChart *)radarChart
{
    return self.starColors.count;
}

#pragma mark -- Optional

- (CGFloat)radarChart:(DJLRadarChart *)radarChart valueOfSpokeAtIndex:(NSInteger)spokeIndex forStarAtIndex:(NSInteger)starIndex
{
    return [self.spokeValues[starIndex][spokeIndex] floatValue];
}

- (UIColor *)radarChart:(DJLRadarChart *)radarChart colorOfStarAtIndex:(NSInteger)index
{
    return self.starColors[index];
}

#pragma mark -- Radar chart delegate

#pragma mark -- Optional

- (void)radarChart:(DJLRadarChart *)radarChart
         valueOfSpokeAtIndex:(NSInteger)spokeIndex
              forStarAtIndex:(NSInteger)starIndex
                   didChange:(CGFloat)value
{
    
}

#pragma mark -- Radar chart key data source

- (NSInteger)numberOfStarsForRadarChartKey:(DJLRadarChartKey *)key
{
    return self.starColors.count;
}

- (NSString *)radarChartKey:(DJLRadarChartKey *)key nameOfStarAtIndex:(NSInteger)index
{
    return self.starNames[index];
}

- (UIColor *)radarChartKey:(DJLRadarChartKey *)key colorOfStarAtIndex:(NSInteger)index
{
    return self.starColors[index];
}

@end

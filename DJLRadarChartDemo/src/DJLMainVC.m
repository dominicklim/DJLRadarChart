//
//  DJLMainVC.m
//  DJLRadarChartDemo
//
//  Created by Dominick Lim on 6/20/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLMainVC.h"
#import "DJLMainView.h"
#import "DJLRadarChart.h"

@interface DJLMainVC ()<DJLRadarChartDataSource, DJLRadarChartDelegate>

@property (nonatomic, strong) DJLMainView *view;
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
    self.view.radarChart.delegate = self;
    self.view.radarChart.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- Private properties

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
        _spokeNames = @[@"A", @"B", @"C", @"D", @"E", @"F"];
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

#pragma mark -- Radar chart delegate

- (void)radarChart:(DJLRadarChart *)radarChart valueOfSpokeAtIndex:(NSInteger)spokeIndex
    forStarAtIndex:(NSInteger)starIndex didChange:(CGFloat)value
{
    
}

#pragma mark -- Radar chart data source

- (NSString *)radarChart:(DJLRadarChart *)radarChart nameOfSpokeAtIndex:(NSInteger)index
{
    return self.spokeNames[index];
}

- (NSString *)radarChart:(DJLRadarChart *)radarChart nameOfStarAtIndex:(NSInteger)index
{
    return @"Star";
}

- (NSInteger)numberOfStarsInRadarChart:(DJLRadarChart *)radarChart
{
    return self.spokeValues.count;
}

- (NSInteger)numberOfSpokesInRadarChart:(DJLRadarChart *)radarChart
{
    return self.spokeNames.count;
}

- (CGFloat)radarChart:(DJLRadarChart *)radarChart valueOfSpokeAtIndex:(NSInteger)spokeIndex forStarAtIndex:(NSInteger)starIndex
{
    return [self.spokeValues[starIndex][spokeIndex] floatValue];
}

- (UIColor *)radarChart:(DJLRadarChart *)radarChart fillColorOfStarAtIndex:(NSInteger)index
{
    return self.starColors[index];
}

- (UIColor *)radarChart:(DJLRadarChart *)radarChart strokeColorOfStarAtIndex:(NSInteger)index
{
    return self.starColors[index];
}

@end

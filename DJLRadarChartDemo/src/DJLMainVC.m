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

static const CGFloat kMaxValue = 5.0;
static const CGFloat kMinValue = 0.0;
static const int kNumberOfStars = 4;
static const int kNumberOfSpokes = 6;

@interface DJLMainVC ()<DJLRadarChartDataSource, DJLRadarChartDelegate, DJLRadarChartKeyDataSource>

@property (nonatomic, strong) DJLMainView *view;

@property (nonatomic, strong) DJLRadarChartController *radarChartController;
@property (nonatomic, strong) NSArray *starNames;
@property (nonatomic, strong) NSArray *starColors;
@property (nonatomic, strong) NSArray *spokeNames;
@property (nonatomic, strong) NSArray *spokeValues;

@end

@implementation DJLMainVC

#pragma mark -- Object lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
        _starNames = @[@"India", @"Juliett", @"Kilo", @"Lima"];
    }
    
    return _starNames;
}

- (NSArray *)starColors
{
    if (!_starColors) {
        NSMutableArray *starColors = [NSMutableArray arrayWithCapacity:kNumberOfStars];
        
        for (int i = 0; i < kNumberOfStars; i++) {
            [starColors addObject:[self randomColor]];
        }
        
        _starColors = starColors;
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
        NSMutableArray *spokeValues = [NSMutableArray arrayWithCapacity:kNumberOfStars];
        for (int i = 0; i < kNumberOfStars; i++) {
            NSMutableArray *star = [NSMutableArray arrayWithCapacity:kNumberOfSpokes];
            for (int j = 0; j < kNumberOfSpokes; j++) {
                CGFloat randomValue = (CGFloat)random() / RAND_MAX * (kMaxValue - kMinValue) + kMinValue;
                [star addObject:@(randomValue)];
            }
            [spokeValues addObject:star];
        }
        _spokeValues = spokeValues;
    }
    
    return _spokeValues;
}

#pragma mark -- Private helpers

- (UIColor *)randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black

    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
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
    return kNumberOfSpokes;
}

- (NSInteger)numberOfStarsInRadarChart:(DJLRadarChart *)radarChart
{
    return kNumberOfStars;
}

- (CGFloat)maxValueOfRadarChart:(DJLRadarChart *)radarChart
{
    return kMaxValue;
}

- (CGFloat)minValueOfRadarChart:(DJLRadarChart *)radarChart
{
    return kMinValue;
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

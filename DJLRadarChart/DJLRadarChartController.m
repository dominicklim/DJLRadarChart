//
//  DJLRadarChartController.m
//  DJLRadarChart
//
//  Created by Dominick Lim on 6/21/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLRadarChartController.h"
#import "DJLRadarChart.h"
#import "DJLRadarChartKey.h"
#import "DJLRadarChartTitleLabel.h"

@interface DJLRadarChartController ()

@property (nonatomic, strong, readwrite) DJLRadarChart *radarChart;
@property (nonatomic, strong, readwrite) DJLRadarChartKey *radarChartKey;
@property (nonatomic, strong, readwrite) DJLRadarChartTitleLabel *radarChartTitle;

@end

@implementation DJLRadarChartController

- (id)init
{
    self = [super init];
    if (self) {
    }

    return self;
}

#pragma mark -- Public properties

- (DJLRadarChart *)radarChart
{
    if (!_radarChart) {
        _radarChart = [[DJLRadarChart alloc] init];
    }
    
    return _radarChart;
}

- (DJLRadarChartKey *)radarChartKey
{
    if (!_radarChartKey) {
        _radarChartKey = [[DJLRadarChartKey alloc] init];
    }
    
    return _radarChartKey;
}

- (DJLRadarChartTitleLabel *)radarChartTitle
{
    if (!_radarChartTitle) {
        _radarChartTitle = [[DJLRadarChartTitleLabel alloc] init];
    }

    return _radarChartTitle;
}

- (void)reloadData
{
    [self.radarChart reloadData];
    [self.radarChartKey reloadData];
}

@end

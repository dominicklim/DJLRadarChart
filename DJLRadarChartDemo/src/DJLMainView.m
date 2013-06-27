//
//  DJLMainView.m
//  DJLRadarChartDemo
//
//  Created by Dominick Lim on 6/20/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLMainView.h"
#import "DJLRadarChart.h"
#import "DJLRadarChartKey.h"
#import "DJLRadarChartTitleLabel.h"

@interface DJLMainView ()

@property (nonatomic, strong) DJLRadarChart *radarChart;
@property (nonatomic, strong) DJLRadarChartKey *radarChartKey;
@property (nonatomic, strong) DJLRadarChartTitleLabel *radarChartTitle;

@end

@implementation DJLMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.radarChartTitle.frame = CGRectMake(0, 0, self.frame.size.width, 50);
    self.radarChart.frame = CGRectMake(0, CGRectGetMaxY(self.radarChartTitle.frame), self.frame.size.width, self.frame.size.width);
    self.radarChartKey.frame = CGRectMake(0, CGRectGetMaxY(self.radarChart.frame), self.frame.size.width, self.bounds.size.height - CGRectGetMaxY(self.radarChart.frame));
}

#pragma mark -- Public methods

- (void)addRadarChart:(DJLRadarChart *)radarChart
{
    self.radarChart = radarChart;
    [self addSubview:radarChart];
}

- (void)addRadarChartKey:(DJLRadarChartKey *)radarChartKey
{
    self.radarChartKey = radarChartKey;
    [self addSubview:radarChartKey];
}

- (void)addRadarChartTitle:(DJLRadarChartTitleLabel *)radarChartTitle
{
    self.radarChartTitle = radarChartTitle;
    [self addSubview:radarChartTitle];
}

@end

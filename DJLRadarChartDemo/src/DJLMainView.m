//
//  DJLMainView.m
//  DJLRadarChartDemo
//
//  Created by Dominick Lim on 6/20/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLMainView.h"
#import "DJLRadarChart.h"

@interface DJLMainView ()

@property (nonatomic, strong) DJLRadarChart *radarChart;

@end

@implementation DJLMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.radarChart];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.radarChart.frame = self.frame;
}

#pragma mark -- Private Properties

- (DJLRadarChart *)radarChart
{
    if (!_radarChart) {
        _radarChart = [[DJLRadarChart alloc] init];
    }
    
    return _radarChart;
}

@end

//
//  DJLRadarChartController.h
//  DJLRadarChart
//
//  Created by Dominick Lim on 6/21/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DJLRadarChart, DJLRadarChartKey, DJLRadarChartTitleLabel;

@interface DJLRadarChartController : NSObject

@property (nonatomic, strong, readonly) DJLRadarChart *radarChart;
@property (nonatomic, strong, readonly) DJLRadarChartKey *radarChartKey;
@property (nonatomic, strong, readonly) DJLRadarChartTitleLabel *radarChartTitle;

- (void)reloadData;

@end

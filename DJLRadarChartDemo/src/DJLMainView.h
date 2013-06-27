//
//  DJLMainView.h
//  DJLRadarChartDemo
//
//  Created by Dominick Lim on 6/20/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DJLRadarChart, DJLRadarChartKey, DJLRadarChartTitleLabel;

@interface DJLMainView : UIView

- (void)addRadarChart:(DJLRadarChart *)radarChart;
- (void)addRadarChartKey:(DJLRadarChartKey *)radarChartKey;
- (void)addRadarChartTitle:(DJLRadarChartTitleLabel *)radarChartTitle;

@end

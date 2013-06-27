//
//  DJLRadarChart.h
//  DJLRadarChart
//
//  Created by Dominick Lim on 5/4/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray DJLRadarChartStar;

@protocol DJLRadarChartDataSource;
@protocol DJLRadarChartDelegate;

@interface DJLRadarChart : UIView

@property (nonatomic, weak) id <DJLRadarChartDataSource> dataSource;
@property (nonatomic, weak) id <DJLRadarChartDelegate> delegate;

- (void)reloadData;

@end

@protocol DJLRadarChartDataSource <NSObject>

@required
- (NSString *)radarChart:(DJLRadarChart *)radarChart nameOfSpokeAtIndex:(NSInteger)index;
- (NSString *)radarChart:(DJLRadarChart *)radarChart nameOfStarAtIndex:(NSInteger)index;

- (NSInteger)numberOfSpokesInRadarChart:(DJLRadarChart *)radarChart;
- (NSInteger)numberOfStarsInRadarChart:(DJLRadarChart *)radarChart;

@optional
- (CGFloat)radarChart:(DJLRadarChart *)radarChart
  valueOfSpokeAtIndex:(NSInteger)spokeIndex
       forStarAtIndex:(NSInteger)starIndex;
- (UIColor *)radarChart:(DJLRadarChart *)radarChart colorOfStarAtIndex:(NSInteger)index;

@end

@protocol DJLRadarChartDelegate <NSObject>


@optional
- (void)radarChart:(DJLRadarChart *)radarChart valueOfSpokeAtIndex:(NSInteger)spokeIndex
    forStarAtIndex:(NSInteger)starIndex didChange:(CGFloat)value;

@end

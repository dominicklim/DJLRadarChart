//
//  DJLRadarChart.h
//  Danger Zone
//
//  Created by Dominick Lim on 5/4/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSArray DJLRadarChartStar;

@protocol DJLRadarChartDataSource;
@protocol DJLRadarChartDelegate;

@interface DJLRadarChart : UIView

@property (nonatomic, assign) id <DJLRadarChartDataSource> dataSource;
@property (nonatomic, assign) id <DJLRadarChartDelegate> delegate;

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
- (UIColor *)radarChart:(DJLRadarChart *)radarChart fillColorOfStarAtIndex:(NSInteger)index;
- (UIColor *)radarChart:(DJLRadarChart *)radarChart strokeColorOfStarAtIndex:(NSInteger)index;

@end

@protocol DJLRadarChartDelegate <NSObject>


@optional
- (void)radarChart:(DJLRadarChart *)radarChart valueOfSpokeAtIndex:(NSInteger)spokeIndex
    forStarAtIndex:(NSInteger)starIndex didChange:(CGFloat)value;

@end

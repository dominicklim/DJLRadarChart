//
//  DJLRadarChartKey.h
//  DJLRadarChart
//
//  Created by Dominick Lim on 6/21/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJLRadarChartKeyDataSource;

@interface DJLRadarChartKey : UIView

@property (nonatomic, weak) id <DJLRadarChartKeyDataSource> dataSource;

- (void)reloadData;

@end

@protocol DJLRadarChartKeyDataSource <NSObject>

- (NSInteger)numberOfStarsForRadarChartKey:(DJLRadarChartKey *)key;

- (NSString *)radarChartKey:(DJLRadarChartKey *)key nameOfStarAtIndex:(NSInteger)index;
- (UIColor *)radarChartKey:(DJLRadarChartKey *)key colorOfStarAtIndex:(NSInteger)index;

@end

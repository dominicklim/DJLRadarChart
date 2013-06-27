//
//  DJLRadarChartSpoke.h
//  DJLRadarChart
//
//  Created by Dominick Lim on 5/4/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DJLRadarChartSpokeDelegate;

@interface DJLRadarChartSpoke : UISlider

@property (nonatomic, weak) id<DJLRadarChartSpokeDelegate> delegate;

@property (nonatomic, readonly) CGFloat totalWidth;
@property (nonatomic, readonly) CGFloat unrotatedWidth;

- (id)initWithFrame:(CGRect)frame value:(float)value;
- (id)initWithValue:(float)value;

//- (CGFloat)rotationAngle;
- (CGFloat)cosAngle;
- (CGFloat)sinAngle;

- (CGFloat)currentThumbWidth;

- (CGPoint)pointOfValue;
- (CGPoint)minPoint;
- (CGPoint)maxPoint;
- (CGPoint)pointOfValue:(CGFloat)value;

@end


@protocol DJLRadarChartSpokeDelegate <NSObject>

- (void)spoke:(DJLRadarChartSpoke *)spoke valueDidChange:(float)value;

@end

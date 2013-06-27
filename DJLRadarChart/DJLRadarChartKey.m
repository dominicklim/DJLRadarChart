//
//  DJLRadarChartKey.m
//  DJLRadarChart
//
//  Created by Dominick Lim on 6/21/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLRadarChartKey.h"
#import "DJLRadarChartTitleLabel.h"

@interface DJLRadarChartKey ()

@property (nonatomic, strong) NSArray *starColors;
@property (nonatomic, strong) NSArray *starLabels;

- (void)addStarColors;
- (void)addStarLabels;

- (void)layoutStarColors;
- (void)layoutStarLabels;

- (void)removeStarColors;
- (void)removeStarLabels;

- (CGFloat)mappingSeperator;
- (CGFloat)mappingHeight;
- (CGRect)frameOfStarColorAtIndex:(NSInteger)index;

// Data source method wrappers
- (NSInteger)numberOfStars;
- (UIColor *)colorOfStarAtIndex:(NSInteger)index;
- (NSString *)nameOfStarAtIndex:(NSInteger)index;

@end

@implementation DJLRadarChartKey

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addStarColors];
        [self addStarLabels];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self layoutStarColors];
    [self layoutStarLabels];
}


#pragma mark -- Private properties

- (NSArray *)starColors
{
    if (!_starColors) {
        NSMutableArray *starColors = [NSMutableArray arrayWithCapacity:self.numberOfStars];
        
        for (int i = 0; i < self.numberOfStars; i++) {
            [starColors addObject:[[UIView alloc] init]];
        }

        _starColors = starColors;
        starColors = nil;
    }
    
    return _starColors;
}

- (NSArray *)starLabels
{
    if (!_starLabels) {
        NSMutableArray *starLabels = [NSMutableArray arrayWithCapacity:self.numberOfStars];

        for (int i = 0; i < self.numberOfStars; i++) {
            DJLRadarChartTitleLabel *starLabel = [[DJLRadarChartTitleLabel alloc] init];
            starLabel.textAlignment = NSTextAlignmentLeft;
            [starLabels addObject:starLabel];
        }

        _starLabels = starLabels;
        starLabels = nil;
    }
    
    return _starLabels;
}


#pragma mark -- Public methods

- (void)reloadData
{
    [self removeStarColors];
    [self removeStarLabels];

    [self addStarColors];
    [self addStarLabels];
}


#pragma mark -- Private methods

- (void)addStarColors
{
    for (int i = 0; i < self.starColors.count; i++) {
        UIView *starColor = self.starColors[i];
        starColor.backgroundColor = [self colorOfStarAtIndex:i];
        [self addSubview:starColor];
    }
}

- (void)addStarLabels
{
    for (int i = 0; i < self.starLabels.count; i++) {
        DJLRadarChartTitleLabel *starLabel = self.starLabels[i];
        starLabel.text = [self nameOfStarAtIndex:i];
        [self addSubview:starLabel];
    }
}

- (void)layoutStarColors
{
    for (int i = 0; i < self.starColors.count; i++) {
        UIView *starColor = self.starColors[i];
        starColor.frame = [self frameOfStarColorAtIndex:i];
    }
}

- (void)layoutStarLabels
{
    for (int i = 0; i < self.starLabels.count; i++) {
        DJLRadarChartTitleLabel *starLabel = self.starLabels[i];
        starLabel.frame = [self frameOfStarLabelAtIndex:i];
    }
}

- (void)removeStarColors
{
    for (UIView *starColor in self.starColors) {
        [starColor removeFromSuperview];
    }

    self.starColors = nil;
}

- (void)removeStarLabels
{
    for (DJLRadarChartTitleLabel *starLabel in self.starLabels) {
        [starLabel removeFromSuperview];
    }

    self.starLabels = nil;
}

- (CGFloat)mappingSeperator
{
    if ([self numberOfStars] == 0) return 0;

    return (self.frame.size.height / [self numberOfStars]) / 3.f;
}

- (CGFloat)mappingHeight
{
    if ([self numberOfStars] == 0) return 0;
    
    return ((self.frame.size.height - self.mappingSeperator) / [self numberOfStars]) - self.mappingSeperator;
}

- (CGRect)frameOfStarColorAtIndex:(NSInteger)index
{
    return (CGRect){
        self.mappingSeperator,
        self.mappingSeperator + (self.mappingHeight + self.mappingSeperator) * index,
        self.mappingHeight * 2, self.mappingHeight
    };
}

- (CGRect)frameOfStarLabelAtIndex:(NSInteger)index
{
    CGRect starColorFrame = [self frameOfStarColorAtIndex:index];
    CGRect starLabelFrame = starColorFrame;
    starLabelFrame.origin = (CGPoint){
        starColorFrame.size.width + self.mappingSeperator * 2,
        starColorFrame.origin.y
    };
    starLabelFrame.size = (CGSize){
        self.frame.size.width - CGRectGetMaxX(starColorFrame) - self.mappingSeperator * 2,
        starColorFrame.size.height
    };
    
    return starLabelFrame;
}


#pragma mark -- Data source method wrappers

- (NSInteger)numberOfStars
{
    if ([self.dataSource respondsToSelector:@selector(numberOfStarsForRadarChartKey:)]) {
        return [self.dataSource numberOfStarsForRadarChartKey:self];
    }
    
    return 0;
}

- (UIColor *)colorOfStarAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(radarChartKey:colorOfStarAtIndex:)]) {
        return [self.dataSource radarChartKey:self colorOfStarAtIndex:index];
    }
    
    return [UIColor clearColor];
}

- (NSString *)nameOfStarAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(radarChartKey:nameOfStarAtIndex:)]) {
        return [self.dataSource radarChartKey:self nameOfStarAtIndex:index];
    }
    
    return @"";
}

@end

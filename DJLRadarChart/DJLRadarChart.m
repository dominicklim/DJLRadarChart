//
//  DJLRadarChart.m
//  DJLRadarChart
//
//  Created by Dominick Lim on 5/4/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLRadarChart.h"
#import "DJLRadarChartSpoke.h"
#import "DJLRadarChartTitleLabel.h"

#define DEG2RAD(degrees) ((degrees) / 180.0f * M_PI)

static const int kNumberOfTicks = 6;

@interface DJLRadarChart ()<DJLRadarChartSpokeDelegate>

@property (nonatomic, strong) NSArray *stars;
@property (nonatomic, strong) NSArray *variableLabels;
@property (nonatomic, strong) NSArray *tickLabels;

- (void)addSpokes;
- (void)addVariableLabels;
- (void)addTickLabels;

- (void)layoutSpokes;
- (void)layoutVariableLabels;
- (void)layoutTickLabels;

- (void)removeSpokes;
- (void)removeVariableLabels;
- (void)removeTickLabels;

- (CGFloat)minSpoke;
- (CGFloat)maxSpoke;
- (CGFloat)variableLabelWidth;

- (CGRect)squareFrameFromFrame:(CGRect)frame;

- (void)forEachSpokeExecuteBlock:(void (^) (DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex))block;
- (void)forEachAxisAtAngleExecuteBlock:(void (^)(CGFloat angle, NSInteger index))block;

// Data source method wrappers
- (NSString *)nameOfSpokeAtIndex:(NSInteger)index;
- (NSString *)nameOfStarAtIndex:(NSInteger)index;

- (NSInteger)numberOfSpokes;
- (NSInteger)numberOfStars;
- (CGFloat)maxValue;
- (CGFloat)minValue;

- (CGFloat)percentValueOfSpokeAtIndex:(NSInteger)spokeIndex
                       forStarAtIndex:(NSInteger)starIndex;
- (CGFloat)valueOfSpokeAtIndex:(NSInteger)spokeIndex
                forStarAtIndex:(NSInteger)starIndex;
- (UIColor *)colorOfStarAtIndex:(NSInteger)index;

@end

@implementation DJLRadarChart

#pragma mark -- Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:[self squareFrameFromFrame:frame]]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}


#pragma mark -- Drawing methods

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self layoutSpokes];
    [self layoutVariableLabels];
}

- (void)drawRect:(CGRect)rect
{
    if (self.stars.count < 1 || self.dataSource == nil) return;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawTicksWithContext:ctx];
    [self drawAxesWithContext:ctx];
    [self drawStarsWithContext:ctx];
    [self drawCirclesAtVerticesWithContext:ctx];
}

- (void)drawTicksWithContext:(CGContextRef)ctx
{
    CGFloat increment = (self.maxSpoke - self.minSpoke) / (kNumberOfTicks - 1);

    for (int i = 0; i < kNumberOfTicks; i++) {
        CGFloat distance = (i * increment) + self.minSpoke;
        [self drawTickAtDistance:distance context:ctx];
        DJLRadarChartTitleLabel *tickLabel = self.tickLabels[i];
        [tickLabel setFrame:(CGRect){CGRectGetMidX(self.bounds) + increment / 10, 0, increment / 1.5, self.variableLabelWidth}];
        [tickLabel setCenter:(CGPoint){tickLabel.center.x, CGRectGetMidY(self.bounds) - (self.minSpoke + distance)}];
    }
}

- (void)drawTickAtDistance:(CGFloat)distance context:(CGContextRef)ctx
{
    if (self.numberOfSpokes == 0) return;

    CGContextSetLineWidth(ctx, 1.0);

    CGContextBeginPath(ctx);
    CGMutablePathRef path = CGPathCreateMutable();

    [self forEachAxisAtAngleExecuteBlock:^(CGFloat angle, NSInteger index) {
        CGPoint point = {
            CGRectGetMidX(self.bounds) + distance * sinf(angle),
            CGRectGetMidY(self.bounds) + distance * cosf(angle)
        };

        if (index == 0) {
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        } else {
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
        }
    }];
    
    CGContextAddPath(ctx, path);
    CGContextSaveGState (ctx);

    CGContextClosePath(ctx);
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1);
    CGContextStrokePath(ctx);

    CGPathRelease(path);
}

- (void)drawAxesWithContext:(CGContextRef)ctx
{
    [self forEachAxisAtAngleExecuteBlock:^(CGFloat angle, NSInteger index) {
        [self drawAxisAtAngle:angle context:ctx];
    }];
}

- (void)drawAxisAtAngle:(CGFloat)angle context:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextBeginPath(ctx);
    CGMutablePathRef path = CGPathCreateMutable();

    CGPoint startingPoint = {
        CGRectGetMidX(self.bounds) + self.minSpoke * sinf(angle),
        CGRectGetMidY(self.bounds) + self.minSpoke * cosf(angle)
    };
    
    CGPoint endPoint = {
        CGRectGetMidX(self.bounds) + self.maxSpoke * sinf(angle),
        CGRectGetMidY(self.bounds) + self.maxSpoke * cosf(angle)
    };

    CGPathMoveToPoint(path, NULL, startingPoint.x, startingPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);

    CGContextAddPath(ctx, path);
    CGContextSaveGState (ctx);
    
    CGContextClosePath(ctx);
    CGContextSetRGBStrokeColor(ctx, 0.5, 0.5, 0.5, 1);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}

- (void)drawStarsWithContext:(CGContextRef)ctx
{
    for (int i = 0; i < self.stars.count; i++) {
        [self drawStarAtIndex:i withContext:ctx];
    }
}

- (void)drawStarAtIndex:(NSInteger)index withContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 2.0);
    CGContextBeginPath(ctx);
    
    CGMutablePathRef path = CGPathCreateMutable();

    for (int i = 0; i < [self.stars[index] count]; i++) {
        CGPoint spokePoint = [self.stars[index][i] pointOfValue];
        
        if (i == 0) {
            CGPathMoveToPoint(path, NULL, spokePoint.x, spokePoint.y);
        } else {
            CGPathAddLineToPoint(path, NULL, spokePoint.x, spokePoint.y);
        }
    }

    CGContextAddPath(ctx, path);
    CGContextSaveGState(ctx);
    CGContextClosePath(ctx);
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0;
    [[self colorOfStarAtIndex:index] getRed:&red green:&green blue:&blue alpha:nil];
    CGContextSetRGBFillColor(ctx, red, green, blue, 1.0 / [self numberOfStars]);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
    CGContextAddPath(ctx, path);
    CGContextSaveGState (ctx);

    CGContextClosePath(ctx);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0);
    CGContextStrokePath(ctx);

    CGPathRelease(path);
}

- (void)drawCirclesAtVerticesWithContext:(CGContextRef)ctx
{
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        NSInteger circleRadius = spoke.unrotatedWidth / 50;

        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        [[self colorOfStarAtIndex:starIndex] getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBFillColor(ctx, red, green, blue, alpha);

        CGPoint spokePoint = [spoke pointOfValue];
        CGContextFillEllipseInRect(ctx, (CGRect) {spokePoint.x - circleRadius, spokePoint.y - circleRadius, circleRadius * 2, circleRadius * 2});
    }];
}


#pragma mark -- Public properties

- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled
{
    [super setUserInteractionEnabled:userInteractionEnabled];
    
    for (DJLRadarChartSpoke *spoke in self.stars) {
        spoke.userInteractionEnabled = userInteractionEnabled;
    }
}

- (void)setDataSource:(id<DJLRadarChartDataSource>)dataSource
{
    _dataSource = dataSource;

    [self reloadData];
}

- (void)setDelegate:(id<DJLRadarChartDelegate>)delegate
{
    _delegate = delegate;
}


#pragma mark -- Private properties

- (NSArray *)stars
{
    if (!_stars) {
        NSInteger numberOfSpokes = [self numberOfSpokes];
        NSInteger numberOfStars = [self numberOfStars];
        
        NSMutableArray *stars = [NSMutableArray arrayWithCapacity:numberOfStars];
        
        for (int i = 0; i < numberOfStars; i++) {
            NSMutableArray *spokes = [NSMutableArray arrayWithCapacity:numberOfSpokes];
            
            for (int j = 0; j < numberOfSpokes; j++) {
                DJLRadarChartSpoke *spoke = [[DJLRadarChartSpoke alloc] initWithValue:[self percentValueOfSpokeAtIndex:j forStarAtIndex:i]];
                spoke.delegate = self;
                
                [spokes addObject:spoke];
            }
            
            [stars addObject:spokes];
            spokes = nil;
        }
        
        _stars = stars;
        stars = nil;
    }
    
    return _stars;
}

- (NSArray *)variableLabels
{
    if (!_variableLabels) {
        NSMutableArray *variableLabels = [NSMutableArray arrayWithCapacity:[self numberOfSpokes]];
        
        for (int i = 0; i < [self numberOfSpokes]; i++) {
            DJLRadarChartTitleLabel *variableLabel = [[DJLRadarChartTitleLabel alloc] init];
            variableLabel.text = [self nameOfSpokeAtIndex:i];
            [variableLabels addObject:variableLabel];
        }
        
        _variableLabels = variableLabels;
        variableLabels = nil;
    }
    
    return _variableLabels;
}

- (NSArray *)tickLabels
{
    if (!_tickLabels) {
        NSMutableArray *tickLabels = [NSMutableArray arrayWithCapacity:kNumberOfTicks];
        
        for (int i = 0; i < kNumberOfTicks; i++) {
            DJLRadarChartTitleLabel *tickLabel = [[DJLRadarChartTitleLabel alloc] init];
            tickLabel.font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
            CGFloat increment = (self.maxValue - self.minValue) / (kNumberOfTicks - 1);
            tickLabel.text = [NSString stringWithFormat:@"%.1f", (increment * i) + self.minValue];
            [tickLabels addObject:tickLabel];
        }

        _tickLabels = tickLabels;
        tickLabels = nil;
    }
    
    return _tickLabels;
}

- (CGFloat)minSpoke
{
    return 0;
}

- (CGFloat)maxSpoke
{
    return self.frame.size.width / 2 - (self.variableLabelWidth);
}

- (CGFloat)variableLabelWidth
{
    return self.frame.size.width / 5.f;
}

- (CGRect)squareFrameFromFrame:(CGRect)frame
{
    CGFloat length = (frame.size.width > frame.size.height) ? frame.size.height : frame.size.width;
    frame.size = (CGSize){length, length};

    return frame;
}


#pragma mark -- Public methods

- (void)setFrame:(CGRect)frame
{
    [super setFrame:[self squareFrameFromFrame:frame]];
}

- (void)reloadData
{
    [self removeSpokes];
    [self removeVariableLabels];
    [self removeTickLabels];
    
    [self addSpokes];
    [self addVariableLabels];
    [self addTickLabels];
}


#pragma mark -- Private methods

- (void)addSpokes
{
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        [self addSubview:spoke];
    }];
}

- (void)addVariableLabels
{
    for (DJLRadarChartTitleLabel *label in self.variableLabels) {
        [self addSubview:label];
    }
}

- (void)addTickLabels
{
    for (DJLRadarChartTitleLabel *label in self.tickLabels) {
        [self addSubview:label];
    }
}

- (void)layoutSpokes
{
    if ([self numberOfSpokes] == 0) return;
    
    CGFloat centerDistanceFromCenter = (self.minSpoke + self.maxSpoke) / 2;
    CGFloat angleBetweenVertices = 360.0 / [self numberOfSpokes];
    CGFloat width = (self.maxSpoke - self.minSpoke);
    
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        
        // Rotate the spoke if it hasn't been rotated yet
        if (spoke.cosAngle == 1 && spoke.sinAngle == 0) {
            spoke.frame = (CGRect){spoke.frame.origin, width, spoke.frame.size.height};
            spoke.transform = CGAffineTransformRotate(spoke.transform, DEG2RAD((angleBetweenVertices * spokeIndex) - 90));
        }

        spoke.center = (CGPoint){
            CGRectGetMidX(self.bounds) + centerDistanceFromCenter * spoke.cosAngle,
            CGRectGetMidY(self.bounds) + centerDistanceFromCenter * spoke.sinAngle
        };
    }];
}

- (void)layoutVariableLabels
{
    // All variable labels should have the same font size, so we set all the
    // font size of all variable labels to the smallest font size.
    __block CGFloat smallestFontSize = -1;
    
    [self forEachAxisAtAngleExecuteBlock:^(CGFloat angle, NSInteger index) {
        DJLRadarChartTitleLabel *variableLabel = self.variableLabels[index];
        variableLabel.frame = (CGRect){0, 0, self.variableLabelWidth, self.variableLabelWidth};
        
        if (smallestFontSize == -1 || variableLabel.font.pointSize < smallestFontSize) {
            smallestFontSize = variableLabel.font.pointSize;
        }
        
        CGPoint center = {
            CGRectGetMidX(self.bounds) + (self.variableLabelWidth / 2 + self.maxSpoke) * sinf(angle),
            CGRectGetMidY(self.bounds) + (self.variableLabelWidth / 2 + self.maxSpoke) * -cosf(-angle)
        };
        
        [variableLabel setCenter:center];
    }];

    [self forEachAxisAtAngleExecuteBlock:^(CGFloat angle, NSInteger index) {
        DJLRadarChartTitleLabel *variableLabel = self.variableLabels[index];
        [variableLabel setFont:[UIFont fontWithName:variableLabel.font.fontName size:smallestFontSize]];
    }];
}

- (void)layoutTickLabels
{
    
}

- (void)removeSpokes
{
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        [spoke removeFromSuperview];
    }];
    
    self.stars = nil;
}

- (void)removeVariableLabels
{
    for (DJLRadarChartTitleLabel *label in self.variableLabels) {
        [label removeFromSuperview];
    }
    
    self.variableLabels = nil;
}

- (void)removeTickLabels
{
    for (DJLRadarChartTitleLabel *label in self.tickLabels) {
        [label removeFromSuperview];
    }
    
    self.tickLabels = nil;
}

- (void)forEachSpokeExecuteBlock:(void (^)(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex))block
{
    for (int i = 0; i < self.stars.count; i++) {
        for (int j = 0; j < [self.stars[i] count]; j++) {
            block(self.stars[i][j], i, j);
        }
    }
}

- (void)forEachAxisAtAngleExecuteBlock:(void (^)(CGFloat angle, NSInteger index))block
{
    if ([self numberOfSpokes] == 0) {
        return;
    }
    
    CGFloat angleBetweenVertices = 360.0 / [self numberOfSpokes];
    
    for (int i = 0; i < [self numberOfSpokes]; i++) {
        block(DEG2RAD(angleBetweenVertices * i), i);
    }
}


#pragma mark -- Data source method wrappers

- (NSString *)nameOfSpokeAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(radarChart:nameOfSpokeAtIndex:)]) {
        return [self.dataSource radarChart:self nameOfSpokeAtIndex:index];
    }

    return @"";
}
- (NSString *)nameOfStarAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(radarChart:nameOfStarAtIndex:)]) {
        return [self.dataSource radarChart:self nameOfStarAtIndex:index];
    }
    
    return @"";
}

- (NSInteger)numberOfSpokes
{
    if ([self.dataSource respondsToSelector:@selector(numberOfSpokesInRadarChart:)]) {
        return [self.dataSource numberOfSpokesInRadarChart:self];
    }

    return 0;
}

- (NSInteger)numberOfStars
{
    if ([self.dataSource respondsToSelector:@selector(numberOfStarsInRadarChart:)]) {
        return [self.dataSource numberOfStarsInRadarChart:self];
    }

    return 0;
}

- (CGFloat)percentValueOfSpokeAtIndex:(NSInteger)spokeIndex
                       forStarAtIndex:(NSInteger)starIndex
{
    return [self valueOfSpokeAtIndex:spokeIndex forStarAtIndex:starIndex] / (self.maxValue - self.minValue);
}

- (CGFloat)valueOfSpokeAtIndex:(NSInteger)spokeIndex
                forStarAtIndex:(NSInteger)starIndex
{
    if ([self.dataSource respondsToSelector:@selector(radarChart:valueOfSpokeAtIndex:forStarAtIndex:)]) {
        return [self.dataSource radarChart:self valueOfSpokeAtIndex:spokeIndex forStarAtIndex:starIndex];
    }

    return 1.0;
}

- (UIColor *)colorOfStarAtIndex:(NSInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(radarChart:colorOfStarAtIndex:)]) {
        return [self.dataSource radarChart:self colorOfStarAtIndex:index];
    }

    return [UIColor grayColor];
}

- (CGFloat)maxValue
{
    if ([self.dataSource respondsToSelector:@selector(maxValueOfRadarChart:)]) {
        return [self.dataSource maxValueOfRadarChart:self];
    }
    
    return 1.0;
}

- (CGFloat)minValue
{
    if ([self.dataSource respondsToSelector:@selector(minValueOfRadarChart:)]) {
        return [self.dataSource minValueOfRadarChart:self];
    }
    
    return 0.0;
}


#pragma mark -- DJLRadarChartSpokeDelegate methods

- (void)spoke:(DJLRadarChartSpoke *)spoke valueDidChange:(float)value
{
    [self setNeedsDisplay];

    if ([self.delegate respondsToSelector:@selector(radarChart:valueOfSpokeAtIndex:forStarAtIndex:didChange:)]) {
        [self.delegate radarChart:self valueOfSpokeAtIndex:[self.stars indexOfObject:spoke] forStarAtIndex:0 didChange:value];
    }
}

@end

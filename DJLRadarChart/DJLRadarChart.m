//
//  DJLRadarChart.m
//  Danger Zone
//
//  Created by Dominick Lim on 5/4/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLRadarChart.h"

#import "DJLRadarChartSpoke.h"

//#import "DZMath.h"
//#import "UIView+Additions.h"
#import <QuartzCore/QuartzCore.h>

#define DEG2RAD(degrees) ((degrees) / 180.0f * M_PI)

@interface DJLRadarChart ()<DJLRadarChartSpokeDelegate>

// stars is an array of stars (arrays of spokes)
@property (nonatomic, strong) NSArray *stars;
@property (nonatomic, strong) NSArray *variableLabels;

@property (nonatomic) CGFloat minSpoke;
@property (nonatomic) CGFloat maxSpoke;
@property (nonatomic) CGFloat variableLabelWidth;

- (void)forEachSpokeExecuteBlock:(void (^) (DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex))block;
- (void)forEachAxisAtAngleExecuteBlock:(void (^)(CGFloat angle, NSInteger index))block;

- (void)layoutSpokes;
- (void)layoutVariableLabels;

@end

@implementation DJLRadarChart

#pragma mark -- Object lifecycle

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)addSpokes
{
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        [self addSubview:spoke];
    }];
}

- (void)removeSpokes
{
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        [spoke removeFromSuperview];
    }];
    
    self.stars = nil;
}

- (void)addVariableLabels
{
    for (UILabel *label in self.variableLabels) {
        [self addSubview:label];
    }
}

- (void)removeVariableLabels
{
    for (UILabel *label in self.variableLabels) {
        [label removeFromSuperview];
    }
    
    self.variableLabels = nil;
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
    if (self.stars.count < 1 || self.dataSource == nil) {
        return;
    }
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self drawTicksWithContext:ctx];
    [self drawAxesWithContext:ctx];
    [self drawStarsWithContext:ctx];
    [self drawCirclesAtVerticesWithContext:ctx];
}

- (void)drawTicksWithContext:(CGContextRef)ctx
{
    CGFloat numberOfTicks = 5.0;
    
    for (int i = 0; i < numberOfTicks; i++) {
        [self drawTickAtDistance:(i * (self.maxSpoke - self.minSpoke) / (numberOfTicks - 1)) + self.minSpoke context:ctx];
    }
}

- (void)drawTickAtDistance:(CGFloat)distance context:(CGContextRef)ctx
{    
    if ([self.dataSource numberOfSpokesInRadarChart:self] == 0) {
        return;
    }
    
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextBeginPath(ctx);
    CGMutablePathRef path = CGPathCreateMutable();
    
    [self forEachAxisAtAngleExecuteBlock:^(CGFloat angle, NSInteger index) {
        CGPoint point = {
            CGRectGetMidX(self.frame) + distance * sinf(angle),
            CGRectGetMidY(self.frame) + distance * cosf(angle)
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

- (void)drawTickAtValue:(CGFloat)value context:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, 1.0);
    
    CGContextBeginPath(ctx);
    CGMutablePathRef path = CGPathCreateMutable();
    
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        CGPoint spokePoint = [spoke pointOfValue];
        
        if (spokeIndex == 0) {
            CGPathMoveToPoint(path, NULL, spokePoint.x, spokePoint.y);
        } else {
            CGPathAddLineToPoint(path, NULL, spokePoint.x, spokePoint.y);
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
        CGRectGetMidX(self.frame) + self.minSpoke * sinf(angle),
        CGRectGetMidY(self.frame) + self.minSpoke * cosf(angle)
    };
    
    CGPoint endPoint = {
        CGRectGetMidX(self.frame) + self.maxSpoke * sinf(angle),
        CGRectGetMidY(self.frame) + self.maxSpoke * cosf(angle)
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
    
    UIColor *fillColor = [self.dataSource radarChart:self fillColorOfStarAtIndex:index];
    UIColor *strokeColor = [self.dataSource radarChart:self strokeColorOfStarAtIndex:index];
    
    CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
    
    [fillColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGContextAddPath(ctx, path);
    CGContextSaveGState(ctx);
    
    CGContextClosePath(ctx);
    CGContextSetRGBFillColor(ctx, red, green, blue, 0.6);
    CGContextFillPath(ctx);
    
    CGContextRestoreGState(ctx);
    
    CGContextAddPath(ctx, path);
    CGContextSaveGState (ctx);
    
    [strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
    
    CGContextClosePath(ctx);
    CGContextSetRGBStrokeColor(ctx, red, green, blue, 1.0);
    CGContextStrokePath(ctx);
    
    CGPathRelease(path);
}

- (void)drawCirclesAtVerticesWithContext:(CGContextRef)ctx
{   
//    NSInteger circleRadius = 12.5;
    NSInteger circleRadius = 5;
    
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        UIColor *strokeColor = [self.dataSource radarChart:self strokeColorOfStarAtIndex:starIndex];
        
        CGFloat red = 0.0, green = 0.0, blue = 0.0, alpha = 0.0;
        
        [strokeColor getRed:&red green:&green blue:&blue alpha:&alpha];
        CGContextSetRGBFillColor(ctx, red, green, blue, 1);
        
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
        NSInteger numberOfSpokes = [self.dataSource numberOfSpokesInRadarChart:self];
        NSInteger numberOfStars = [self.dataSource numberOfStarsInRadarChart:self];
        
        NSMutableArray *stars = [NSMutableArray arrayWithCapacity:numberOfStars];
        
        for (int i = 0; i < numberOfStars; i++) {
            NSMutableArray *spokes = [NSMutableArray arrayWithCapacity:numberOfSpokes];
            
            for (int j = 0; j < numberOfSpokes; j++) {
                DJLRadarChartSpoke *spoke = [[DJLRadarChartSpoke alloc] initWithValue:[self.dataSource radarChart:self valueOfSpokeAtIndex:j forStarAtIndex:i]];
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
        NSInteger numberOfSpokes = [self.dataSource numberOfSpokesInRadarChart:self];
        NSMutableArray *variableLabels = [NSMutableArray arrayWithCapacity:numberOfSpokes];
        
        for (int i = 0; i < numberOfSpokes; i++) {
            UILabel *variableLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.variableLabelWidth, self.variableLabelWidth}];
            variableLabel.text = [self.dataSource radarChart:self nameOfSpokeAtIndex:i];
            
            variableLabel.adjustsFontSizeToFitWidth = YES;
            variableLabel.userInteractionEnabled = YES;

//            variableLabel.layer.borderColor = [UIColor colorWithRed:231.0 / 255
//                                                              green:67.0 / 255
//                                                               blue:60.0 / 255
//                                                              alpha:1].CGColor;
//            variableLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
            variableLabel.layer.borderColor = [UIColor darkGrayColor].CGColor;
            
            variableLabel.layer.borderWidth = 2;
            
            variableLabel.layer.cornerRadius = variableLabel.frame.size.height / 5;

//            variableLabel.backgroundColor = [UIColor colorWithRed:192.0 / 255
//                                                            green:57.0 / 255
//                                                             blue:43.0 / 255
//                                                            alpha:1];
//            variableLabel.backgroundColor = [UIColor darkGrayColor];
            variableLabel.backgroundColor = [UIColor lightGrayColor];

//            variableLabel.textColor = [UIColor whiteColor];
            variableLabel.textColor = [UIColor blackColor];

            variableLabel.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
            variableLabel.textAlignment = NSTextAlignmentCenter;
            
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
                                                     initWithTarget:self
                                                     action:@selector(handleVariableLabelTap:)];
            
            [variableLabel addGestureRecognizer:tapRecognizer];
            
            [variableLabels addObject:variableLabel];
        }
        
        _variableLabels = variableLabels;
    }
    
    return _variableLabels;
}

- (CGFloat)minSpoke
{
    CGFloat thumbWidth = 25.0;
    CGFloat circum = [self.dataSource numberOfSpokesInRadarChart:self] * (thumbWidth + 1.0);
    return circum / (2 * M_PI);
}

- (CGFloat)maxSpoke
{
    return self.frame.size.width / 2 - (self.variableLabelWidth);
}

- (CGFloat)variableLabelWidth
{
    return 30;
}


#pragma mark -- Public methods

- (void)reloadData
{
    [self removeSpokes];
    [self removeVariableLabels];
    
    [self addSpokes];
    [self addVariableLabels];
}


#pragma mark -- Private methods

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
    NSInteger numberOfSpokes = [self.dataSource numberOfSpokesInRadarChart:self];
    
    if (numberOfSpokes == 0) {
        return;
    }
    
    CGFloat angleBetweenVertices = 360.0 / numberOfSpokes;
    
    for (int i = 0; i < numberOfSpokes; i++) {
        block(DEG2RAD(angleBetweenVertices * i), i);
    }
}

- (void)layoutSpokes
{
    CGFloat centerDistanceFromCenter = (self.minSpoke + self.maxSpoke) / 2;
    CGFloat angleBetweenVertices = 360.0 / [self.dataSource numberOfSpokesInRadarChart:self];
    CGFloat width = (self.maxSpoke - self.minSpoke);
    
    [self forEachSpokeExecuteBlock:^(DJLRadarChartSpoke *spoke, NSInteger starIndex, NSInteger spokeIndex) {
        
        // if the spoke hasn't been rotated yet, rotate it.
        if (spoke.cosAngle == 1 && spoke.sinAngle == 0) {
            spoke.frame = (CGRect){spoke.frame.origin, width, spoke.frame.size.height};
            spoke.transform = CGAffineTransformRotate(spoke.transform, DEG2RAD((angleBetweenVertices * spokeIndex) - 90));
        }

        spoke.center = (CGPoint){
            CGRectGetMidX(self.frame) + centerDistanceFromCenter * spoke.cosAngle,
            CGRectGetMidY(self.frame) + centerDistanceFromCenter * spoke.sinAngle
        };
    }];
}

- (void)layoutVariableLabels
{
    [self forEachAxisAtAngleExecuteBlock:^(CGFloat angle, NSInteger index) {
        CGPoint center = {
            CGRectGetMidX(self.frame) + (self.variableLabelWidth + self.maxSpoke) * sinf(angle),
            CGRectGetMidY(self.frame) + (self.variableLabelWidth + self.maxSpoke) * -cosf(-angle)
        };
        [self.variableLabels[index] setCenter:center];
    }];
}

- (void)handleVariableLabelTap:(UITapGestureRecognizer *)sender
{
//    ((DJLRadarChartSpoke *)self.spokes[[self.variableLabels indexOfObject:sender.view]]).value += 0.1;
}


#pragma mark -- DJLRadarChartSpokeDelegate methods

- (void)spoke:(DJLRadarChartSpoke *)spoke valueDidChange:(float)value
{
    [self setNeedsDisplay];
    
//    [self.delegate radarChart:self valueOfSpokeAtIndex:[self.stars indexOfObject:spoke] forStarAtIndex:0 didChange:value];
}


@end

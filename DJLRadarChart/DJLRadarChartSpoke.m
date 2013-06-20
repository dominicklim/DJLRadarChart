//
//  DJLRadarChartSpoke.m
//  Danger Zone
//
//  Created by Dominick Lim on 5/4/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLRadarChartSpoke.h"

@interface DJLRadarChartSpoke ()

@property (nonatomic) CGFloat unrotatedWidth;

- (CGFloat)valueOfPoint:(CGPoint)point;

@end

@implementation DJLRadarChartSpoke

- (id)initWithValue:(float)value
{
    if (self = [super init]) {
        self.value = value;
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame value:(float)value
{
    if (self = [self initWithFrame:frame]) {
        self.value = value;
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.continuous = NO;
        
        UIImage *sliderMinimum = [[UIImage imageNamed:@"clearTrack"]
                                  stretchableImageWithLeftCapWidth:4
                                  topCapHeight:0];
        [self setMinimumTrackImage:sliderMinimum forState:UIControlStateNormal];
        
        UIImage *sliderMaximum = [[UIImage imageNamed:@"clearTrack"]
                                  stretchableImageWithLeftCapWidth:4
                                  topCapHeight:0];
        [self setMaximumTrackImage:sliderMaximum forState:UIControlStateNormal];
        
//        [self setThumbImage:[UIImage imageNamed:@"smallnothumb@2x"]
        [self setThumbImage:[UIImage imageNamed:@"nothumb"]
                   forState:UIControlStateNormal];
//        [self setThumbImage:[UIImage imageNamed:@"smallnothumb@2x"]
        [self setThumbImage:[UIImage imageNamed:@"nothumb"]
                   forState:UIControlStateHighlighted];
        _unrotatedWidth = self.frame.size.width;
    }
    
    return self;
}


#pragma mark -- Public properties

- (CGFloat)totalWidth
{
    return self.unrotatedWidth + self.currentThumbImage.size.width;
}


#pragma mark -- UISlider method overrides

- (void)setValue:(float)value
{
    [super setValue:value];
    [self.delegate spoke:self valueDidChange:self.value];
}


#pragma mark -- Public methods

- (CGFloat)rotationAngle
{
    return atan2f(self.sinAngle, self.cosAngle);
}

- (CGFloat)cosAngle
{
    return self.transform.a;
}

- (CGFloat)sinAngle
{
    return self.transform.b;
}

- (CGFloat)currentThumbWidth
{
    return self.currentThumbImage.size.width;
}

- (CGPoint)pointOfValue
{
    return [self pointOfValue:self.value];
}

- (CGPoint)minPoint
{
    return [self pointOfValue:0.0];
}

- (CGPoint)maxPoint
{
    return [self pointOfValue:1.0];
}

- (CGPoint)pointOfValue:(CGFloat)value
{
    CGFloat relevantWidth = self.unrotatedWidth - self.currentThumbWidth;
    
    // Unrotated distances
    CGFloat distanceFromCenterX = relevantWidth * (value - 0.5);
    CGFloat distanceFromCenterY = relevantWidth * (value - 0.5);
    
    // Sets vertices on the inside of thumb images. Default behavior sets
    // vertices on the center of thumb images.
//    distanceFromCenterX -= self.currentThumbWidth / 2;
//    distanceFromCenterY -= self.currentThumbWidth / 2;
    
    // Rotated distances
    distanceFromCenterX *= self.cosAngle;
    distanceFromCenterY *= self.sinAngle;
    
    return (CGPoint) {
        CGRectGetMidX(self.frame) + distanceFromCenterX,
        CGRectGetMidY(self.frame) + distanceFromCenterY
    };
}

#pragma mark -- Private methods

- (CGFloat)valueOfPoint:(CGPoint)point
{
    CGFloat relevantWidth = self.unrotatedWidth - self.currentThumbWidth;
    
    // If cos(rotation angle) equals 0, the spoke is vertical (rotation angle
    // is 90' or 270').
    BOOL vertical = self.cosAngle == 0;
    
    // Rotated distance from the center.
    // If the spoke is vertical, the distance between point.x and spoke.centerX
    // will be ~zero. So, in that case, use point.y and spoke.centerY.
    CGFloat verticalDistanceFromCenter = point.y - CGRectGetMidY(self.frame);
    CGFloat horizontalDistanceFromCenter = point.x - CGRectGetMidX(self.frame);
    CGFloat distanceFromCenter = (vertical) ? verticalDistanceFromCenter : horizontalDistanceFromCenter;

    // Unrotated distance from the center
    // If the spoke is vertical, distance is along the y-axis and cosAngle is 0.
    // To avoid dividing by 0 and to get the y-component, divide by sinAngle.
    // Else, get the x-component by dividing by cosAngle.
    distanceFromCenter /= (vertical) ? self.sinAngle : self.cosAngle;

    CGFloat valueFromCenter = distanceFromCenter / relevantWidth;
    CGFloat value = valueFromCenter + 0.5;
    
    return value;
}

- (void)handleTouches:(NSSet *)touches
{
    for (UITouch *touch in [touches allObjects]) {
        self.value = [self valueOfPoint:[touch locationInView:self.superview]];
    }
}


#pragma mark -- UIResponder method override

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    [self handleTouches:touches];
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self handleTouches:touches];
//}

@end

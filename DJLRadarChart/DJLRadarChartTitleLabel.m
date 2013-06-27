//
//  DJLRadarChartTitleLabel.m
//  DJLRadarChart
//
//  Created by Dominick Lim on 6/26/13.
//  Copyright (c) 2013 Dominick Lim. All rights reserved.
//

#import "DJLRadarChartTitleLabel.h"

@implementation DJLRadarChartTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor blackColor];

        self.adjustsFontSizeToFitWidth = YES;
        self.font = [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        self.textAlignment = NSTextAlignmentCenter;
    }

    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    self.font = [self fontToFit];
}

- (void)setText:(NSString *)text
{
    [super setText:text];

    self.font = [self fontToFit];
}

- (UIFont *)fontToFit
{
    CGFloat fontSize = self.font.pointSize;
    CGSize titleSize = [self titleSizeWithFontSize:fontSize];

    // While the title size is smaller than the label's size, make font bigger
    while (titleSize.height < self.frame.size.height && titleSize.width < self.frame.size.width) {
        fontSize += 0.5;
        titleSize = [self titleSizeWithFontSize:fontSize];
    }

    // While the title size is bigger than the label's size, make font smaller
    while (fontSize > 0.0 && (titleSize.height > self.frame.size.height || titleSize.width > self.frame.size.width)) {
        fontSize -= 0.5;
        titleSize = [self titleSizeWithFontSize:fontSize];
    }

    return [UIFont fontWithName:self.font.fontName size:fontSize];
}

- (CGSize)titleSizeWithFontSize:(CGFloat)fontSize
{
    return [self.text sizeWithFont:[UIFont fontWithName:self.font.fontName size:fontSize] constrainedToSize:self.frame.size];
}

@end

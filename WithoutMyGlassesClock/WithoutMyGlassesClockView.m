//
//  WithoutMyGlassesClockView.m
//  WithoutMyGlassesClock
//
//  Created by Jenny Brown on 4/16/18.
//  Copyright © 2018 Jenny Brown. All rights reserved.
//

#import "WithoutMyGlassesClockView.h"

@implementation WithoutMyGlassesClockView

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

- (void)startAnimation
{
    [super startAnimation];
}

- (void)stopAnimation
{
    [super stopAnimation];
}

// this code used to be in animateOneFrame but got moved due
// to the bug: https://github.com/lionheart/openradar-mirror/issues/20659
- (void)drawRect:(NSRect)rect
{
    // How big of a screen are we working with?
    NSSize size = [self bounds].size;
    NSRect screenrect;
    screenrect.size = NSMakeSize(size.width, size.height);
    
    // Get and format the current time
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"h:mm"];
    NSDate *currentDate = [NSDate date];
    NSString *dateString = [formatter stringFromDate:currentDate];
    
    // Draw a rectangle background to clear any prior drawing
    NSRect bgrect;
    bgrect.size = NSMakeSize(size.width, size.height);
    bgrect.origin = CGPointMake(0, 0);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:bgrect];
    NSColor *color = [NSColor colorWithCalibratedRed:0.0
                                               green:0.0
                                                blue:0.0
                                               alpha:255.0];
    [color set];
    [path fill];
    
    // Draw the time as text on the screen rectangle using the styling attributes specified in dict
    float largestPointSize = calculatePointSizeToFillScreen(self.bounds.size, size.height, size.width);
    [dateString drawInRect:screenrect withAttributes:createFontStylingDictionary(largestPointSize)];
    
    // if the above is slow or crashy, use this.
    //[dateString drawInRect:screenrect withAttributes:createFontStylingDictionary(750)]; // was 750
}

// Style the clock text to fill the available space but not run over in either direction.
static NSMutableDictionary * createFontStylingDictionary(float textsize) {
    
    // alpha 1.0 = solid, 0.0 = transparent.
    NSColor *darkRedColor = [NSColor colorWithCalibratedRed:0.2 green:0.0 blue:0.0 alpha:1.0];
    
    // TODO: Configurable font choice
    NSFont* font = [NSFont fontWithName:@"Times New Roman Bold" size:textsize];
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    NSMutableDictionary *myDictionary = [NSMutableDictionary dictionary];
    [myDictionary setObject:style  forKey:NSParagraphStyleAttributeName];
    [myDictionary setObject:font  forKey:NSFontAttributeName];
    [myDictionary setObject:darkRedColor forKey:NSForegroundColorAttributeName];
    
    // about 5% kerning tightening reduces gaps and makes the numbers fit on screen better
    NSNumber *kerning = [NSNumber numberWithFloat:(-1.0 * 0.05 * textsize)];
    [myDictionary setObject:kerning forKey:NSKernAttributeName];
    return myDictionary;
}


static float calculatePointSizeToFillScreen(CGSize boundingSize, float screenHeight, float screenWidth) {
    CGRect labelRect;
    float priorPointSize = 0.0;
    float pointsize = 12.0;
    float margin = 20;
    
    // Todo: Is there any method other than trial and error to figure out the right sizing?
    while ( labelRect.size.height < (screenHeight - margin) && labelRect.size.width < (screenWidth - margin)) {
        priorPointSize = pointsize;
        labelRect = [@"12:59"
                     boundingRectWithSize:boundingSize
                     options:NSStringDrawingUsesFontLeading
                     attributes:createFontStylingDictionary(pointsize)
                     context:nil];
        pointsize += 10;
    }
    return priorPointSize;
}

- (void)animateOneFrame
{
}
- (BOOL)hasConfigureSheet
{
    return NO;
}

- (NSWindow*)configureSheet
{
    return nil;
}

@end

//
//  WithoutMyGlassesClockView.m
//  WithoutMyGlassesClock
//
//  Created by Jenny Brown on 4/16/18.
//  Copyright © 2018 Jenny Brown. All rights reserved.
//

#import "WithoutMyGlassesClockView.h"

@implementation WithoutMyGlassesClockView

NSDateFormatter *hmformatter;
NSDateFormatter *ssformatter;

- (instancetype)initWithFrame:(NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:1/5.0];
    }
    hmformatter = [[NSDateFormatter alloc] init];
    [hmformatter setDateFormat:@"h:mm"];
    ssformatter = [[NSDateFormatter alloc] init];
    [ssformatter setDateFormat:@":ss"];
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
    // Draw a rectangle background to clear any prior drawing
    NSRect bounds = self.bounds;
    NSSize size = bounds.size;
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    NSColor *color = [NSColor colorWithSRGBRed:0.0
                                         green:0.0
                                          blue:0.0
                                         alpha:1.0];
    [color set];
    [path fill];
    
    // Get and format the current time
    NSDate *now = [NSDate date];
    NSString *dateString = [hmformatter stringFromDate:now];
    NSString *secondsString = [ssformatter stringFromDate:now];

    float largestPointSize = calculatePointSizeToFillScreen(bounds.size);
    NSDictionary *mainAttributes = createFontStylingDictionary(largestPointSize);
    NSSize mainTextSize = [dateString sizeWithAttributes:mainAttributes];
    NSPoint mainTextOrigin = NSMakePoint(NSMidX(bounds) - (mainTextSize.width / 2.0),
                                         NSMidY(bounds) - (mainTextSize.height / 2.0));
    [dateString drawAtPoint:mainTextOrigin withAttributes:mainAttributes];
    
    // draw the seconds in a second separate line at a smaller font size. Origin 0,0 starts at bottom!
    float secondsPointSize = MAX(largestPointSize * 0.3, 1.0);
    NSDictionary *secondsAttributes = createFontStylingDictionary(secondsPointSize);
    NSSize secondsTextSize = [secondsString sizeWithAttributes:secondsAttributes];
    CGFloat bottomMargin = MAX(4.0, size.height * 0.05);
    NSFont *secondsFont = secondsAttributes[NSFontAttributeName];
    CGFloat secondsDescenderPadding = MAX(secondsTextSize.height - secondsFont.ascender, 0.0);
    NSPoint secondsOrigin = NSMakePoint(NSMidX(bounds) - (secondsTextSize.width / 2.0),
                                        bottomMargin + secondsDescenderPadding);
    [secondsString drawAtPoint:secondsOrigin withAttributes:secondsAttributes];

    
}

// Style the clock text to fill the available space but not run over in either direction.
static NSFont * clockFont(float textsize) {
    NSFont* font = [NSFont fontWithName:@"Times New Roman Bold" size:textsize];
    if (font == nil) {
        font = [NSFont boldSystemFontOfSize:textsize];
    }
    return font;
}

static NSMutableDictionary * createFontStylingDictionary(float textsize) {
    
    // alpha 1.0 = solid, 0.0 = transparent.
    NSColor *darkRedColor = [NSColor colorWithSRGBRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    
    // TODO: Configurable font choice
    NSFont* font = clockFont(textsize);
    
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByWordWrapping;
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


static float calculatePointSizeToFillScreen(CGSize boundingSize) {
    CGRect labelRect = CGRectZero;
    float priorPointSize = 0.0;
    float targetWidth = boundingSize.width * 0.7;
    float maxHeight = boundingSize.height * 0.6;
    
    if (boundingSize.width <= 0.0 || boundingSize.height <= 0.0) {
        return 1.0;
    }
    
    NSInteger lowPointSize = 1;
    NSInteger highPointSize = (NSInteger)floor(MAX(12.0, MAX(boundingSize.width, boundingSize.height)));
    NSMutableDictionary *measurementAttributes = [NSMutableDictionary dictionary];
    while (lowPointSize <= highPointSize) {
        NSInteger pointsize = (lowPointSize + highPointSize) / 2;
        NSFont* font = clockFont(pointsize);
        NSNumber *kerning = [NSNumber numberWithFloat:(-1.0 * 0.05 * pointsize)];
        [measurementAttributes setObject:font forKey:NSFontAttributeName];
        [measurementAttributes setObject:kerning forKey:NSKernAttributeName];
        NSSize labelSize = [@"12:59" sizeWithAttributes:measurementAttributes];
        labelRect = CGRectMake(0.0, 0.0, labelSize.width, labelSize.height);
        if (labelRect.size.width <= targetWidth && labelRect.size.height <= maxHeight) {
            priorPointSize = pointsize;
            lowPointSize = pointsize + 1;
        } else {
            highPointSize = pointsize - 1;
        }
    }
    return MAX(priorPointSize, 1.0);
}

- (void)animateOneFrame
{
    [self setNeedsDisplay:YES];
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

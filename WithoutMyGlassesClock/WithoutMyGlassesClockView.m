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
    NSSize size = [self bounds].size;
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    NSColor *color = [NSColor colorWithCalibratedRed:0.0
                                               green:0.0
                                                blue:0.0
                                               alpha:255.0];
    [color set];
    [path fill];
    
    // Get and format the current time
    NSString *dateString = [hmformatter stringFromDate:[NSDate date]];
    NSString *secondsString = [ssformatter stringFromDate:[NSDate date]];

    float largestPointSize = calculatePointSizeToFillScreen(self.bounds.size) * 0.9;
    [dateString drawInRect:rect withAttributes:createFontStylingDictionary(largestPointSize)];
    
    // draw the seconds in a second separate line at a smaller font size. Origin 0,0 starts at bottom!
    NSRect lowerHalfBounds;
    lowerHalfBounds.size = NSMakeSize(size.width, size.height/3.0);
    lowerHalfBounds.origin = CGPointMake(0, 0);
    [secondsString drawInRect:lowerHalfBounds withAttributes:createFontStylingDictionary(largestPointSize*0.3)];

    
}

// Style the clock text to fill the available space but not run over in either direction.
static NSMutableDictionary * createFontStylingDictionary(float textsize) {
    
    // alpha 1.0 = solid, 0.0 = transparent.
    NSColor *darkRedColor = [NSColor colorWithCalibratedRed:0.7 green:0.0 blue:0.0 alpha:1.0];
    
    // TODO: Configurable font choice
    NSFont* font = [NSFont fontWithName:@"Times New Roman Bold" size:textsize];
    
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
    CGRect labelRect;
    float priorPointSize = 0.0;
    float pointsize = 12.0;
    float margin = 20;
    
    // Todo: Is there any method other than trial and error to figure out the right sizing? Math doesn't seem to do it.
    while ( labelRect.size.height < (boundingSize.height - margin) && labelRect.size.width < (boundingSize.width - margin)) {
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

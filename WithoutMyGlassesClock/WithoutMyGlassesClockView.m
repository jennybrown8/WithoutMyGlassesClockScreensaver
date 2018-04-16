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

- (void)drawRect:(NSRect)rect
{
    [super drawRect:rect];
}

- (void)animateOneFrame
{
    return;
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

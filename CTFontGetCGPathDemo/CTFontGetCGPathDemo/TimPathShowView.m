//
//  TimPathShowView.m
//  CTFontGetCGPathDemo
//
//  Created by 李佳 on 15/12/22.
//  Copyright © 2015年 LiJia. All rights reserved.
//

#import "TimPathShowView.h"
#import <CoreText/CTFont.h>
#import <QuartzCore/CAAnimation.h>

@interface TimPathShowView()

@property(nonatomic, copy)NSString* showText;
@property(nonatomic, assign)CGRect* rects;

@end

@implementation TimPathShowView

- (instancetype)init
{
    if (self = [super init])
    {
        NSString* fontName = @"STHeitiSC-Light";
        
        //字体的默认martix是和CoreGraphic相反的。。所以这里转一下。
        CGAffineTransform textMartix = CGAffineTransformIdentity;
        textMartix = CGAffineTransformMakeScale(1.0f, -1.0f);
        CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)fontName, 30.0f, &textMartix);
        NSString* showText = @"Timerreader佳";
        self.showText = showText;
        
        UniChar* chars = (UniChar*)malloc(sizeof(UniChar) * showText.length);
        CGGlyph* glyphs = (CGGlyph*)malloc(sizeof(CGGlyph) * showText.length);
        CGRect* rects = (CGRect*)malloc(sizeof(CGRect) * showText.length);
        
        CFStringGetCharacters((CFStringRef)showText, CFRangeMake(0, showText.length), chars);
        CTFontGetGlyphsForCharacters(ctFont, chars, glyphs, showText.length);
        CTFontGetBoundingRectsForGlyphs(ctFont, kCTFontOrientationDefault, glyphs, rects, showText.length);
        
        
        NSMutableArray* pathArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < showText.length; ++i)
        {
            CGPathRef path = CTFontCreatePathForGlyph(ctFont, glyphs[i], NULL);
            if (path)
                [pathArr addObject:(__bridge id)path];
        }
        self.paths = pathArr;
        self.rects = rects;

        CFRelease(ctFont);
        free(chars);
        free(glyphs);
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    int xOffset = 0;
    for (int i = 0; i < self.showText.length; ++i)
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, 100 + xOffset, 100);
        xOffset += self.rects[i].size.width + 3;
        
        CGContextAddPath(context, (__bridge CGPathRef)self.paths[i]);
        CGContextSetLineWidth(context, 1);
        CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
        CGContextStrokePath(context);
        CGContextRestoreGState(context);
    }
}

-(void)dealloc
{
    free(self.rects);
    for (int i = 0; i < self.paths.count; ++i)
        CFRelease((__bridge CGPathRef)self.paths[i]);
}

@end

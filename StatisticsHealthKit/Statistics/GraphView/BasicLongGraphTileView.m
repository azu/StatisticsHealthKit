//
// Created by azu on 2014/03/03.
//


#import <ArsScale/ArsScaleLinear.h>
#import <HealthKit/HealthKit.h>
#import "BasicLongGraphTileView.h"
#import "DrowningGraphicer.h"
#import "DrowningGraphicsArcContext.h"
#import "DrowningGraphicsLineContext.h"


@interface BasicLongGraphTileView ()
@end

@implementation BasicLongGraphTileView {

}

- (void)drawRect:(CGRect) rect {
    [super drawRect:rect];
    CGSize size = self.bounds.size;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    self.backgroundColor = [UIColor clearColor];
    self.layer.masksToBounds = NO;
    [self drawContext:context size:size];
}

- (void)drawContext:(CGContextRef) context size:(CGSize) size {
    [self draw:context size:size];
}

// ●-● の線を点を描画する
// Viewの端で半円になるが、両方で描画すれば上手く行ける
- (void)draw:(CGContextRef) pContext size:(CGSize) size {
    DrowningGraphicer *drowning = [DrowningGraphicer drowningWithContextRef:pContext];

    NSNumber *currentY = [self.yScale scale:@([self.currentStatistics.averageQuantity doubleValueForUnit:[HKUnit degreeCelsiusUnit]])];
    CGPoint startPoint = CGPointMake(0, size.height - currentY.floatValue);
    // ●
    CGSize arcSize = CGSizeMake(10, 10);
    [drowning arcContext:^(DrowningGraphicsArcContext *arcContext) {
        [arcContext drawFilledCircle:startPoint radius:arcSize.width / 2 color:[UIColor blueColor]];
    }];

    if (self.nextStatistics != nil) {
        NSNumber *nextY = [self.yScale scale:@([self.nextStatistics.averageQuantity doubleValueForUnit:[HKUnit degreeCelsiusUnit]])];
        CGPoint endPoint = CGPointMake(size.width, size.height - nextY.floatValue);
        // ●
        [drowning arcContext:^(DrowningGraphicsArcContext *arcContext) {
            [arcContext drawFilledCircle:endPoint radius:arcSize.width / 2 color:[UIColor blueColor]];
        }];

        // ●---●
        [drowning lineContext:^(DrowningGraphicsLineContext *context) {
            [context drawLine:startPoint endPoint:endPoint lineColor:[UIColor blackColor]];

        }];
    }
}


@end
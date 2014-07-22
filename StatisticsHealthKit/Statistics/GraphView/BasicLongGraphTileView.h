//
// Created by azu on 2014/03/03.
//


#import <Foundation/Foundation.h>
#import "DARecycledTileView.h"

@class ArsScaleLinear;
@class HKStatistics;

@interface BasicLongGraphTileView : DARecycledTileView
@property(nonatomic, weak) ArsScaleLinear *yScale;
@property(weak, nonatomic) IBOutlet UILabel *dateLabel;
@property(nonatomic, weak) HKStatistics *currentStatistics;
@property(nonatomic, weak) HKStatistics *nextStatistics;
@end
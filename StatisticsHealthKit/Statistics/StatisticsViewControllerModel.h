//
// Created by azu on 2014/07/22.
//


#import <Foundation/Foundation.h>

@class HKStatistics;
@class NSDate;
@class PMKPromise;
@class HKStatisticsCollection;
@class DataStoreManager;


@interface StatisticsViewControllerModel : NSObject

- (PMKPromise *)reloadData;

- (NSInteger)numberOfData;

- (HKStatistics *)statisticsAtIndex:(NSUInteger) index;

- (NSString *)dateAtIndex:(NSUInteger) index;
@end
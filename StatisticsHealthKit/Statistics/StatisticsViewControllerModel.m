//
// Created by azu on 2014/07/22.
//


#import <HealthKit/HealthKit.h>
#import <NSDate-Escort/NSDate+Escort.h>
#import <PromiseKit/Promise.h>
#import "StatisticsViewControllerModel.h"
#import "DataStoreManager.h"
#import <UIKit/UIKit.h>

@interface StatisticsViewControllerModel ()
@property(nonatomic, strong) DataStoreManager *storeManager;
@property(nonatomic, strong) NSArray *graphDataList;
@end

@implementation StatisticsViewControllerModel {

}
- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.storeManager = [[DataStoreManager alloc] init];

    return self;
}

// Handle Body Temperature
- (HKQuantityType *)managedType {
    return [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyTemperature];
}


- (PMKPromise *)reloadData {
    NSDateComponents *dayComponents = [[NSDateComponents alloc] init];
    dayComponents.day = 1;
    NSDate *startOfMonth = [[NSDate date] dateAtStartOfMonth];
    NSDate *endOfMonth = [[NSDate date] dateAtEndOfMonth];
    PMKPromise *promise = [self.storeManager collection:self.managedType predicate:nil options:HKStatisticsOptionDiscreteAverage anchorDate:startOfMonth components:dayComponents];
    return promise.then(^(HKStatisticsCollection *collection) {
        NSMutableArray *graphDataListMutable = [NSMutableArray array];
        // first day -- last day
        [collection enumerateStatisticsFromDate:startOfMonth toDate:endOfMonth withBlock:^(HKStatistics *result, BOOL *stop) {
            [graphDataListMutable addObject:result];
        }];
        self.graphDataList = graphDataListMutable;
        return graphDataListMutable;
    });
}

- (NSInteger)numberOfData {
    return [self.graphDataList count];
}

- (HKStatistics *)statisticsAtIndex:(NSUInteger) index {
    NSUInteger row = index;
    if (0 <= row && row < [self numberOfData]) {
        return self.graphDataList[row];
    }
    return nil;
}


- (NSString *)dateAtIndex:(NSUInteger) index {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    HKStatistics *statistics = [self statisticsAtIndex:index];
    return [dateFormatter stringFromDate:statistics.endDate];
}
@end
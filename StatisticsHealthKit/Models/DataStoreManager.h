//
// Created by azu on 2014/07/09.
//


#import <Foundation/Foundation.h>

@class PMKPromise;

#import <HealthKit/HealthKit.h>

@interface DataStoreManager : NSObject
@property(nonatomic, strong) HKHealthStore *healthStore;
// authorizationToType + authorizationStatusForType
- (PMKPromise *)availableType:(HKQuantityType *) hkQuantity;

- (PMKPromise *)authorizationToType:(HKQuantityType *) hkQuantity;

- (PMKPromise *)authorizationStatusForType:(HKQuantityType *) quantityType;

- (PMKPromise *)deleteSample:(HKQuantitySample *) sample;

- (PMKPromise *)writeSample:(HKQuantitySample *)sample;

- (PMKPromise *)fetchAllSampleForType:(HKQuantityType *) quantityType;

- (PMKPromise *)statisticsForType:(HKQuantityType *) quantityType predicate:(NSPredicate *) predicate options:(enum HKStatisticsOptions) options;

- (PMKPromise *)collection:(HKQuantityType *) quantityType predicate:(NSPredicate *) predicate options:(HKStatisticsOptions) options anchorDate:(NSDate *) date components:(NSDateComponents *) components;
@end
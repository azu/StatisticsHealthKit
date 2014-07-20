//
// Created by azu on 2014/07/09.
//


#import <PromiseKit/Promise.h>
#import "DataStoreManager.h"


@implementation DataStoreManager {

}
- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    // long life object
    _healthStore = [[HKHealthStore alloc] init];

    return self;
}

// auth -> status
- (PMKPromise *)availableType:(HKQuantityType *) hkQuantity {
    return [self authorizationToType:hkQuantity].then(^{
        return [self authorizationStatusForType:hkQuantity];
    });
}

- (PMKPromise *)authorizationToType:(HKQuantityType *) quantityType {
    NSSet *dataTypes = [NSSet setWithObject:quantityType];
    // authorization for write
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.healthStore requestAuthorizationToShareTypes:dataTypes readTypes:dataTypes completion:^(BOOL success, NSError *error) {
            if (!error) {
                fulfiller(nil);
            } else {
                rejecter(error);
            }
        }];
    }];
}

- (PMKPromise *)authorizationStatusForType:(HKQuantityType *) quantityType {
    // authorization for write
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:quantityType];
        switch (status) {
            case HKAuthorizationStatusNotDetermined:
                rejecter([NSError errorWithDomain:@"HKAuthorizationStatus" code:status userInfo:nil]);
            case HKAuthorizationStatusSharingDenied:
                rejecter([NSError errorWithDomain:@"HKAuthorizationStatus" code:status userInfo:nil]);
            case HKAuthorizationStatusSharingAuthorized:
                fulfiller(nil);
        }
    }];
}

- (PMKPromise *)deleteSample:(HKQuantitySample *) sample {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.healthStore deleteObject:sample withCompletion:^(BOOL success, NSError *error) {
            if (!error) {
                fulfiller(nil);
            } else {
                rejecter(error);
            }
        }];
    }];
}

// HKQuantitySample is child of HKObject
- (PMKPromise *)writeSample:(HKQuantitySample *) sample {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        [self.healthStore saveObject:sample withCompletion:^(BOOL success, NSError *error) {
            if (!error) {
                fulfiller(nil);
            } else {
                rejecter(error);
            }
        }];
    }];
}

- (PMKPromise *)fetchAllSampleForType:(HKQuantityType *) quantityType {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:HKSampleSortIdentifierEndDate ascending:NO];
        HKSampleQuery *sampleQuery = [[HKSampleQuery alloc] initWithSampleType:quantityType predicate:nil limit:0 sortDescriptors:@[sortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
            if (!error) {
                fulfiller(results);
            } else {
                rejecter(error);
            }
        }];
        [self.healthStore executeQuery:sampleQuery];
    }];
}

// then : HKStatistics
- (PMKPromise *)statisticsForType:(HKQuantityType *) quantityType predicate:(NSPredicate *) predicate options:(enum HKStatisticsOptions) options {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        HKStatisticsQuery *statisticsQuery = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:options completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
            if (!error) {
                fulfiller(result);
            } else {
                rejecter(error);
            }
        }];
        [self.healthStore executeQuery:statisticsQuery];

    }];
}

// return HKStatisticsCollection
- (PMKPromise *)collection:(HKQuantityType *) quantityType predicate:(NSPredicate *) predicate options:(HKStatisticsOptions) options anchorDate:(NSDate *) date components:(NSDateComponents *) components {
    return [PMKPromise new:^(PMKPromiseFulfiller fulfiller, PMKPromiseRejecter rejecter) {
        HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:options anchorDate:date intervalComponents:components];
        collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection *result, NSError *error) {
            if (!error) {
                fulfiller(result);
            } else {
                rejecter(error);
            }
        };
        [self.healthStore executeQuery:collectionQuery];
    }];
}

@end
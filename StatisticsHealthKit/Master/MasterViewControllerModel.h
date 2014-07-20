//
// Created by azu on 2014/07/20.
//


#import <Foundation/Foundation.h>
@class HKQuantitySample;
@class DataStoreManager;
@class PMKPromise;


@interface MasterViewControllerModel : NSObject
- (NSInteger)numberOfData;

- (NSString *)textAtIndex:(NSUInteger) indexPath;

- (PMKPromise *)insertNewRandomData;

- (HKQuantitySample *)createRandomBodyTemperature;

- (PMKPromise *)reloadData;

- (NSString *)dateTextAtIndex:(NSInteger) row;

- (PMKPromise *)deleteDataAtIndex:(NSInteger) row;
@end
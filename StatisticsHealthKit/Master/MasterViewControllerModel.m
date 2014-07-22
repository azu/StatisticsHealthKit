//
// Created by azu on 2014/07/20.
//


#import <PromiseKit/Promise.h>
#import "MasterViewControllerModel.h"
#import "DataStoreManager.h"
#import "AKUDateGenerator.h"
#import "NSDate+Escort.h"


@interface MasterViewControllerModel ()
@property(nonatomic, strong) DataStoreManager *storeManager;
@property(nonatomic, strong) NSArray *dataSource;
@end

@implementation MasterViewControllerModel {

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
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"endDate" ascending:YES];
    NSArray *(^assignDataSource)() = ^(NSArray *dataList) {
        self.dataSource = [dataList sortedArrayUsingDescriptors:@[dateSort]];
        return dataList;
    };
    return [self.storeManager availableType:self.managedType].then(^{
        return [self.storeManager fetchAllSampleForType:self.managedType];
    }).then(assignDataSource);
}

- (NSInteger)numberOfData {
    return [self.dataSource count];
}

- (NSString *)textAtIndex:(NSUInteger) row {
    HKQuantitySample *sample = self.dataSource[row];
    return sample.quantity.description;
}

- (PMKPromise *)insertNewRandomData {
    return [self.storeManager availableType:self.managedType].then(^{
        return [self.storeManager writeSample:self.createRandomBodyTemperature];
    });
}

- (HKQuantitySample *)createRandomBodyTemperature {
    NSDate *today = [NSDate date];
    NSDate *date = [AKUDateGenerator between:[today dateAtStartOfMonth] end:[today dateAtEndOfMonth]];
    HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit degreeCelsiusUnit] doubleValue:35 + arc4random_uniform(5) + (arc4random_uniform(10) / 10)];
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:self.managedType quantity:quantity startDate:date endDate:date];
    return sample;
}

- (NSString *)dateTextAtIndex:(NSInteger) row {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterLongStyle];
    HKQuantitySample *sample = self.dataSource[row];
    return [formatter stringFromDate:sample.endDate];
}

- (PMKPromise *)deleteDataAtIndex:(NSInteger) row {
    HKQuantitySample *sample = self.dataSource[row];
    return [self.storeManager deleteSample:sample].then(^{
        NSMutableArray *mutableArray = [self.dataSource mutableCopy];
        [mutableArray removeObject:sample];
        self.dataSource = mutableArray;
    });
}
@end
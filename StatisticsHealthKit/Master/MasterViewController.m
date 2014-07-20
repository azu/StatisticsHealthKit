//
//  MasterViewController.m
//  StatisticsHealthKit
//
//  Created by azu on 2014/07/20.
//  Copyright (c) 2014年 azu. All rights reserved.
//

#import <PromiseKit/Promise.h>
#import "MasterViewController.h"
#import "MasterViewControllerModel.h"

@interface MasterViewController ()

@property NSMutableArray *objects;
@property(nonatomic, strong) MasterViewControllerModel *model;
@end

@implementation MasterViewController

- (MasterViewControllerModel *)model {
    if (_model == nil) {
        _model = [[MasterViewControllerModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
}

- (void)viewWillAppear:(BOOL) animated {
    [super viewWillAppear:animated];
    [self updateTableView];
}

- (void)insertNewObject:(id) insertNewObject {
    [self.model insertNewRandomData].then(^{
        [self updateTableView];
    });
}

- (void)updateTableView {
    [self.model reloadData].then(^{
        [self.tableView reloadData];
    }).catch(^(NSError *error) {
        NSLog(@"error = %@", error);
    });

}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
    return [self.model numberOfData];
}

- (UITableViewCell *)tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)updateVisibleCells {
    // セルの表示更新
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        [self updateCell:cell atIndexPath:[self.tableView indexPathForCell:cell]];
    }
}

- (void)updateCell:(UITableViewCell *) cell atIndexPath:(NSIndexPath *) indexPath {
    cell.textLabel.text = [self.model textAtIndex:indexPath.row];
    cell.detailTextLabel.text = [self.model dateTextAtIndex:indexPath.row];
}


- (void)tableView:(UITableView *) tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.model deleteDataAtIndex:indexPath.row].then(^{
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }).catch(^(NSError *error) {
            NSLog(@"error = %@", error);
        });
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end

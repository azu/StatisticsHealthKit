//
// Created by azu on 2014/07/21.
//


#import <HealthKit/HealthKit.h>
#import <ArsScale/ArsScaleLinear.h>
#import <PromiseKit/Promise.h>
#import "StatisticsViewController.h"
#import "StatisticsViewControllerModel.h"
#import "BasicLongGraphTileView.h"
#import "UIView+MHNibLoading.h"


@interface StatisticsViewController ()
@property(nonatomic, strong) StatisticsViewControllerModel *model;
@property(weak, nonatomic) IBOutlet DARecycledScrollView *plotScrollView;
@property(nonatomic, strong) ArsScaleLinear *yScale;
@end

@implementation StatisticsViewController

- (StatisticsViewControllerModel *)model {
    if (_model == nil) {
        _model = [[StatisticsViewControllerModel alloc] init];
    }
    return _model;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.plotScrollView.dataSource = self;
    CGFloat margin = 50;
    self.yScale = [[ArsScaleLinear alloc] init];
    self.yScale.domain = @[@0, @50];
    self.yScale.range = @[@(margin), @(self.plotScrollView.frame.size.height - margin)];
}


- (void)viewDidAppear:(BOOL) animated {
    [super viewDidAppear:animated];
    [self.model reloadData].then(^{
        [self.plotScrollView reloadData];
    });
}

- (NSInteger)numberOfTilesInScrollView:(DARecycledScrollView *) scrollView {
    return [self.model numberOfData];
}

- (void)recycledScrollView:(DARecycledScrollView *) scrollView configureTileView:(DARecycledTileView *) tileView forIndex:(NSUInteger) index {
    BasicLongGraphTileView *chartCellView = (BasicLongGraphTileView *)tileView;
    chartCellView.currentStatistics = [self.model statisticsAtIndex:index];
    chartCellView.nextStatistics = [self.model statisticsAtIndex:index + 1];
    chartCellView.dateLabel.text = [self.model dateAtIndex:index];
    chartCellView.yScale = self.yScale;
    [chartCellView setNeedsDisplay];
}

- (DARecycledTileView *)tileViewForRecycledScrollView:(DARecycledScrollView *) scrollView {
    BasicLongGraphTileView *chartCellView = (BasicLongGraphTileView *)[scrollView dequeueRecycledTileView];
    if (!chartCellView) {
        chartCellView = [BasicLongGraphTileView loadInstanceFromNib];
        chartCellView.frame = CGRectMake(0, 0, 100, CGRectGetHeight(scrollView.frame));
        chartCellView.backgroundColor = [UIColor clearColor];
        chartCellView.displayRecycledIndex = YES;
        chartCellView.layer.borderWidth = 1;
        chartCellView.layer.borderColor = [UIColor redColor].CGColor;
    }
    return chartCellView;
}

- (CGFloat)widthForTileAtIndex:(NSInteger) index1 scrollView:(DARecycledScrollView *) scrollView {
    return 100.0f;
}

// 縦スクロールをロックする
- (void)scrollViewDidScroll:(id) scrollView {
    CGPoint origin = [scrollView contentOffset];
    [scrollView setContentOffset:CGPointMake(origin.x, 0.0)];
}
@end
//
//  SMLTableViewDataSource.m
//  SMLPetFeeder
//
//  Created by Ivan Blagajić on 12/02/15.
//  Copyright (c) 2015 Ivan Blagajić. All rights reserved.
//

#import "SMLTableViewDataSource.h"
#import "SMLBasicCellModel.h"
#import "SMLStandardTableViewCell.h"
#import "SMLPetCardViewModel.h"

@interface SMLTableViewDataSource ()

@property (nonatomic) SMLPetCardViewModel *viewModel;

@end

@implementation SMLTableViewDataSource

- (instancetype)initWithViewModel:(SMLPetCardViewModel*)viewModel; {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.cellModels.count;
}

- (SMLStandardTableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    SMLStandardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedingCell"];
    cell.cellModel = (id<SMLBasicCellModel>)[self.viewModel.cellModels objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

@end

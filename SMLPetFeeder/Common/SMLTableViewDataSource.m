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

@implementation SMLTableViewDataSource

- (instancetype)initWithCellModels:(NSArray*)cellModels {
    self = [super init];
    if (self) {
        self.cellModels = cellModels;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellModels.count;
}

- (SMLStandardTableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    SMLStandardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedingCell"];
    cell.cellModel = (id<SMLBasicCellModel>)[self.cellModels objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

@end

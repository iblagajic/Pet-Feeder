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

@interface SMLTableViewDataSource ()

@property (nonatomic) id<SMLStandardTableViewModel> viewModel;

@end

@implementation SMLTableViewDataSource

- (instancetype)initWithViewModel:(id<SMLStandardTableViewModel>)viewModel; {
    self = [super init];
    if (self) {
        self.viewModel = viewModel;
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.count;
}

- (SMLStandardTableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    SMLStandardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TableCell"];
    cell.cellModel = (id<SMLBasicCellModel>)[self.viewModel modelAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.viewModel respondsToSelector:@selector(removeObjectAtIndex:)]) {
        if (UITableViewCellEditingStyleDelete) {
            [self.viewModel removeObjectAtIndex:indexPath.row];
        }
    }
}

@end

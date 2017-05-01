//
//  ChatsListViewController.m
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import "ChatsListViewController.h"

#import "Person.h"
#import "PersonCellNode.h"
#import "ChatViewController.h"

@interface ChatsListViewController () <ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) NSArray* people;

@end

@implementation ChatsListViewController

- (instancetype)init {
    self = [super initWithNode:[[ASTableNode alloc] init]];
    if (self) {
        self.title = @"Messages";
        self.people = [Person someRandomPeople];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.node.dataSource = self;
    self.node.delegate = self;
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark - ASTable

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section {
    return self.people.count;
}

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    Person* person = self.people[indexPath.row];
    return ^{ return [[PersonCellNode alloc] initWithPerson:person]; };
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Person* person = self.people[indexPath.row];
    ChatViewController* vc = [[ChatViewController alloc] initWithPerson:person];
    [self.navigationController pushViewController:vc animated:YES];
}

@end

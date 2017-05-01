//
//  PersonCellNode.h
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "Person.h"

@interface PersonCellNode : ASCellNode

@property (nonatomic, strong) ASNetworkImageNode* avatarNode;
@property (nonatomic, strong) ASTextNode* nameNode;

- (instancetype)initWithPerson:(Person*)person;

@end

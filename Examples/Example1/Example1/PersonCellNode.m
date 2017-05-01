//
//  PersonCellNode.m
//  Example1
//
//  Created by Scott Kensell on 5/1/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import "PersonCellNode.h"

@implementation PersonCellNode

- (instancetype)initWithPerson:(Person *)person {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.backgroundColor = [UIColor whiteColor];
        _avatarNode = [[ASNetworkImageNode alloc] init];
        _avatarNode.style.preferredSize = CGSizeMake(30, 30);
        _avatarNode.imageModificationBlock = ASImageNodeRoundBorderModificationBlock(0, nil);
        _avatarNode.URL = person.avatarURL;
        _nameNode = [[ASTextNode alloc] init];
        _nameNode.layerBacked = YES;
        _nameNode.attributedText = [[NSAttributedString alloc] initWithString:person.name attributes:nil];
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    ASStackLayoutSpec* contentStack = [ASStackLayoutSpec horizontalStackLayoutSpec];
    contentStack.spacing = 8.0f;
    contentStack.children = @[_avatarNode, _nameNode];
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(8.0, 20.0f, 8.0f, 20.0f) child:contentStack];
}

@end

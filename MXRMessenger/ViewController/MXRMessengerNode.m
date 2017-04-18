//
//  MXRMessengerNode.m
//  Mixer
//
//  Created by Scott Kensell on 2/22/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <MXRMessenger/MXRMessengerNode.h>

@implementation MXRMessengerNode

- (instancetype)init {
    self = [super init];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        _tableNode = [[ASTableNode alloc] initWithStyle:UITableViewStylePlain];
        _tableNode.inverted = YES;
    }
    return self;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_tableNode];
}

@end

//
//  MXRMessageTextNode.h
//  Mixer
//
//  Created by Scott Kensell on 2/27/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "MXRMessageNodeConfiguration.h"
#import "MXRMessageContentNode.h"

@class MXRMessageTextConfiguration;

@interface MXRMessageTextNode : MXRMessageContentNode

- (instancetype)initWithText:(NSString*)text configuration:(MXRMessageTextConfiguration*)configuration cornersToApplyMaxRadius:(UIRectCorner)cornersHavingRadius NS_DESIGNATED_INITIALIZER;

@property (nonatomic, strong, readonly) ASTextNode* textNode;
@property (nonatomic, strong, readonly) ASImageNode* backgroundImageNode;

@end


@interface MXRMessageTextConfiguration : MXRMessageNodeConfiguration

@property (nonatomic, assign) UIEdgeInsets textInset; // Default: 8,12,8,12
- (void)setTextInset:(UIEdgeInsets)textInset adjustMaxCornerRadiusToKeepCircular:(BOOL)adjustMaxCornerRadius;

@property (nonatomic, strong, readonly) NSDictionary* textAttributes;

@property (nonatomic, assign) BOOL isLinkDetectionEnabled; // Default: YES
@property (nonatomic, strong) NSDictionary* linkAttributes; // Default: underlined
@property (nonatomic, assign) ASTextNodeHighlightStyle linkHighlightStyle; // while touching a link

- (instancetype)initWithFont:(UIFont*)font textColor:(UIColor*)textColor backgroundColor:(UIColor*)backgroundColor;
- (instancetype)initWithTextAttributes:(NSDictionary*)attributes backgroundColor:(UIColor*)backgroundColor;

@end

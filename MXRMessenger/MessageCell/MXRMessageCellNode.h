//
//  MXRMessageCellNode.h
//  Mixer
//
//  Created by Scott Kensell on 2/24/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import <AsyncDisplayKit/AsyncDisplayKit.h>

#import "MXRMessageCellConstants.h"
#import "MXRMessageTextNode.h"
#import "MXRMessageImageNode.h"
#import "MXRMessageMediaCollectionNode.h"

@class MXRMessageCellLayoutConfiguration;

/**
 * The suggested class to use for cells in the ASTableNode owned by `MXRMessengerViewController`. 
 *
 * The easiest way to create these is to call the appropriate method of `MXRMessageCellFactory` in the ASTableDataSource method `-tableNode:nodeBlockForRowAtIndexPath:`.
 *
 * This class only provides the relative positioning of the header, message, avatar, and footer.
 * To use it, simply instantiate it and set your custom nodes as the properties
 * headerNode, messageContentNode, etc.
 */
@interface MXRMessageCellNode <__covariant ContentNodeType : MXRMessageContentNode*> : ASCellNode

/**
 * The parameters necessary to layout a MXRMessageCellNode.
 */
@property (nonatomic, strong, readonly) MXRMessageCellLayoutConfiguration* layoutConfig;

/**
 * Defaults to nil. If non-nil, this content appears above everything else.
 */
@property (nonatomic, strong) ASDisplayNode* headerNode;

/**
 * Defaults to nil. You should set this to a node which displays the main message content, e.g. a textNode.
 */
@property (nonatomic, strong) ContentNodeType messageContentNode;

/**
 * Defaults to nil. Set this if you want to display an avatar for a user. It will appear next to `messageContentNode`.
 */
@property (nonatomic, strong) ASNetworkImageNode* avatarNode;

/**
 * Defaults to nil. If non-nil, this content appears below everything else.
 */
@property (nonatomic, strong) ASDisplayNode* footerNode;

- (instancetype)initWithLayoutConfiguration:(MXRMessageCellLayoutConfiguration*)layoutConfig NS_DESIGNATED_INITIALIZER;

@end

typedef MXRMessageCellNode* (^MXRMessageCellNodeBlock)(void);

typedef MXRMessageCellNode<MXRMessageTextNode*> MXRMessageTextCellNode;
typedef MXRMessageTextCellNode* (^MXRMessageTextCellNodeBlock)(void);

typedef MXRMessageCellNode<MXRMessageImageNode*> MXRMessageImageCellNode;
typedef MXRMessageImageCellNode* (^MXRMessageImageCellNodeBlock)(void);

typedef MXRMessageCellNode<MXRMessageMediaCollectionNode*> MXRMessageMediaCollectionCellNode;
typedef MXRMessageMediaCollectionCellNode* (^MXRMessageMediaCollectionCellNodeBlock)(void);

@interface MXRMessageCellLayoutConfiguration : NSObject <NSCopying>

/**
 * Whether to pin the content and avatar to the right or left.
 */
@property (nonatomic, assign) MXRMessageLayoutDirection layoutDirection;

/**
 * The fraction of available width (minus avatar width and insets) which the `messageContentNode` will be restricted to.
 * However, this does not apply to MXRMessageImage node, for which you must specify a maximum size for images.
 */
@property (nonatomic, assign) CGFloat fractionOfWidthToLayoutContent;

/**
 * The spacing between the avatar and the `messageContentNode`. Applicable only if `avatarNode` is set.
 */
@property (nonatomic, assign) CGFloat avatarToContentSpacing;

/**
 * Insets to apply to the `avatarNode` and `messageContentNode` together. Does not affect `headerNode` and `footerNode`.
 */
@property (nonatomic, assign) UIEdgeInsets avatarAndContentInset;

/**
 * The final insets to apply to all content appearing in `MXRMessageCellNode`. 
 * Unlike `avatarAndContentInset` this affects `headerNode` and `footerNode` too.
 */
@property (nonatomic, assign) UIEdgeInsets finalInset;

+ (instancetype)leftToRight;
+ (instancetype)rightToLeft;

@end

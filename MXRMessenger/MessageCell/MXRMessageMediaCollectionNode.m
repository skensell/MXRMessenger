//
//  MXRMessageMediaCollectionNode.m
//  Mixer
//
//  Created by Scott Kensell on 4/4/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageMediaCollectionNode.h"

#import "UIColor+MXRMessenger.h"
#import "MXRMessageMediumCellNode.h"
#import "MXRMessageImageNode.h"

@implementation MXRMessageMediaCollectionNode {
    UIRectCorner _cornersHavingRadius;
    CGFloat _maxWidth;
    CGSize _itemSize;
    MXRMessageMediaCollectionConfiguration* _configuration;
    NSInteger _topRightRow;
    NSInteger _bottomRightRow;
    NSInteger _bottomLeftRow;
}

- (instancetype)initWithMedia:(NSArray<id<MXRMessengerMedium>> *)media configuration:(MXRMessageMediaCollectionConfiguration *)configuration cornersToApplyMaxRadius:(UIRectCorner)cornersHavingRadius {
    self = [super initWithConfiguration:configuration];
    if (self) {
        self.automaticallyManagesSubnodes = YES;
        self.userInteractionEnabled = YES;
        _cornersHavingRadius = cornersHavingRadius;
        _media = media;
        _maxWidth = configuration.maxWidth;
        _configuration = configuration;
        
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        CGFloat spacing = 2.0f;
        flowLayout.minimumInteritemSpacing = spacing;
        flowLayout.minimumLineSpacing = spacing;
        flowLayout.sectionInset = UIEdgeInsetsZero;
        CGFloat length = 0.0f;
        CGFloat numRows = ceilf(media.count / 3.0f);
        if (media.count == 1) {
            length = _maxWidth;
            _topRightRow = _bottomLeftRow = _bottomRightRow = 0;
        } else if (media.count == 2) {
            length = floorf((_maxWidth - spacing)/2.0f);
            _bottomLeftRow = 0;
            _topRightRow = _bottomRightRow = 1;
        } else {
            length = floorf((_maxWidth - 2*spacing)/3.0f);
            _topRightRow = 2;
            _bottomLeftRow = (NSInteger)(numRows - 1)*3;
            _bottomRightRow = (NSInteger)(numRows - 1)*3 + 2; // may not always exist
        }
        flowLayout.itemSize = CGSizeMake(length, length);
        _itemSize = flowLayout.itemSize;
        
        CGFloat totalHeight = length;
        if (media.count > 3) {
            totalHeight = (numRows * (length + flowLayout.minimumLineSpacing)) - flowLayout.minimumLineSpacing;
        }
        
        _collectionNode = [[ASCollectionNode alloc] initWithCollectionViewLayout:flowLayout];
        _collectionNode.dataSource = self;
        _collectionNode.delegate = self;
        _collectionNode.style.preferredSize = CGSizeMake(_maxWidth, totalHeight);
        self.style.preferredSize = _collectionNode.style.preferredSize;
    }
    return self;
}

- (instancetype)initWithConfiguration:(MXRMessageNodeConfiguration *)configuration {
    ASDISPLAYNODE_NOT_DESIGNATED_INITIALIZER();
    return [self initWithMedia:nil configuration:nil cornersToApplyMaxRadius:UIRectCornerAllCorners];
}

- (void)didLoad {
    [super didLoad];
    _collectionNode.view.scrollEnabled = NO;
}

- (ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize {
    return [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsZero child:_collectionNode];
}

- (NSInteger)collectionNode:(ASCollectionNode *)collectionNode numberOfItemsInSection:(NSInteger)section {
    return _media.count;
}

- (ASCellNodeBlock)collectionNode:(ASCollectionNode *)collectionNode nodeBlockForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize itemSize = _itemSize;
    NSURL* imageURL = [_media[indexPath.row] mxr_messenger_imageURLForSize:itemSize];
    NSURL* videoURL = [_media[indexPath.row] mxr_messenger_videoURLForSize:itemSize];
    MXRMessageMediaCollectionConfiguration* configuration = _configuration;
    UIRectCorner cornersHavingRadius = [self cornersHavingRadiusAtRow:indexPath.row];
    return ^ASCellNode*{
        return [[MXRMessageMediumCellNode alloc] initWithImageURL:imageURL configuration:configuration size:itemSize cornersHavingRadius:cornersHavingRadius showsPlayButton:(videoURL != nil)];
    };
}

- (UIRectCorner)cornersHavingRadiusAtRow:(NSInteger)row {
    // 0 means none, even though it looks like UIRectCornerAllCorners
    UIRectCorner cornersHavingRadius = 0;
    if (_cornersHavingRadius & UIRectCornerTopLeft) {
        if (row == 0) cornersHavingRadius |= UIRectCornerTopLeft;
    }
    if (_cornersHavingRadius & UIRectCornerTopRight) {
        if (row == _topRightRow) cornersHavingRadius |= UIRectCornerTopRight;
    }
    if (_cornersHavingRadius & UIRectCornerBottomLeft) {
        if (row == _bottomLeftRow) cornersHavingRadius |= UIRectCornerBottomLeft;
    }
    if (_cornersHavingRadius & UIRectCornerBottomRight) {
        if (row == _bottomRightRow) cornersHavingRadius |= UIRectCornerBottomRight;
    }
    return cornersHavingRadius;
}

- (void)collectionNode:(ASCollectionNode *)collectionNode didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.mediaCollectionDelegate messageMediaCollectionNode:self didSelectMedium:_media[indexPath.row] atIndexPath:indexPath];
}

#pragma mark - MXRMessageContentNode

- (void)redrawBubbleWithCorners:(UIRectCorner)newCornersHavingRadius {
    _cornersHavingRadius = newCornersHavingRadius;
    if (!self.isNodeLoaded) return;
    if (_media.count > 0) {
        UIRectCorner topLeft = [self cornersHavingRadiusAtRow:0];
        [((MXRMessageMediumCellNode*)[_collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]]) redrawWithCornersHavingRadius:topLeft];
    }
    if (_topRightRow != 0) {
        UIRectCorner topRight = [self cornersHavingRadiusAtRow:_topRightRow];
        [((MXRMessageMediumCellNode*)[_collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForRow:_topRightRow inSection:0]]) redrawWithCornersHavingRadius:topRight];
    }
    if (_bottomLeftRow != 0) {
        UIRectCorner bottomLeft = [self cornersHavingRadiusAtRow:_bottomLeftRow];
        [((MXRMessageMediumCellNode*)[_collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForRow:_bottomLeftRow inSection:0]]) redrawWithCornersHavingRadius:bottomLeft];
    }
    if ((_bottomRightRow != _topRightRow) && _bottomRightRow < _media.count) {
        UIRectCorner bottomRight = [self cornersHavingRadiusAtRow:_bottomRightRow];
        [((MXRMessageMediumCellNode*)[_collectionNode nodeForItemAtIndexPath:[NSIndexPath indexPathForRow:_bottomRightRow inSection:0]]) redrawWithCornersHavingRadius:bottomRight];
    }
}

@end


@implementation MXRMessageMediaCollectionConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        self.minCornerRadius = 3.0f;
        // _maxWidth should be 0 mod 2 and 1 mod 3 for best spacing results
        _maxWidth = [MXRMessageImageConfiguration suggestedMaxImageSizeForScreenSize:[UIScreen mainScreen].bounds.size].width;
    }
    return self;
}

@end

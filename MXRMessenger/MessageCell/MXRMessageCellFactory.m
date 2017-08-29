//
//  MXRMessageCellFactory.m
//  Mixer
//
//  Created by Scott Kensell on 2/26/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageCellFactory.h"

#import "MXRMessageImageNode.h"
#import "MXRMessageDateFormatter.h"
#import "UIImage+MXRMessenger.h"
#import "UIColor+MXRMessenger.h"

typedef struct MXRMessageContext {
    // We use pointers so that NULL can represent no previous and no next.
    // the actual pointer should be handled with caution since it may point to garbage
    // stack addresses. We don't attempt to keep a properly synced linked list.
    struct MXRMessageContext* previous;
    struct MXRMessageContext* next;
    BOOL isFromMe;
    BOOL isShowingDate;
    NSTimeInterval timestamp;
    UIRectCorner cornersHavingRadius;
} MXRMessageContext;

static inline BOOL MXRMessageContextPreviousHasSameSender(MXRMessageContext c) { return c.previous != NULL && (c.previous->isFromMe == c.isFromMe); };
static inline BOOL MXRMessageContextNextHasSameSender(MXRMessageContext c) { return c.next != NULL && (c.next->isFromMe == c.isFromMe); };
static inline BOOL MXRMessageContextNextShowsDate(MXRMessageContext c) { return c.next != NULL && c.next->isShowingDate; };

@implementation MXRMessageCellFactory {
    struct {
        unsigned int isMessageFromMeAtRow:1;
        unsigned int avatarURLAtRow:1;
        unsigned int timestampAtRow:1;
    } _dataSourceFlags;
}

- (instancetype)initWithCellConfigForMe:(MXRMessageCellConfiguration *)cellConfigForMe cellConfigForOthers:(MXRMessageCellConfiguration *)cellConfigForOthers {
    self = [super init];
    if (self) {
        _cellConfigForMe = cellConfigForMe ? : [[MXRMessageCellConfiguration alloc] init];
        _cellConfigForOthers = cellConfigForOthers ? : [[MXRMessageCellConfiguration alloc] init];
        _spacingBetweenMessagesFromMeAndMessagesFromOthers = 8.0f;
        
        _isAutomaticallyManagingWhichCornersAreRounded = YES;
        _isAutomaticallyManagingDateHeaders = YES;

        _dateFormatter = [[MXRMessageDateFormatter alloc] init];
    }
    return self;
}

- (void)setDataSource:(id<MXRMessageCellFactoryDataSource>)dataSource {
    _dataSource = dataSource;
    if (_dataSource == nil) {
        memset(&_dataSourceFlags, 0, sizeof(_dataSourceFlags));
    } else {
        _dataSourceFlags.isMessageFromMeAtRow = [_dataSource respondsToSelector:@selector(cellFactory:isMessageFromMeAtRow:)];
        _dataSourceFlags.avatarURLAtRow = [_dataSource respondsToSelector:@selector(cellFactory:avatarURLAtRow:)];
        _dataSourceFlags.timestampAtRow = [_dataSource respondsToSelector:@selector(cellFactory:timeIntervalSince1970AtRow:)];
        NSAssert(!self.isAutomaticallyManagingWhichCornersAreRounded || _dataSourceFlags.isMessageFromMeAtRow, @"You must supply a dataSource which implements cellFactory:isMessageFromMeAtRow: if you want cellFactory to automatically manage corners.");
        NSAssert(!self.isAutomaticallyManagingDateHeaders || _dataSourceFlags.timestampAtRow, @"CellFactory has isAutomaticallyManagingDateHeaders=YES but you forgot to implement the necessary dataSource method to provide the date of a message.");
    }
}

- (MXRMessageTextCellNodeBlock)cellNodeBlockWithText:(NSString *)text tableNode:(ASTableNode *)tableNode row:(NSInteger)row {
    return (MXRMessageTextCellNodeBlock)[self cellNodeBlockWithType:MXRMessageContentTypeTextOnly text:text imageURL:nil showsPlayButton:NO media:nil tableNode:tableNode row:row];
}

- (MXRMessageImageCellNodeBlock)cellNodeBlockWithImageURL:(NSURL *)imageURL showsPlayButton:(BOOL)showsPlayButton tableNode:(ASTableNode *)tableNode row:(NSInteger)row {
    return (MXRMessageImageCellNodeBlock)[self cellNodeBlockWithType:MXRMessageContentTypeImageOnly text:nil imageURL:imageURL showsPlayButton:showsPlayButton media:nil tableNode:tableNode row:row];
}

- (MXRMessageMediaCollectionCellNodeBlock)cellNodeBlockWithMedia:(NSArray<id<MXRMessengerMedium>> *)media tableNode:(ASTableNode *)tableNode row:(NSInteger)row {
    return (MXRMessageMediaCollectionCellNodeBlock)[self cellNodeBlockWithType:MXRMessageContentTypeMediaCollectionOnly text:nil imageURL:nil showsPlayButton:YES media:media tableNode:tableNode row:row];
}

- (ASCellNodeBlock)cellNodeBlockWithType:(MXRMessageContentType)type text:(NSString *)text imageURL:(NSURL*)imageURL showsPlayButton:(BOOL)showsPlayButton media:(NSArray<id<MXRMessengerMedium>> *)media tableNode:(ASTableNode *)tableNode row:(NSInteger)row {
    // we query the datasource before entering block, all other computations can go in the async block
    
    __block MXRMessageContext context; __block MXRMessageContext previousContext; __block MXRMessageContext nextContext;
    NSURL* avatarURL = nil;
    [self setContext:&context previous:&previousContext next:&nextContext avatarURL:&avatarURL tableNode:tableNode row:row];
    
    __weak MXRMessageCellFactory* weakSelf = self;
    return ^MXRMessageCellNode*{
        __strong MXRMessageCellFactory* self = weakSelf;
        // we reset pointers to prevent pointing to a garbage stack address
        if (context.previous != NULL) context.previous = &previousContext;
        if (context.next != NULL) context.next = &nextContext;
        
        MXRMessageCellConfiguration* config = context.isFromMe ? self.cellConfigForMe : self.cellConfigForOthers;
        MXRMessageCellLayoutConfiguration* layoutConfig = config.layoutConfig;
        MXRMessageAvatarConfiguration* avatarConfig = config.avatarConfig;

        if (!MXRMessageContextPreviousHasSameSender(context) && self.spacingBetweenMessagesFromMeAndMessagesFromOthers > 0.0f) {
            layoutConfig = [layoutConfig copy]; // we could cache this copy? maybe overoptimized then
            UIEdgeInsets newFinalInset = layoutConfig.finalInset;
            newFinalInset.top += self.spacingBetweenMessagesFromMeAndMessagesFromOthers;
            layoutConfig.finalInset = newFinalInset;
        }
        MXRMessageCellNode* cell = [[MXRMessageCellNode alloc] initWithLayoutConfiguration:layoutConfig];

        if (avatarConfig && avatarConfig.size.width > 0 && avatarURL) {
            ASNetworkImageNode* avatarNode = [self networkImageNode];
            avatarNode.contentMode = UIViewContentModeScaleAspectFill;
            avatarNode.style.preferredSize = avatarConfig.size;
            if (avatarConfig.cornerRadius > 0) {
                avatarNode.imageModificationBlock = [UIImage mxr_imageModificationBlockToScaleToSize:avatarConfig.size cornerRadius:avatarConfig.cornerRadius];
            }
            avatarNode.URL = avatarURL;
            cell.avatarNode = avatarNode;
        }
        
        UIRectCorner cornersHavingRadius = context.cornersHavingRadius;
        if (type == MXRMessageContentTypeTextOnly) {
            MXRMessageTextNode* textNode = [[MXRMessageTextNode alloc] initWithText:text configuration:config.textConfig cornersToApplyMaxRadius:cornersHavingRadius];
            textNode.delegate = self.contentNodeDelegate;
            cell.messageContentNode = textNode;
        } else if (type == MXRMessageContentTypeImageOnly) {
            MXRMessageImageNode* imageNode = [[MXRMessageImageNode alloc] initWithImageURL:imageURL configuration:config.imageConfig cornersToApplyMaxRadius:cornersHavingRadius showsPlayButton:showsPlayButton];
            imageNode.delegate = self.contentNodeDelegate;
            cell.messageContentNode = imageNode;
        } else if (type == MXRMessageContentTypeMediaCollectionOnly) {
            MXRMessageMediaCollectionNode* mediaCollectionNode = [[MXRMessageMediaCollectionNode alloc] initWithMedia:media configuration:config.mediaCollectionConfig cornersToApplyMaxRadius:cornersHavingRadius];
            mediaCollectionNode.mediaCollectionDelegate = self.mediaCollectionDelegate;
            cell.messageContentNode = mediaCollectionNode;
        }
        
        if (context.isShowingDate) {
            cell.headerNode = [self headerNodeFromDate:[NSDate dateWithTimeIntervalSince1970:context.timestamp]];
        }
        
        return cell;
    };
}

- (ASNetworkImageNode*)networkImageNode {
    MXRMessageImageConfiguration* imageConfig = self.cellConfigForMe.imageConfig;
    if (imageConfig.imageCache && imageConfig.imageDownloader) {
        return [[ASNetworkImageNode alloc] initWithCache:imageConfig.imageCache downloader:imageConfig.imageDownloader];
    } else {
        return [[ASNetworkImageNode alloc] init];
    }
}

- (void)setContext:(MXRMessageContext*)context previous:(MXRMessageContext*)previousContext next:(MXRMessageContext*)nextContext avatarURL:(NSURL**)avatarURLHandle tableNode:(ASTableNode*)tableNode row:(NSInteger)row {
    // This method initializes the values of context and its pointers, but does not attempt to construct
    // a proper linked list by initializing the pointers in previousContext and nextContext.
    // Only the non-pointer properties in previous and next should be accessed.
    
    NSAssert(context, @"internal expectations failed: no context");
    NSAssert(previousContext, @"internal expectations failed: no previousContext");
    NSAssert(nextContext, @"internal expectations failed: no nextContext");
    
    // bc of ASTableNode.inverted=YES the most recent message is at 0,0
    BOOL hasPreviousMessage = row < [self.dataSource tableNode:tableNode numberOfRowsInSection:0] - 1;
    BOOL hasNextMessage = row > 0;

    context->previous = hasPreviousMessage ? previousContext : NULL;
    context->next = hasNextMessage ? nextContext : NULL;
    
    if (self.isAutomaticallyManagingWhichCornersAreRounded) {
        previousContext->isFromMe = hasPreviousMessage ? [self.dataSource cellFactory:self isMessageFromMeAtRow:(row + 1)] : NO;
        context->isFromMe = [self.dataSource cellFactory:self isMessageFromMeAtRow:row];
        nextContext->isFromMe = hasNextMessage ? [self.dataSource cellFactory:self isMessageFromMeAtRow:(row - 1)] : NO;
    } else {
        previousContext->isFromMe = context->isFromMe = nextContext->isFromMe = NO;
    }
    
    if (self.isAutomaticallyManagingDateHeaders) {
        previousContext->timestamp = hasPreviousMessage ? [self.dataSource cellFactory:self timeIntervalSince1970AtRow:(row + 1)] : 0;
        context->timestamp = [self.dataSource cellFactory:self timeIntervalSince1970AtRow:row];
        nextContext->timestamp = hasNextMessage ? [self.dataSource cellFactory:self timeIntervalSince1970AtRow:(row - 1)] : 0;
        
        // we dont need to calculate if previous is showing date since we only show
        // dates in headers to determine corner rounding
        previousContext->isShowingDate = NO;
        context->isShowingDate = context->timestamp != 0 && (context->timestamp - previousContext->timestamp) > 900;
        nextContext->isShowingDate = nextContext->timestamp != 0 && ((nextContext->timestamp - context->timestamp) > 900);
    } else {
        previousContext->isShowingDate = context->isShowingDate = nextContext->isShowingDate = NO;
        previousContext->timestamp = context->timestamp = nextContext->timestamp = 0;
    }
    
    if ((avatarURLHandle != NULL) && _dataSourceFlags.avatarURLAtRow) {
        *avatarURLHandle = [self.dataSource cellFactory:self avatarURLAtRow:row];
    }

    UIRectCorner cornersHavingRadius = UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight;
    if (self.isAutomaticallyManagingWhichCornersAreRounded) {
        MXRMessageLayoutDirection layoutDirection = context->isFromMe ? self.cellConfigForMe.layoutConfig.layoutDirection : self.cellConfigForOthers.layoutConfig.layoutDirection;
        if (MXRMessageContextNextHasSameSender(*context) && !MXRMessageContextNextShowsDate(*context)) {
            cornersHavingRadius ^= (layoutDirection == MXRMessageLayoutDirectionLeftToRight ? UIRectCornerBottomLeft : UIRectCornerBottomRight);
        }
        if (MXRMessageContextPreviousHasSameSender(*context) && !context->isShowingDate) {
            cornersHavingRadius ^= (layoutDirection == MXRMessageLayoutDirectionLeftToRight ? UIRectCornerTopLeft : UIRectCornerTopRight);
        }
    }
    context->cornersHavingRadius = cornersHavingRadius;
}

- (ASDisplayNode *)headerNodeFromDate:(NSDate *)date {
    ASTextNode* dateTextNode = [[ASTextNode alloc] init];
    dateTextNode.layerBacked = YES;
    dateTextNode.attributedText = [self.dateFormatter attributedTextForDate:date];
    dateTextNode.textContainerInset = UIEdgeInsetsMake(20, 0, 8, 0);
    return dateTextNode;
}

- (void)toggleDateHeaderNodeVisibilityForCellNode:(MXRMessageCellNode *)cellNode {
    NSIndexPath* indexPath = [cellNode indexPath];
    if (cellNode.headerNode) {
        cellNode.headerNode = nil;
    } else {
        cellNode.headerNode = [self headerNodeFromDate:[NSDate dateWithTimeIntervalSince1970:[self.dataSource cellFactory:self timeIntervalSince1970AtRow:indexPath.row]]];
    }
    [cellNode setNeedsLayout];
}

- (void)updateTableNode:(ASTableNode *)tableNode animated:(BOOL)animated withInsertions:(NSArray<NSIndexPath *> *)insertions deletions:(NSArray<NSIndexPath *> *)deletions reloads:(NSArray<NSIndexPath *> *)reloads completion:(void (^)(BOOL))completion {
    
    NSInteger oldNumberOfRows = [tableNode numberOfRowsInSection:0];
    MXRMessageCellNode* oldMostRecentNode = nil;
    MXRMessageCellNode* oldOldestNode = nil;
    if (oldNumberOfRows > 0) {
        oldMostRecentNode = [tableNode nodeForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        oldOldestNode = [tableNode nodeForRowAtIndexPath:[NSIndexPath indexPathForRow:(oldNumberOfRows - 1) inSection:0]];
    }

    __weak typeof(self) weakSelf = self;
    UITableViewRowAnimation insertAnimation = insertions.count > 3 ? UITableViewRowAnimationFade : UITableViewRowAnimationTop;
    [tableNode performBatchAnimated:animated updates:^{
        [tableNode deleteRowsAtIndexPaths:deletions withRowAnimation:UITableViewRowAnimationFade];
        [tableNode insertRowsAtIndexPaths:insertions withRowAnimation:insertAnimation];
        [tableNode reloadRowsAtIndexPaths:reloads withRowAnimation:UITableViewRowAnimationNone];
    } completion:^(BOOL finished) {
        if (!finished) {
            if (completion) completion(finished);
            return;
        }
        
        if (weakSelf.isAutomaticallyManagingWhichCornersAreRounded) {
            [weakSelf updateRoundedCornersOfCellNode:oldMostRecentNode];
        }
        
        NSIndexPath* oldOldestIndexPath = [oldOldestNode indexPath];
        BOOL oldOldestNeedsReload = weakSelf.isAutomaticallyManagingDateHeaders && oldOldestIndexPath && oldOldestIndexPath.row != ([tableNode numberOfRowsInSection:0] - 1);
        if (oldOldestNeedsReload) {
            // We have to reload the oldest because it may erroneously show date headers after a tail load.
            // And it's not just dates, the top final inset can be wrong too.
            [tableNode performBatchAnimated:animated updates:^{
                [tableNode reloadRowsAtIndexPaths:@[oldOldestIndexPath] withRowAnimation:UITableViewRowAnimationNone];
            } completion:completion];
        } else {
            if (completion) completion(finished);
        }
    }];
}

- (void)updateRoundedCornersOfCellNode:(MXRMessageCellNode *)cellNode {
    NSIndexPath* indexPath = cellNode.indexPath;
    ASTableNode* tableNode = (ASTableNode*)cellNode.owningNode;
    if (!tableNode || !indexPath || !self.isAutomaticallyManagingWhichCornersAreRounded) return;
    
    __block MXRMessageContext context; __block MXRMessageContext previousContext; __block MXRMessageContext nextContext;
    [self setContext:&context previous:&previousContext next:&nextContext avatarURL:NULL tableNode:tableNode row:indexPath.row];
    [cellNode.messageContentNode redrawBubbleWithCorners:context.cornersHavingRadius];
}

@end


@implementation MXRMessageAvatarConfiguration

- (instancetype)init {
    self = [super init];
    if (self) {
        _size = CGSizeMake(36, 36);
        _cornerRadius = 18.0f;
    }
    return self;
}

@end


@implementation MXRMessageCellConfiguration

- (instancetype)init {
    return [self initWithLayoutConfig:nil avatarConfig:nil textConfig:nil imageConfig:nil mediaCollectionConfig:nil];
}

- (instancetype)initWithLayoutConfig:(MXRMessageCellLayoutConfiguration *)layoutConfig avatarConfig:(MXRMessageAvatarConfiguration *)avatarConfig textConfig:(MXRMessageTextConfiguration *)textConfig imageConfig:(MXRMessageImageConfiguration *)imageConfig mediaCollectionConfig:(MXRMessageMediaCollectionConfiguration *)mediaCollectionConfig {
    self = [super init];
    if (self) {
        _layoutConfig = layoutConfig ? : [[MXRMessageCellLayoutConfiguration alloc] init];
        _avatarConfig = avatarConfig;
        _textConfig = textConfig ? : [[MXRMessageTextConfiguration alloc] init];
        _imageConfig = imageConfig ? : [[MXRMessageImageConfiguration alloc] init];
        _mediaCollectionConfig = mediaCollectionConfig ? : [[MXRMessageMediaCollectionConfiguration alloc] init];
    }
    return self;
}

@end

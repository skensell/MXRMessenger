//
//  MXRMessageCellFactory.h
//  Mixer
//
//  Created by Scott Kensell on 2/26/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageCellNode.h"

@class MXRMessageAvatarConfiguration;
@class MXRMessageCellConfiguration;
@class MXRMessageCellFactory;
@class MXRMessageDateFormatter;


@protocol MXRMessageCellFactoryDataSource <ASTableDataSource>

@required
- (BOOL)cellFactory:(MXRMessageCellFactory*)cellFactory isMessageFromMeAtRow:(NSInteger)row;

@optional
- (NSURL*)cellFactory:(MXRMessageCellFactory*)cellFactory avatarURLAtRow:(NSInteger)row;
- (NSTimeInterval)cellFactory:(MXRMessageCellFactory*)cellFactory timeIntervalSince1970AtRow:(NSInteger)row;

@end


@interface MXRMessageCellFactory : NSObject

@property (nonatomic, strong, readonly) MXRMessageCellConfiguration* cellConfigForMe;
@property (nonatomic, strong, readonly) MXRMessageCellConfiguration* cellConfigForOthers;

@property (nonatomic, strong) MXRMessageDateFormatter* dateFormatter;

@property (nonatomic, assign) BOOL isAutomaticallyManagingWhichCornersAreRounded; // Defaults to YES
@property (nonatomic, assign) BOOL isAutomaticallyManagingDateHeaders; // Defaults to YES
@property (nonatomic, assign) CGFloat spacingBetweenMessagesFromMeAndMessagesFromOthers;

@property (nonatomic, weak) id<MXRMessageCellFactoryDataSource> dataSource;
@property (nonatomic, weak) id<MXRMessageContentNodeDelegate> contentNodeDelegate;
@property (nonatomic, weak) id<MXRMessageMediaCollectionNodeDelegate> mediaCollectionDelegate;

- (instancetype)initWithCellConfigForMe:(MXRMessageCellConfiguration*)cellConfigForMe cellConfigForOthers:(MXRMessageCellConfiguration*)cellConfigForOthers;

- (MXRMessageTextCellNodeBlock)cellNodeBlockWithText:(NSString*)text tableNode:(ASTableNode*)tableNode row:(NSInteger)row;
- (MXRMessageImageCellNodeBlock)cellNodeBlockWithImageURL:(NSURL*)imageURL showsPlayButton:(BOOL)showsPlayButton tableNode:(ASTableNode*)tableNode row:(NSInteger)row;
- (MXRMessageMediaCollectionCellNodeBlock)cellNodeBlockWithMedia:(NSArray<id<MXRMessengerMedium>>*)media tableNode:(ASTableNode*)tableNode row:(NSInteger)row;

- (ASDisplayNode*)headerNodeFromDate:(NSDate*)date;
- (void)toggleDateHeaderNodeVisibilityForCellNode:(MXRMessageCellNode*)cellNode;
- (void)updateTableNode:(ASTableNode*)tableNode animated:(BOOL)animated withInsertions:(NSArray<NSIndexPath*>*)insertions deletions:(NSArray<NSIndexPath*>*)deletions reloads:(NSArray<NSIndexPath*>*)reloads completion:(void(^)(BOOL))completion;

@end


@interface MXRMessageAvatarConfiguration : NSObject

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat cornerRadius;

@end


@interface MXRMessageCellConfiguration : NSObject

@property (nonatomic, strong, readonly) MXRMessageCellLayoutConfiguration* layoutConfig;
@property (nonatomic, strong, readonly) MXRMessageAvatarConfiguration* avatarConfig;
@property (nonatomic, strong, readonly) MXRMessageTextConfiguration* textConfig;
@property (nonatomic, strong, readonly) MXRMessageImageConfiguration* imageConfig;
@property (nonatomic, strong, readonly) MXRMessageMediaCollectionConfiguration* mediaCollectionConfig;

- (instancetype)initWithLayoutConfig:(MXRMessageCellLayoutConfiguration*)layoutConfig avatarConfig:(MXRMessageAvatarConfiguration*)avatarConfig textConfig:(MXRMessageTextConfiguration*)textConfig imageConfig:(MXRMessageImageConfiguration*)imageConfig mediaCollectionConfig:(MXRMessageMediaCollectionConfiguration*)mediaCollectionConfig;

@end

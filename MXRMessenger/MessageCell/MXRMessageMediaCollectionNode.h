//
//  MXRMessageMediaCollectionNode.h
//  Mixer
//
//  Created by Scott Kensell on 4/4/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageContentNode.h"

#import "MXRMessengerMedium.h"

@class MXRMessageMediaCollectionConfiguration;
@class MXRMessageMediaCollectionNode;

@protocol MXRMessageMediaCollectionNodeDelegate <NSObject>

- (void)messageMediaCollectionNode:(MXRMessageMediaCollectionNode*)messageMediaCollectionNode didSelectMedium:(id<MXRMessengerMedium>)medium atIndexPath:(NSIndexPath*)indexPath;

@end

@interface MXRMessageMediaCollectionNode : MXRMessageContentNode <ASCollectionDataSource, ASCollectionDelegate>

@property (nonatomic, strong, readonly) ASCollectionNode* collectionNode;
@property (nonatomic, strong, readonly) NSArray<id<MXRMessengerMedium>>* media;
@property (nonatomic, weak) id<MXRMessageMediaCollectionNodeDelegate> mediaCollectionDelegate;

- (instancetype)initWithMedia:(NSArray<id<MXRMessengerMedium>>*)media configuration:(MXRMessageMediaCollectionConfiguration*)configuration cornersToApplyMaxRadius:(UIRectCorner)cornersHavingRadius NS_DESIGNATED_INITIALIZER;

@end


@interface MXRMessageMediaCollectionConfiguration : MXRMessageNodeConfiguration

@property (nonatomic, assign) CGFloat maxWidth;

@end

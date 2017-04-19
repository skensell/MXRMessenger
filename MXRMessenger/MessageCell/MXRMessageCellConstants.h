//
//  MXRMessageCellConstants.h
//  Mixer
//
//  Created by Scott Kensell on 2/26/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#ifndef MXRMessageCellConstants_h
#define MXRMessageCellConstants_h

/**
 * Determines which side to pin content to, and which side the avatar is on.
 */
typedef NS_ENUM(NSInteger, MXRMessageLayoutDirection) {
    /**
     * Avatar on Left. All content pinned to left.
     */
    MXRMessageLayoutDirectionLeftToRight = 0,
    
    /**
     * Avatar on Right. All content pinned to right.
     */
    MXRMessageLayoutDirectionRightToLeft = 1,
};

typedef NS_ENUM(NSInteger, MXRMessageContentType) {
    MXRMessageContentTypeTextOnly = 0,
    MXRMessageContentTypeImageOnly = 1,
    MXRMessageContentTypeMediaCollectionOnly = 2,
};

typedef NS_OPTIONS(NSInteger, MXRMessageMenuItemTypes) {
    MXRMessageMenuItemTypeNone = 0,
    MXRMessageMenuItemTypeCopy = (1 << 0),
    MXRMessageMenuItemTypeDelete = (1 << 1)
};

#endif /* MXRMessageCellConstants_h */

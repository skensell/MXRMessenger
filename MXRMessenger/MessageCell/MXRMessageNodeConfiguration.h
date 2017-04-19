//
//  MXRMessageNodeConfiguration.h
//  Mixer
//
//  Created by Scott Kensell on 3/31/17.
//  Copyright © 2017 Two To Tango. All rights reserved.
//

#import "MXRMessageCellConstants.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>

@interface MXRMessageNodeConfiguration : NSObject

@property (nonatomic, assign) CGFloat maxCornerRadius;
@property (nonatomic, assign) CGFloat minCornerRadius;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) MXRMessageMenuItemTypes menuItemTypes;
@property (nonatomic, assign) BOOL showsUIMenuControllerOnLongTap;

/**
 * Optional. Used to construct ASNetworkImageNodes.
 */
@property (nonatomic, strong) id<ASImageCacheProtocol> imageCache;
@property (nonatomic, strong) id<ASImageDownloaderProtocol> imageDownloader;


@end

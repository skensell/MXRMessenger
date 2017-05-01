//
//  MXRExampleViewController.m
//  MXRMessenger
//
//  Created by Scott Kensell on 4/18/17.
//  Copyright © 2017 Scott Kensell. All rights reserved.
//

#import "MXRExampleViewController.h"

#import <MXRMessenger/MXRMessageCellFactory.h>
#import <MXRMessenger/UIColor+MXRMessenger.h>

@interface MXRExampleViewController () <MXRMessageCellFactoryDataSource, MXRMessageContentNodeDelegate, MXRMessageMediaCollectionNodeDelegate, ASTableDelegate, ASTableDataSource>

@property (nonatomic, strong) MXRMessageCellFactory* cellFactory;
@property (nonatomic, strong) NSArray* messages;

@end

@implementation MXRExampleViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _messages = @[@"Hey Man! What's happening?" , @"Not too much!"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.node.tableNode.delegate = self; // actually redundant bc MXRMessenger sets it
    self.node.tableNode.dataSource = self;
    self.node.tableNode.allowsSelection = YES;
    
    MXRMessengerIconButtonNode* addPhotosBarButtonButtonNode = [MXRMessengerIconButtonNode buttonWithIcon:[[MXRMessengerPlusIconNode alloc] init] matchingToolbar:self.toolbar];
    [addPhotosBarButtonButtonNode addTarget:self action:@selector(tapAddPhotos:) forControlEvents:ASControlNodeEventTouchUpInside];
    self.toolbar.leftButtonsNode = addPhotosBarButtonButtonNode;
    [self.toolbar.defaultSendButton addTarget:self action:@selector(tapSend:) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [self customizeCellFactory];
    
    [self.node.tableNode reloadData];
}

- (void)customizeCellFactory {
    MXRMessageCellLayoutConfiguration* layoutConfigForMe = [MXRMessageCellLayoutConfiguration rightToLeft];
    MXRMessageCellLayoutConfiguration* layoutConfigForOthers = [MXRMessageCellLayoutConfiguration leftToRight];
    
    MXRMessageAvatarConfiguration* avatarConfigForMe = nil;
    MXRMessageAvatarConfiguration* avatarConfigForOthers = [[MXRMessageAvatarConfiguration alloc] init];
    
    MXRMessageTextConfiguration* textConfigForMe = [[MXRMessageTextConfiguration alloc] initWithFont:nil textColor:[UIColor whiteColor] backgroundColor:[UIColor mxr_fbMessengerBlue]];
    MXRMessageTextConfiguration* textConfigForOthers = [[MXRMessageTextConfiguration alloc] initWithFont:nil textColor:[UIColor blackColor] backgroundColor:[UIColor mxr_bubbleLightGrayColor]];
    CGFloat maxCornerRadius = textConfigForMe.maxCornerRadius;
    
    MXRMessageImageConfiguration* imageConfig = [[MXRMessageImageConfiguration alloc] init];
    imageConfig.maxCornerRadius = maxCornerRadius;
    MXRMessageMediaCollectionConfiguration* mediaCollectionConfig = [[MXRMessageMediaCollectionConfiguration alloc] init];
    mediaCollectionConfig.maxCornerRadius = maxCornerRadius;
    
    textConfigForMe.menuItemTypes |= MXRMessageMenuItemTypeDelete;
    textConfigForOthers.menuItemTypes |= MXRMessageMenuItemTypeDelete;
    imageConfig.menuItemTypes |= MXRMessageMenuItemTypeDelete;
    imageConfig.showsUIMenuControllerOnLongTap = YES;
    CGFloat s = [UIScreen mainScreen].scale;
    imageConfig.borderWidth = s > 0 ? (1.0f/s) : 0.5f;
    
    MXRMessageCellConfiguration* cellConfigForMe = [[MXRMessageCellConfiguration alloc] initWithLayoutConfig:layoutConfigForMe avatarConfig:avatarConfigForMe textConfig:textConfigForMe imageConfig:imageConfig mediaCollectionConfig:mediaCollectionConfig];
    MXRMessageCellConfiguration* cellConfigForOthers = [[MXRMessageCellConfiguration alloc] initWithLayoutConfig:layoutConfigForOthers avatarConfig:avatarConfigForOthers textConfig:textConfigForOthers imageConfig:imageConfig mediaCollectionConfig:mediaCollectionConfig];
    
    self.cellFactory = [[MXRMessageCellFactory alloc] initWithCellConfigForMe:cellConfigForMe cellConfigForOthers:cellConfigForOthers];
    self.cellFactory.dataSource = self;
    self.cellFactory.contentNodeDelegate = self;
    self.cellFactory.mediaCollectionDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - Target-Action

- (void)tapAddPhotos:(id)sender {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Photos!" message:@"You should present a photo picker here." preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)tapSend:(id)sender {
    NSString* text = [self.toolbar clearText];
    if (text.length == 0) return;
//    [self sendMessage:nil];
}

- (void)sendMessage:(NSDictionary*)messageDic {
    // TODO
}

#pragma mark - MXMessageCellFactoryDataSource

- (BOOL)cellFactory:(MXRMessageCellFactory *)cellFactory isMessageFromMeAtRow:(NSInteger)row {
    // TODO
    return row == 0;
}

- (NSURL *)cellFactory:(MXRMessageCellFactory *)cellFactory avatarURLAtRow:(NSInteger)row {
    // TODO: put an avatar here
    return [self cellFactory:cellFactory isMessageFromMeAtRow:row] ? nil : nil;
}

- (NSTimeInterval)cellFactory:(MXRMessageCellFactory *)cellFactory timeIntervalSince1970AtRow:(NSInteger)row {
    // TODO
    return 1.0f;
}

#pragma mark - ASTable

- (NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section { return self.messages.count; }

- (ASCellNodeBlock)tableNode:(ASTableNode *)tableNode nodeBlockForRowAtIndexPath:(NSIndexPath *)indexPath {
    id message = self.messages[indexPath.row];
    // TODO
    NSURL* imageURL = nil;
    NSURL* videoURL = nil;
    NSArray* mediaArray = nil;
    NSString* text = (NSString*)message;
    if (mediaArray.count > 1) {
        return [self.cellFactory cellNodeBlockWithMedia:mediaArray tableNode:tableNode row:indexPath.row];
    } else if (imageURL) {
        return [self.cellFactory cellNodeBlockWithImageURL:imageURL showsPlayButton:(videoURL != nil) tableNode:tableNode row:indexPath.row];
    } else {
        return [self.cellFactory cellNodeBlockWithText:text tableNode:tableNode row:indexPath.row];
    }
}

- (void)tableNode:(ASTableNode *)tableNode didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self dismissKeyboard];
    [tableNode deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - MXMessageContentNodeDelegate

- (void)messageContentNode:(MXRMessageContentNode *)node didTapMenuItemWithType:(MXRMessageMenuItemTypes)menuItemType {
    if (menuItemType == MXRMessageMenuItemTypeDelete) {
        ASDisplayNode* supernode = [node supernode];
        if ([supernode isKindOfClass:[MXRMessageCellNode class]]) {
            [self deleteCellNode:(MXRMessageCellNode*)supernode];
        }
    }
}

- (void)messageContentNode:(MXRMessageContentNode *)node didSingleTap:(id)sender {
    if (![node.supernode isKindOfClass:[MXRMessageCellNode class]]) return;
    MXRMessageCellNode* cellNode = (MXRMessageCellNode*)node.supernode;
    if ([node isKindOfClass:[MXRMessageImageNode class]]) {
        // present a media viewer
        NSLog(@"Single tapped an image");
        return;
    } else if ([node isKindOfClass:[MXRMessageTextNode class]]) {
        NSLog(@"Single tapped text");
        [self.cellFactory toggleDateHeaderNodeVisibilityForCellNode:cellNode];
    }
}

#pragma mark - MXMessageMediaCollectionNodeDelegate

- (void)messageMediaCollectionNode:(MXRMessageMediaCollectionNode *)messageMediaCollectionNode didSelectMedium:(id<MXRMessengerMedium>)medium atIndexPath:(NSIndexPath *)indexPath {
    // Show a media viewer
}

#pragma mark - Helper

- (void)deleteCellNode:(ASCellNode*)cellNode {
    NSIndexPath* indexPath = [cellNode indexPath];
    if (!indexPath) return;
    // delete cell in model
}

@end
